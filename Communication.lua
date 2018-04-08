local CommunicationClient = {}

CommunicationClient.Modems = {}
CommunicationClient.CurrentModem = nil
CommunicationClient.ID = "ID_NOT_SET" .. math.random(1, 999999)

CommunicationClient.QueueConfig = {
    Channel = 31000,
    ReplyChannel = 32000,
    Ping = 30,
}





local Modem = {}
Modem.MESSAGES = {
    GET_QUEUE = {
        QUERY = "GET_QUEUE"
    },
    STATUS = {
        QUERY = "STATUS"
    }
}






function Modem:IsOpen(channel)
    if type(channel) == "number" then
        return self.Modem.isOpen(channel)
    end
    return false
end

function Modem:Open(channel)
    -- 0 < channel < 65535
    if type(channel) == "number" then
        if not self:IsOpen(channel) then
            self.Modem.open(channel)
            self.Channels[channel] = true
        end
    end
end

function Modem:Close(channel)
    if type(channel) == "number" then
        if self:IsOpen(channel) then
            self.Modem.close(channel)
            self.Channels[channel] = nil
        end
    end
end

function Modem:Transmit(channel, message, recipient)
    self:Open(channel)

    local tMessage = {
        Recipient = recipient,
        Message = message,
        Sender = CommunicationClient.ID
    }

    self.Modem.transmit(channel, channel, tMessage)
end

function Modem:Receive(timeout, channel)
    self:Open(channel)
    if timeout then
        timeout = os.startTimer(timeout)
    end
    while true do
        local event, side, frequency, replyFrequency, message, distance = os.pullEvent()
        if event == "timer" and side == timeout then
            return false, "Timeout"
        elseif event == "modem_message" then
            if type(message) == "table" then
                if message.Recipient == CommunicationClient.ID then
                    if channel and frequency == channel then
                        return {Channel = frequency, ReplyChannel = replyFrequency, Distance = distance, Message = message.Message, Sender = message.Sender}
                    elseif not channel then
                        return {Channel = frequency, ReplyChannel = replyFrequency, Distance = distance, Message = message.Message, Sender = message.Sender}
                    end
                end
            end
        end
    end
end

function CommunicationClient:Init(tID)
    if tID then
        self.ID = tID
    end
    local peripheralSides = peripheral.getNames()
    for k,v in pairs(peripheralSides) do
        if peripheral.getType(v) == "modem" then
            local tw = peripheral.wrap(v)
            self.Modems[v] = {
                Wireless = tw.isWireless(),
                Modem = tw,
                Channels = {},
                Queue = {},
                LastResponse = 0
            }
        end
    end
end

function CommunicationClient:GetModem(isWireless)
    isWireless = isWireless or false
    for k, v in pairs(self.Modems) do
        if v.Wireless == isWireless then
            for i, j in pairs(v) do
                Modem[i] = j
            end
            return setmetatable(Modem, {})
        end
    end
end

function CommunicationClient:GetQueue()
    if not self.CurrentModem then
        self.CurrentModem = self:GetModem()
    end
    self.CurrentModem:Open(self.QueueConfig.ReplyChannel)
    self.CurrentModem:Transmit(self.QueueConfig.Channel, self.MESSAGES.GET_QUEUE)
    local QueueResponse = self.CurrentModem:Receive(self.QueueConfig.ReplyChannel, 5) -- timeout: 5 seconds

    if type(QueueResponse) == "table" then
        if QueueResponse.Recipient == self.ID then
            if QueueResponse.Action then

            end
        end
    end
end

function CommunicationClient:SetQueue(id, action)
    local tAction = {
        Recipient = id,
        Action = action,
        Sender = self.ID,
    }

    table.insert(self.CurrentModem.Queue, #self.CurrentModem.Queue + 1, tAction)
end



return setmetatable(CommunicationClient, {})
