---------------------------------------
------------- [Command] Toggles whether or not oil spills are cleaned up
---------------------------------------

---@param command af_services_commands_command
---@param args table<integer, string>
---@param player af_services_player_player
AuroraFramework.services.commandService.create(function(command, args, player)
    chatAnnounce("-----------")
    chatAnnounce(server.getOilSpill(player:getPosition()))
    server.setOilSpill(player:getPosition(), 0)
    chatAnnounce(server.getOilSpill(player:getPosition()))
    chatAnnounce("-----------")
end, "test", {"t"}, false, "Toggles oil spill cleanup.")