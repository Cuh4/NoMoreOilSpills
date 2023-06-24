---------------------------------------
------------- [Command] Toggles whether or not oil spills are cleaned up
---------------------------------------

---@param command af_services_commands_command
---@param args table<integer, string>
---@param player af_services_player_player
AuroraFramework.services.commandService.create(function(command, args, player)
    if not player.properties.admin then
        return announceLibrary.status.failure("This command requires admin.", player)
    end

    local enabled = oilSpillCleanupEnabled
    oilSpillCleanupEnabled = not enabled

    chatAnnounce(player.properties.name.." has "..AuroraFramework.libraries.miscellaneous.switchbox("disabled", "enabled", not enabled).." oil spill cleanup.")
end, "oc_toggle", {"oct"}, false, "Toggles oil spill cleanup.")