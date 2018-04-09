-- FIRST : IMPORTANT!
-- SLEEP for X amount of time, to assure that the modem has connected properly
sleep(1)

local IDs = {
    [33] = "Servers/SERVER_DIAGNOSTICS",
    [34] = "Clients/TEST_CONTROLLER",
    [36] = "Clients/CLIENT_POWER_JUNCTION_1_5",
    [37] = "Servers/SERVER_QUEUE",
}

function watcher()
    if (IDs[os.getComputerID()]) then
        _G.ID = string.match(IDs[os.getComputerID()], "[^/]+$")

        shell.run(fs.combine(IDs[os.getComputerID()], "main.lua"))
    else
        printError("ID Not set up")
    end
end

local ok, err = pcall(watcher)
if not ok then
    printError("Error: " .. tostring(err))
    error()
end
print("Done")
