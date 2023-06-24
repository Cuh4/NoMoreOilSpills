---------------------------------------
------------- Debug
---------------------------------------

------------- Variables
local debug_addon_name = "Debug library hasn't been initialized."

------------- Library
debugLibrary = {
    initialize = function()
        -- check
        if not debugLibrary.debugEnabled() then
            return
        end

        -- set addon name
        local index = server.getAddonIndex()
        debug_addon_name = server.getAddonData(index).name

        -- alive loop
        AuroraFramework.libraries.timer.loop.create(1, function()
            df.print("alive", "debugLibrary.initialize")
        end)
    end,

    debugEnabled = function()
        return config.debugEnabled
    end,

    print = function(toPrint, source)
        if not debugLibrary.debugEnabled() then
            return
        end

        local tostringed = tostring(toPrint)
        local new = "DEBUG | "..debug_addon_name.." - "..tostringed..(" (%s)"):format(source or "No source specified.")

        if config.debugShouldLog then
            debug.log(new)
        else
            chatAnnounce(new)
        end
    end,

    printTbl = function(tbl, indent, source)
        if not indent then
            indent = 0
        end

        for i, v in pairs(tbl) do
            formatting = string.rep("  ", indent)..i..": "

            if type(v) == "table" then
                df.print(formatting, source)
                df.printTbl(v, indent + 1)
            else
                df.print(formatting..tostring(v), source)
            end
        end
    end
}

df = debugLibrary