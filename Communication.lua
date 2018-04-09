local Communication = {}

Communication.Modem = nil

Communication.Config = {
    SERVER_TO_CLIENT = 31000,
    CLIENT_TO_SERVER = 32000,
    CONNECTION_PING = 30,
}

Communication.Requests = {
    GET_QUEUE = "GET_QUEUE"
}

function Communication:Init(Modem)
    if Modem then
        self.Modem = Modem
    end
end

function Communication:Listen()
    local Received = self.Modem:Receive(self.Config.SERVER_TO_CLIENT)
    if type(Received) == "table" then
        if Received.Recipient == ID then
            if Received.Action then
                return Received
            end
            return Received
        end
    end
    return false
end

function Communication:ListenServer()
    local Received = self.Modem:Receive(self.Config.CLIENT_TO_SERVER)
    if type(Received) == "table" then
        if Received.Recipient == ID then
            if Received.Action then
                return Received
            end
            return Received
        end
    end
    return false
end

function Communication:GetQueue()
    self.Modem:Transmit(self.Config.CLIENT_TO_SERVER, self.Config.SERVER_TO_CLIENT, self.Requests.GET_QUEUE, "SERVER_QUEUE")
    local QueueResponse = self.Modem:Receive(self.Config.SERVER_TO_CLIENT, 3) -- timeout: 1.5 seconds

    if type(QueueResponse) == "table" then
        if QueueResponse.Recipient == ID then
            return QueueResponse
        end
    end
    return false, "timeout"
end

return setmetatable(Communication, {})
