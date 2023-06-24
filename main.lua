--------------
--[[
    cuhHub - No More Oil Spills
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
oilSpillCleanupEnabled = true

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
-- Oil Cleanup
AuroraFramework.game.callbacks.onOilSpill.main:connect(function(tile_x, tile_y, delta, total, vehicle_id)
    -- don't clean if disabled
    if not oilSpillCleanupEnabled then
        return
    end

    -- clear oil
    server.setOilSpill(matrix.translation(tile_x, 0, tile_y), 0)
    chatAnnounce("oil spill cleaned")

    -- no vehicle, just oil spill update or something
    if vehicle_id == -1 then
        return
    end

    -- if there's a vehicle, then we should probably clean the area around the vehicle
    local pos = server.getVehiclePos(vehicle_id)
    server.setOilSpill(pos, 0)
end)