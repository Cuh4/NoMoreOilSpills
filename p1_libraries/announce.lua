---------------------------------------
------------- Announce
---------------------------------------

------------- Variables
local notifTitle = "["..config.info.addonName.."]"

local announceID = 0
local announce_ui = AuroraFramework.services.UIService.createScreenUI(2500, "", 0, 0)
announce_ui.properties.visible = false
announce_ui:refresh()

------------- Library
announceLibrary = {
	status = {
        ---@param player af_services_player_player
        success = function(msg, player)
            AuroraFramework.services.notificationService.custom(notifTitle.." Success", msg, player, 4)
        end,

        ---@param player af_services_player_player
        warning = function(msg, player)
            AuroraFramework.services.notificationService.custom(notifTitle.." Warning", msg, player, 1)
        end,

        ---@param player af_services_player_player
        failure = function(msg, player)
            AuroraFramework.services.notificationService.custom(notifTitle.." Failure", msg, player, 2)
        end,

        ---@param player af_services_player_player
        status = function(msg, player)
            AuroraFramework.services.notificationService.custom(notifTitle.." Status", msg, player, 11)
        end
    },

	reminder = function(msg)
        AuroraFramework.services.notificationService.custom(notifTitle.." Reminder", msg, nil, 8)
	end,

    popupAnnounce = function(text, timer)
        -- id stuff
        announceID = announceID + 1

        -- main
        announce_ui.properties.text = text
        announce_ui.properties.visible = true
        announce_ui:refresh()

        -- remove after some time
        local old = announceID
        AuroraFramework.libraries.timer.delay.create(timer or 10, function()
            if announceID ~= old then
                return
            end

            announce_ui.properties.visible = false
            announce_ui:refresh()
        end)
    end
}