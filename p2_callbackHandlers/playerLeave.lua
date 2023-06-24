------------- Player Leave
AuroraFramework.services.playerService.events.onLeave:connect(function(player) ---@param player af_services_player_player
    -- Checks
    if miscellaneousLibrary.unnamedClientOrServer(player) then
        return
    end

    -- Remove
    for i, currentPlayer in pairs(playersUnfiltered) do
        if AuroraFramework.services.playerService.isSamePlayer(player, currentPlayer) then
            table.remove(playersUnfiltered, i)
        end
    end
end)