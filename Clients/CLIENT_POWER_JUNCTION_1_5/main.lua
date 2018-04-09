local Modem = loadfile("/Modem.lua")()
Modem:Init()

local Communication = loadfile("/Communication.lua")()
Communication:Init(Modem)

function Listener()
    while true do
        local response = Communication:Listen()
        if response then
            --print(tostring(response))
            if type(response) == "table" then
                print("Received message from " .. response.Sender)
                print("Action " .. response.Message)
                local ok, err = pcall(function() return loadstring(response.Message)() end)
                if not ok then
                    Modem:Transmit(Communication.Config.CLIENT_TO_SERVER, Communication.Config.SERVER_TO_CLIENT, "ERROR: " .. tostring(err), "TEST_CONTROLLER")
                else
                    Modem:Transmit(Communication.Config.CLIENT_TO_SERVER, Communication.Config.SERVER_TO_CLIENT, "DONE", "TEST_CONTROLLER")
                end
                print("Command completed!")
            end
        else
            print("Unknown action: " .. tostring(response))
        end
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

parallel.waitForAny(Listener, Ping)
--Modem:Transmit(25, "Hello World", "SERVER_DIAGNOSTICS")
