local repo = "TurtleMiner"
local name = "mikk809h"

local function get(repoFile,saveTo)
  local download = http.get("https://raw.github.com/" .. name .. "/" .. repo .. "/" .. repoFile)
  if download then
    local handle = download.readAll()
    download.close()
    local file = fs.open(saveTo,"w")
    file.write(handle) 
    file.close()
  else
    print("Unable to download the file "..repoFile)
    print("Make sure you have the HTTP API enabled or")
    print("an internet connection!")
  end
end
