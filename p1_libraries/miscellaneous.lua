---------------------------------------
------------- Miscellaneous
---------------------------------------

------------- Library
miscellaneousLibrary = {
    ---@param pos SWMatrix
    getClosestPlayerToPosition = function(pos)
        local closest = nil
        local dist = nil

        for _, player in pairs(AuroraFramework.services.playerService.getAllPlayers()) do
            -- quick check
            if miscellaneousLibrary.unnamedClientOrServer(player) then
                goto continue
            end

            -- see if close
            local plrPos = player:getPosition()
            local distance = matrix.distance(plrPos, pos)

            if not closest or not dist then
                goto success
            end

            if distance <= dist then
                goto success
            end

            -- found closest player
            ::success::
            closest = player
            dist = distance

            -- continue
            ::continue::
        end

        return closest, dist or 0
    end,

    ---@return string
    surround = function(input, with)
        return with:sub(1, 1)..input..with:sub(-1, -1)
    end,

    stringBeforeAfter = function(before, string, after)
        return before..string..after
    end,

    aOrAn = function(str)
        local first_character = str:sub(1, 1):lower()

        if ("aeiou"):find(first_character:lower()) then
            return "an "
        end

        return "a "
    end,

    ---@param player af_services_player_player
    unnamedClientOrServer = function(player)
        if not player then
            return true
        end

        return (player.properties.peer_id == 0 and config.isDedicatedServer) or player.properties.steam_id == 0
    end,

    ---@param pos SWMatrix
    matrixFormatted = function(pos)
        return AuroraFramework.libraries.miscellaneous.round(pos[13], 1)..", "..AuroraFramework.libraries.miscellaneous.round(pos[14], 1)..", "..AuroraFramework.libraries.miscellaneous.round(pos[15], 1)
    end,

    getPlayerCount = function()
        local count = 0

        for _, v in pairs(AuroraFramework.services.playerService.getAllPlayers()) do
            if not miscellaneousLibrary.unnamedClientOrServer(v) then
                count = count + 1
            end
        end

        return count
    end,

    pluralOrSingular = function(input)
        if tonumber(input) == 1 then
            return ""
        else
            return "s"
        end
    end,

    ---@return "object"|"vehicle"|nil
    isVehicleOrObject = function(id)
        local _, is_vehicle = server.getVehicleData(id)

        if is_vehicle then
            return "vehicle"
        else
            return "object"
        end
    end,

    groupCall = function(functions, ...)
        for i, v in pairs(functions) do
            v(...)
        end
    end,

    addCommas = function(number)
        local formatted = tostring(number)
        local k = 3

        while true do
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2', k)

            if k == 0 then
                break
            end
        end

        return formatted
    end,

    tableToString = function(tbl)
        local str = {}
        local indent = 0

        function check(t)
            indent = indent + 2

            for i, v in pairs(t) do
                table.insert(str, string.rep(" ", indent)..i.." - "..tostring(v))

                if type(v) == "table" then
                    check(v)
                end
            end
        end

        check(tbl)
        return table.concat(str, "\n")
    end,

    ---@param input string
    strToName = function(input)
        return input:sub(1, 1):upper()..input:sub(2, -1):lower()
    end,

    percentageOfNumber = function(number, percentage)
        return number * (percentage / 100)
    end
}