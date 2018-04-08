local ID = os.getComputerID()

local IDs = {
    [33] = "Servers/SERVER_DIAGNOSTICS",
    [34] = "Clients/CLIENT_POWER_JUNCTION_1_5",
}

function watcher()
    shell.run(fs.combine(IDs[ID], "main.lua"))
end

local ok, err = pcall(watcher)
if not ok then
    printError("Error: " .. tostring(err))
    error()
end
print("Done")
