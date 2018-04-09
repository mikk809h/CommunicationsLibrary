local Modem = loadfile("/Modem.lua")()
Modem:Init()
local Communication = loadfile("/Communication.lua")()
Communication:Init(Modem)

Modem:Transmit(Communication.Config.SERVER_TO_CLIENT, Communication.Config.CLIENT_TO_SERVER, "if turtle.detect() then turtle.dig() turtle.placeUp() else turtle.digUp() turtle.place() end", "CLIENT_POWER_JUNCTION_1_5")
