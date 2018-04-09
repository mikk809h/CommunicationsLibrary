local Modem = {}
Modem.Channels = {}
Modem.MODEM = nil

function Modem:Init(Wired)
    print("ID: " .. ID)
    -- Inits the modem attached. If Wired is specified to true, then it will only wrap a Wired modem, or none.
    local peripheralSides = peripheral.getNames()
    for k,v in pairs(peripheralSides) do
        if peripheral.getType(v) == "modem" then
            local tw = peripheral.wrap(v)
            if (not Wired) and tw.isWireless() then
                Modem.MODEM = tw
                break
            elseif Wired and (not tw.isWireless()) then
                Modem.MODEM = tw
                break
            end
        end
    end
    return false, "No modem found"
end

function Modem:IsOpen(Channel)
    if type(Channel) == "number" then
        return self.MODEM.isOpen(Channel)
    end
    return false
end

function Modem:Open(Channel)
    -- 0 < Channel < 65535
    if type(Channel) == "number" then
        if not self:IsOpen(Channel) then
            self.MODEM.open(Channel)
            self.Channels[Channel] = true
        end
    end
end

function Modem:Close(Channel)
    if type(Channel) == "number" then
        if self:IsOpen(Channel) then
            self.MODEM.close(Channel)
            self.Channels[Channel] = nil
        end
    end
end

function Modem:Transmit(Channel, Message, Recipient)
    self:Open(Channel)

    local tMessage = {
        Recipient = Recipient or "*",
        Message = Message,
        Sender = ID
    }

    self.MODEM.transmit(Channel, Channel, tMessage)
end

--[[
    @param Channel if set, specifies a whitelisted Channel to ONLY listen to.
    @param Timeout specifies a Timeout.
]]
function Modem:Receive(Channel, Timeout)
    self:Open(Channel)
    if Timeout then
        Timeout = os.startTimer(Timeout)
    end
    while true do
        local event, side, frequency, replyFrequency, message, distance = os.pullEvent()
        if event == "timer" and side == Timeout then
            return false, "Timeout"
        elseif event == "modem_message" then
            if type(message) == "table" then
                if message.Recipient == ID then
                    if Channel and frequency == Channel then
                        return {Channel = frequency, ReplyChannel = replyFrequency, Distance = distance, Message = message.Message, Sender = message.Sender, Recipient = message.Recipient}
                    elseif not Channel then
                        return {Channel = frequency, ReplyChannel = replyFrequency, Distance = distance, Message = message.Message, Sender = message.Sender, Recipient = message.Recipient}
                    end
                end
            end
        end
    end
end

return setmetatable(Modem, _ENV)
