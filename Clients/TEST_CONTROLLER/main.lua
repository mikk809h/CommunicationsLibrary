local Modem = loadfile("/Modem.lua")()
Modem:Init()
local Communication = loadfile("/Communication.lua")()
Communication:Init(Modem)

Modem:Transmit(Communication.Config.SERVER_TO_CLIENT, Communication.Config.CLIENT_TO_SERVER, "Hello World", "CLIENT_POWER_JUNCTION_1_5")
