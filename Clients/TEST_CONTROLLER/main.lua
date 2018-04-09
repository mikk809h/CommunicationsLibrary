local Modem = loadfile("/Modem.lua")()
Modem:Init()
local Communication = loadfile("/Communication.lua")()
Communication:Init(Modem)

Modem:Transmit(Communication.Config.SERVER_TO_CLIENT, "Hello World", "CLIENT_POWER_JUNCTION_1_5")
