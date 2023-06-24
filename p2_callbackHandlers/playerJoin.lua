------------- Player Join
AuroraFramework.services.playerService.events.onJoin:connect(function(player) ---@param player af_services_player_player
    -- Checks
    if miscellaneousLibrary.unnamedClientOrServer(player) then
        return
    end

    -- Add
    table.insert(playersUnfiltered, player)

    -- Credit
    AuroraFramework.services.chatService.sendMessage(
        miscellaneousLibrary.surround(config.info.addonName, "[]"), 
        "Welcome! This server uses the '"..config.info.addonName.."' addon created by "..config.info.author.." [Discord], a cuhHub developer.\nType '?help' for help, and consider joining the Discord @ "..config.info.invite..".\n"..
            AuroraFramework.libraries.miscellaneous.switchbox("", "[Weapons DLC Required] ", config.info.weaponsRequired)..
            AuroraFramework.libraries.miscellaneous.switchbox("", "[Arid DLC Required]", config.info.aridRequired),
        player
    )
end)