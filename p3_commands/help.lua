---------------------------------------
------------- [Command] Shows all commands
---------------------------------------

---@param command af_services_commands_command
---@param args table<integer, string>
---@param player af_services_player_player
AuroraFramework.services.commandService.create(function(command, args, player)
    -- Pack commands into table
    local commands = {}

    for i, v in pairs(AuroraFramework.services.commandService.commands) do
        -- probably an admin/internal/debug command
        if v.properties.description == "" then
            goto continue
        end

        -- shorthands stuff
        local shorthands = {}

        for _, shorthand in pairs(v.properties.shorthands) do
            table.insert(shorthands, "?"..shorthand)
        end

        -- add to commands list but nice and formatted
        table.insert(commands, "?"..v.properties.name.."\n     \\___"..table.concat(shorthands, ", ").."\n     \\___"..v.properties.description)

        ::continue::
    end

    -- Show commands and help message
    if not commands[1] then
        commands[1] = "This addon has no commands."
    end

    chatAnnounce("// Help\n"..config.info.helpMessage.."\n\n// Commands:\n"..table.concat(commands, "\n"), player)
end, "help", {"h"}, false, "Shows all commands along with help.")