---------------------------------------
------------- Command - Toggles whether or not creatures are hostile
---------------------------------------

------------- ?toggle
---@param command af_services_commands_command
---@param args table<integer, string>
---@param player af_services_player_player
AuroraFramework.services.commandService.create(function(command, args, player)
    if not player.properties.admin then
        return announceLibrary.status.failure("This command requires admin.", player)
    end

    local enabled = creatureLibrary.control.isEnabled()
    creatureLibrary.control.setEnabled(not enabled)

    announceLibrary.status.success(
        AuroraFramework.libraries.miscellaneous.switchbox(
            "[Disabled] Creatures will now be peaceful.",
            "[Enabled] Creatures will now be hostile.",
            not enabled
        ),

        player
    )

    chatAnnounce(player.properties.name.." has "..AuroraFramework.libraries.miscellaneous.switchbox("disabled", "enabled", not enabled).." creature hostility.")
end, "toggle", {"t"}, false, "Toggles global creature hostility.")