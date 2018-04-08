local ID = os.getComputerID()


if ID == 33 then -- Diagnostics server:

    local Communication = loadfile("Communication.lua")()
    Communication:Init("SERVER_DIAGNOSTICS")
    local Modem = Communication:GetModem(true)
    Modem:Open(25)
    while true do
        local x = Modem:Receive()
        print(textutils.serialize(x))
    end

elseif ID == 34 then -- transmitter

    local Communication = loadfile("Communication.lua")()
    Communication:Init("CLIENT_POWER_JUNCTION_1_5")
    local Modem = Communication:GetModem(true)
    Modem:Transmit(25, "Hello World", "SERVER_DIAGNOSTICS")
end
