local function checkArtifactVersion()
  local versionConvar = GetConvar("version", "unknown")
  local fxServerVersion = string.match(versionConvar, "v%d+%.%d+%.%d+%.(%d+)")

  PerformHttpRequest("https://artifacts.jgscripts.com/check?artifact=" .. fxServerVersion, function (code, data, _, errorData)
    if code ~= 200 or errorData then
      return print("^1Could not check artifact version^0")
    end
    
    if not data then return end

    local json = json.decode(data)
  
    if json.status == "BROKEN" then
      print("^1WARNING: The current FXServer version you are using (artifacts version) has known issues. Please update to the latest stable artifacts: https://artifacts.jgscripts.com^0")
      print("^0Artifact version:^3", fxServerVersion, "\n^0Known issues:^3", json.reason, "^0")
      return 
    end

    -- return print("^2Artifacts ok.^0")
  end)
end

CreateThread(function()
  checkArtifactVersion()
end)