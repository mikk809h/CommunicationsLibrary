local Modem = loadfile("/Modem.lua")()
Modem:Init()

local Communication = loadfile("/Communication.lua")()
Communication:Init(Modem)

local Queue = {}
local Errors = {}
function Listener()
    while true do
        local response = Communication:Listen()
        if response then
            --print(tostring(response))
            if type(response) == "table" then
                print("Received message from " .. response.Sender)
                print("Action " .. response.Message)
                table.insert(Queue, 1, { Completed = false, Action = response.Message })
                --print(textutils.serialize(response))
            end
        else
            print("Unknown action: " .. tostring(response))
        end
        os.queueEvent("1")
        os.pullEvent("1")
    end
end

function Ping()
    while true do
        --write("Pinging... ")
        local queue = Communication:GetQueue()
        if queue then
            print("Ping")
        end
        --print("pong")
        sleep(Communication.Config.CONNECTION_PING)
    end
end

function HandleQueue()
    while true do
        if #Queue > 0 then
            -- Handle queue from beginning
            local ok, err = pcall(function() return loadstring(Queue[1].Action)() end)
            if not ok then
                Queue[1].Completed = true
                table.insert(Errors, 1, Queue[1])
                print("Action error: " .. tostring(ok) .. " | " .. tostring(err))
            else
                print("Action completed: " .. tostring(ok) .. " | " .. tostring(err))
                Queue[1].Completed = true
            end
            if Queue[1].Completed == true then
                table.remove(Queue, 1)
            end
        end
        os.queueEvent("2")
        os.pullEvent("2")
    end
end

parallel.waitForAny(Listener, Ping, HandleQueue)
--Modem:Transmit(25, "Hello World", "SERVER_DIAGNOSTICS")
