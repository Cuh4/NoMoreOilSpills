--------------
--[[
    cuhHub - No More Oil
    Created by cuh5_ (Discord)
    This addon uses the Aurora Framework. (https://github.com/Roozz1/AuroraFramework)
]]

--[[
    UI IDs:
        2500 = Announcement Popup
]]
--------------

----------------------------------------------------------------
-- Variables
----------------------------------------------------------------
---@type table<integer, af_services_player_player>
playersUnfiltered = {}

----------------------------------------------------------------
-- Functions
----------------------------------------------------------------
------------- Uncategorised
---@param player af_services_player_player|nil
chatAnnounce = function(message, player)
    AuroraFramework.services.chatService.sendMessage(miscellaneousLibrary.surround(config.info.addonName, "[]"), message, player, true)
end

---@param player af_services_player_player|nil
notificationAnnounce = function(message, player)
    AuroraFramework.services.notificationService.custom(miscellaneousLibrary.surround(config.info.addonName, "[]"), message, player, 7)
end

---@return af_services_player_player
getRandomPlayer = function()
    return AuroraFramework.libraries.miscellaneous.getRandomTableValue(playersUnfiltered)
end

----------------------------------------------------------------
-- Setup
----------------------------------------------------------------
------------- Reload
-- Remove UI
server.removePopup(-1, 2500)

------------- Inits
debugLibrary.initialize()

----------------------------------------------------------------
-- Main
----------------------------------------------------------------