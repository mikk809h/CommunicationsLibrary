local Communication = loadfile("Communication.lua")()
Communication:Init("CLIENT_POWER_JUNCTION_1_5")

local Modem = Communication:GetModem(true)
Modem:Transmit(25, "Hello World", "SERVER_DIAGNOSTICS")
