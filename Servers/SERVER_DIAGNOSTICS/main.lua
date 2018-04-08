local Communication = loadfile("/Communication.lua")()
Communication:Init("SERVER_DIAGNOSTICS")

local Modem = Communication:GetModem(true)
Modem:Open(25)

while true do
    local x = Modem:Receive()
    print(textutils.serialize(x))
end
