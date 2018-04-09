local Modem = loadfile("/Modem.lua")()
Modem:Init()

local Communication = loadfile("/Communication.lua")()
Communication:Init(Modem)


while true do
    local x = Communication:Listen()
    print(textutils.serialize(x))
end
