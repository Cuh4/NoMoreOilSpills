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
------------- Cooldown
local cooldowns = {}
cooldown = function(time, key)
    if cooldowns[key] then
        return true
    end

    cooldowns[key] = false

    AuroraFramework.libraries.timer.delay.create(time, function()
        cooldowns[key] = nil
    end)

    return false
end

------------- Oil
---@param pos SWMatrix
clearOil = function(pos)
    server.setOilSpill(pos, -100) -- v
    server.setOilSpill(pos, 0) -- too lazy to test if there's a difference
end

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
-- Oil Cleanup via player position
AuroraFramework.libraries.timer.loop.create(0.1, function()
    if not oilSpillCleanupEnabled then
        return
    end

    for _, player in pairs(AuroraFramework.services.playerService.getAllPlayers()) do
        local pos = player:getPosition()
        pos[14] = 0
    
        clearOil(pos)
    end
end)

-- Oil Cleanup via callback
AuroraFramework.game.callbacks.onOilSpill.main:connect(function(tile_x, tile_z, delta, total, vehicle_id)
    if not oilSpillCleanupEnabled then
        return
    end

    -- clear oil
    local true_x = tile_x * 1000 -- 1 tile = 1000m/1km
    local true_z = tile_z * 1000

    clearOil(matrix.translation(true_x, 0, true_z))

    -- clear oil, but for every pos in the tile
    if cooldown(3, "oilDetailedCleanup") then
        goto next
    end

    AuroraFramework.services.chatService.sendMessage("wuh!", "no cooldown for detailed cleanup, so dtailed cleanup bla lba")

    for x = 1, 1000, 200 do -- 200 meter steps for performance
        local actualX = true_x + x

        for z = 1, 1000, 200 do
            local actualZ = true_z + z
            local pos = matrix.translation(actualX, 0, actualZ)

            clearOil(pos)
        end
    end

    ::next::

    -- no vehicle, just oil spill update or something
    if vehicle_id == -1 then
        return
    end

    -- if there's a vehicle, then we should probably clean the area around the vehicle
    local pos = server.getVehiclePos(vehicle_id)
    pos[14] = 0

    clearOil(pos)
end)

---@param player af_services_player_player
AuroraFramework.services.commandService.create(function(command, args, player)
    local pos = player:getPosition()

    for i = 1, 500 do
        server.setOilSpill(AuroraFramework.libraries.matrix.randomOffset(pos, 100), 100)
    end
end, "goo", {"g"})