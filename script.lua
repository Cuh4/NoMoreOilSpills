-----------------
-- [Library] config.lua
-----------------
config = {
    info = {
        addonName = "No More Oil Spills",
        author = "cuh5_",
        invite = "https://discord.gg/zTQxaZjwDr",
        helpMessage = "Tired of the ocean being polluted with oil? No more! This addon cleans up all oil spills automatically.",

        aridRequired = false,
        weaponsRequired = false
    },

    isDedicatedServer = false, -- doesn't matter for this addon
    debugEnabled = true,
    debugShouldLog = true
}

-----------------
-- [Library | Folder: p0_framework] AuroraFramework.lua
-----------------
------------------------------------------------------------------------------------------------------------------------
    -- Aurora Framework || A reliable addon creation framework designed for future cuhHub addons.
	-- 		Created by cuh4#7366
	--		cuhHub: https://discord.gg/zTQxaZjwDr
------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--// Framework \\--
--------------------------------------------------------------------------------
AuroraFramework = {
	game = {},
	libraries = {},
	services = {}
}

--------------------------------------------------------------------------------
--// Libraries \\--
--------------------------------------------------------------------------------
---------------- Matrix
AuroraFramework.libraries.matrix = {}

-- Offsets the position by x, y, and z
---@param position SWMatrix
---@param x number|nil 0 if nil
---@param y number|nil 0 if nil
---@param z number|nil 0 if nil
AuroraFramework.libraries.matrix.offset = function(position, x, y, z)
	local new = matrix.translation(0, 0, 0)

	for i, v in pairs(position) do
		new[i] = v
	end

	local toOffset = {x or 0, y or 0, z or 0}

	for i = 1, 3 do
		new[12 + i] = new[12 + i] + toOffset[i]
	end

	return new
end

-- Offsets the position by a random x, y, z, between -max, and max
---@param position SWMatrix
---@param max number
---@param shouldOffsetY boolean|nil
AuroraFramework.libraries.matrix.randomOffset = function(position, max, shouldOffsetY)
	return AuroraFramework.libraries.matrix.offset(position, math.random(-max, max), AuroraFramework.libraries.miscellaneous.switchbox(0, math.random(-max, max), shouldOffsetY), math.random(-max, max))
end

---------------- Miscellaneous
AuroraFramework.libraries.miscellaneous = {}

-- Clamp a number between min and max
---@param num number
---@param min number
---@param max number
AuroraFramework.libraries.miscellaneous.clamp = function(num, min, max)
	if num < min then
		return min
	elseif num > max then
		return max
	end

	return num
end

-- Remove a value from a table
---@param tbl table
---@param value any
AuroraFramework.libraries.miscellaneous.removeValueFromTable = function(tbl, value)
	for i, v in pairs(tbl) do
		if v == value then
			tbl[i] = nil
		end
	end

	return tbl
end

-- Get the index of a value in a table
---@param tbl table
---@param value any
---@return any|nil
AuroraFramework.libraries.miscellaneous.getIndexOfValueInTable = function(tbl, value)
	for i, v in pairs(tbl) do
		if v == value then
			return i
		end
	end
end

-- Get a peer ID from a player, or -1 if player is nil
---@param player af_services_player_player|nil
AuroraFramework.libraries.miscellaneous.getPeerID = function(player)
	local id = -1

	if player then
		id = player.properties.peer_id
	end

	return id
end

-- Returns the value count of a table
---@param tbl table
---@return integer
AuroraFramework.libraries.miscellaneous.getTableLength = function(tbl)
	local count = 0

	for _ in pairs(tbl) do
		count = count + 1
	end

	return count
end

-- Rounds a number
---@param input number
---@param numDecimalPlaces integer
AuroraFramework.libraries.miscellaneous.round = function(input, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(input * mult + 0.5) / mult
end

-- Converts a string to a bool ("true"/"TruE" = true, anything else = false)
---@param input string
AuroraFramework.libraries.miscellaneous.stringToBool = function(input)
    return input:lower() == "true"
end

-- Returns a random value in a table
---@param tbl table
---@return any
AuroraFramework.libraries.miscellaneous.getRandomTableValue = function(tbl)
    return tbl[math.random(1, #tbl)]
end

-- Returns on or off depending on whether or not switch is true
---@param off any
---@param on any
---@param switch any
---@return any
AuroraFramework.libraries.miscellaneous.switchbox = function(off, on, switch)
	if switch then
		return on
	else
		return off
	end
end

-- Returns whether or not a value is in a table
---@param value any
---@param tbl table
---@return boolean
AuroraFramework.libraries.miscellaneous.isValueInTable = function(value, tbl)
	for _, v in pairs(tbl) do
		if v == value then
			return true
		end
	end

	return false
end

-- Converts all values in a table to strings
---@param tbl table
AuroraFramework.libraries.miscellaneous.tostringValuesInTable = function(tbl)
	for i, v in pairs(tbl) do
		tbl[i] = tostring(v)
	end

	return tbl
end

-- Converts all string values in a table to lowercase
---@param tbl table
AuroraFramework.libraries.miscellaneous.lowerStringValuesInTable = function(tbl)
	for i, v in pairs(tbl) do
		if type(v) == "string" then
			tbl[i] = v:lower()
		end
	end

	return tbl
end

-- Converts all string values in a table to uppercase
---@param tbl table
AuroraFramework.libraries.miscellaneous.upperStringValuesInTable = function(tbl)
	for i, v in pairs(tbl) do
		if type(v) == "string" then
			tbl[i] = v:upper()
		end
	end

	return tbl
end

---------------- Storage
AuroraFramework.libraries.storage = {
	---@type table<string, af_libs_storage_storage>
	createdStorages = {}
}

-- Create a storage container
---@param name string
AuroraFramework.libraries.storage.create = function(name)
	AuroraFramework.libraries.storage.createdStorages[name] = {
		name = name,
		data = {},

		---@param self af_libs_storage_storage
		save = function(self, index, value)
			self.data[index] = value
			return self
		end,

		---@param self af_libs_storage_storage
		get = function(self, index)
			return self.data[index]
		end,

		---@param self af_libs_storage_storage
		destroy = function(self, index)
			self.data[index] = nil
			return self
		end,

		---@param self af_libs_storage_storage
		remove = function(self)
			return AuroraFramework.libraries.storage.remove(self.name)
		end
	}

	return AuroraFramework.libraries.storage.createdStorages[name]
end

-- Get a storage container
---@param name string
AuroraFramework.libraries.storage.get = function(name)
	return AuroraFramework.libraries.storage.createdStorages[name]
end

-- Remove a storage container
---@param name string
AuroraFramework.libraries.storage.remove = function(name)
	AuroraFramework.libraries.storage.createdStorages[name] = nil
end

---------------- Events
AuroraFramework.libraries.events = {
	---@type table<string, af_libs_event_event>
	createdEvents = {}
}

-- Create an event
---@param name string
AuroraFramework.libraries.events.create = function(name)
	AuroraFramework.libraries.events.createdEvents[name] = {
		name = name,
		connections = {},

		---@param self af_libs_event_event
		fire = function(self, ...)
			for i, v in pairs(self.connections) do
				v(...)
			end

			return self
		end,

		---@param self af_libs_event_event
		clear = function(self)
			self.connections = {}
			return self
		end,

		---@param self af_libs_event_event
		remove = function(self)
			return AuroraFramework.libraries.events.remove(self.name)
		end,

		---@param self af_libs_event_event
		connect = function(self, toConnect)
			table.insert(self.connections, toConnect)
		end
	}

	local event = AuroraFramework.libraries.events.createdEvents[name]
	return event
end

-- Get an event
---@param name string
AuroraFramework.libraries.events.get = function(name)
	return AuroraFramework.libraries.events.createdEvents[name]
end

-- Remove an event
---@param name string
AuroraFramework.libraries.events.remove = function(name)
	AuroraFramework.libraries.events.createdEvents[name] = nil
end

---------------- Loops and Delays
local af_timerID = 0

AuroraFramework.libraries.timer = {
	loop = {
		---@type table<integer, af_libs_timer_loop>
		ongoing = {}
	},

	delay = {
		---@type table<integer, af_libs_timer_delay>
		ongoing = {}
	}
}

-- Create a loop. Duration is in seconds
---@param duration integer In seconds
---@param callback function
AuroraFramework.libraries.timer.loop.create = function(duration, callback)
	-- unique id
	af_timerID = af_timerID + 1

	-- store loop
	AuroraFramework.libraries.timer.loop.ongoing[af_timerID] = {
		duration = duration,
		creationTime = server.getTimeMillisec(),
		event = AuroraFramework.libraries.events.create(af_timerID.."_af_loop"),
		id = af_timerID,

		---@param self af_libs_timer_loop
		remove = function(self)
			AuroraFramework.libraries.timer.loop.remove(self.id)
		end,

		---@param self af_libs_timer_loop
		setDuration = function(self, new)
			self.duration = new
		end
	}

	-- attach callback
	local data = AuroraFramework.libraries.timer.loop.ongoing[af_timerID]
	data.event:connect(callback)

	-- return
	return data
end

-- Remove a loop
---@param id integer
AuroraFramework.libraries.timer.loop.remove = function(id)
	AuroraFramework.libraries.timer.loop.ongoing[id] = nil
end

-- Create a delay. Duration is in seconds
---@param duration integer In seconds
---@param callback function
AuroraFramework.libraries.timer.delay.create = function(duration, callback)
	-- unique id
	af_timerID = af_timerID + 1

	-- store delay
	AuroraFramework.libraries.timer.delay.ongoing[af_timerID] = {
		duration = duration,
		creationTime = server.getTimeMillisec(),
		event = AuroraFramework.libraries.events.create(af_timerID.."_af_loop"),
		id = af_timerID,

		---@param self af_libs_timer_delay
		remove = function(self)
			AuroraFramework.libraries.timer.delay.remove(self.id)
		end,

		---@param self af_libs_timer_delay
		setDuration = function(self, new)
			self.duration = new
		end
	}

	-- attach callback
	local data = AuroraFramework.libraries.timer.delay.ongoing[af_timerID]
	data.event:connect(callback)

	-- return
	return data
end

-- Remove a delay
---@param id integer
AuroraFramework.libraries.timer.delay.remove = function(id)
	AuroraFramework.libraries.timer.delay.ongoing[id] = nil
end

-- Handler
AuroraFramework.libraries.timer.handler = function()
	AuroraFramework.game.callbacks.onTick.internal:connect(function()
		local current = server.getTimeMillisec()

		-- Handle loops
		for i, v in pairs(AuroraFramework.libraries.timer.loop.ongoing) do
			if current > v.creationTime + (v.duration * 1000) then
				v.event:fire(v)
				v.creationTime = current
			end
		end

		-- Handle delays
		for i, v in pairs(AuroraFramework.libraries.timer.delay.ongoing) do
			if current > v.creationTime + (v.duration * 1000) then
				v.event:fire(v)
				v:remove()
			end
		end
	end)
end

--------------------------------------------------------------------------------
--// TPS \\--
--------------------------------------------------------------------------------
AuroraFramework.services.TPSService = {
	initialize = function() -- from: https://github.com/Dangleworks/Antilag/blob/master/script.lua
		local ticks = 0
		local ticksTime = 0

		-- update tps n stuff
		AuroraFramework.game.callbacks.onTick.internal:connect(function()
			ticks = ticks + 1

			if server.getTimeMillisec() - ticksTime >= 500 then
				-- update tps
				AuroraFramework.services.TPSService.tpsData.tps = ticks * 2

				-- calculate avg tps
				if #AuroraFramework.services.TPSService.internal.avgTicksTbl > 10 then
					-- calculate average tps
					local sum = 0

					for i, v in pairs(AuroraFramework.services.TPSService.internal.avgTicksTbl) do
						sum = sum + v
					end

					AuroraFramework.services.TPSService.tpsData.avg = sum / #AuroraFramework.services.TPSService.internal.avgTicksTbl
					AuroraFramework.services.TPSService.internal.avgTicksTbl = {}
				else
					-- add tps to avg tps table
					table.insert(AuroraFramework.services.TPSService.internal.avgTicksTbl, AuroraFramework.services.TPSService.tpsData.tps)
				end

				-- ready for next tps update stuff
				ticks = 0
				ticksTime = server.getTimeMillisec()
			end
		end)
	end,

	tpsData = {
		tps = 64,
		avg = 64
	},

	internal = {
		avgTicksTbl = {}
	}
}

AuroraFramework.services.TPSService.getTPSData = function()
	return AuroraFramework.services.TPSService.tpsData
end

--------------------------------------------------------------------------------
--// Vehicles \\--
--------------------------------------------------------------------------------
AuroraFramework.services.vehicleService = {
	initialize = function()
		-- Give vehicle data whenever a vehicle is spawned
		AuroraFramework.game.callbacks.onVehicleSpawn.internal:connect(function(...)
			-- give vehicle data
			local vehicle = AuroraFramework.services.vehicleService.internal.giveVehicleData(...)

			-- fire events
			AuroraFramework.services.vehicleService.events.onSpawn:fire(vehicle)
		end)

		-- Update vehicle data on load
		AuroraFramework.game.callbacks.onVehicleLoad.internal:connect(function(vehicle_id)
			-- set vehicle loaded
			local vehicle = AuroraFramework.services.vehicleService.getVehicleByVehicleID(vehicle_id)

			if not vehicle then
				return
			end

			vehicle.properties.loaded = true

			-- fire events
			AuroraFramework.services.vehicleService.events.onLoad:fire(vehicle)
		end)

		-- Remove vehicle data whenever a vehicle is despawned
		AuroraFramework.game.callbacks.onVehicleDespawn.internal:connect(function(vehicle_id)
			-- fire events
			local vehicle = AuroraFramework.services.vehicleService.getVehicleByVehicleID(vehicle_id)

			if not vehicle then
				return
			end

			-- fire events
			AuroraFramework.services.vehicleService.events.onDespawn:fire(vehicle)

			-- remove data
			AuroraFramework.services.vehicleService.internal.removeVehicleData(vehicle_id)
		end)
	end,

	---@type table<integer, af_services_vehicle_vehicle>
	vehicles = {},

	events = {
		onSpawn = AuroraFramework.libraries.events.create("auroraFramework_onVehicleSpawn"),
		onLoad = AuroraFramework.libraries.events.create("auroraFramework_onVehicleLoad"),
		onDespawn = AuroraFramework.libraries.events.create("auroraFramework_onVehicleDespawn")
	},

	internal = {}
}

-- Give vehicle data to a vehicle
AuroraFramework.services.vehicleService.internal.giveVehicleData = function(vehicle_id, peer_id, x, y, z, cost)
	local player = AuroraFramework.services.playerService.getPlayerByPeerID(peer_id) -- doesnt matter if nil, because of the addonSpawned property

	AuroraFramework.services.vehicleService.vehicles[vehicle_id] = {
		properties = {
			owner = player,
			addonSpawned = peer_id == -1,
			name = (server.getVehicleName(vehicle_id)),
			vehicle_id = vehicle_id,
			spawnPos = matrix.translation(x, y, z),
			cost = cost,
			storage = AuroraFramework.libraries.storage.create("vehicle_"..vehicle_id.."_storage")
		},

		---@param self af_services_vehicle_vehicle
		despawn = function(self)
			server.despawnVehicle(self.properties.vehicle_id, true)
		end,

		---@param self af_services_vehicle_vehicle
		explode = function(self, magnitude)
			server.spawnExplosion(self:getPosition(), magnitude or 0.1)
			self:despawn()
		end,

		---@param self af_services_vehicle_vehicle
		teleport = function(self, pos)
			server.setVehiclePos(self.properties.vehicle_id, pos)
		end,

		---@param self af_services_vehicle_vehicle
		repair = function(self)
			server.resetVehicleState(self.properties.vehicle_id)
		end,

		---@param self af_services_vehicle_vehicle
		getPosition = function(self, voxelX, voxelY, voxelZ)
			return (server.getVehiclePos(self.properties.vehicle_id, voxelX, voxelY, voxelZ)) -- in brackets to only get pos, not success
		end,

		---@param self af_services_vehicle_vehicle
		getLoadedVehicleData = function(self)
			if not self.properties.loaded then
				return
			end

			return server.getVehicleData(self.properties.vehicle_id)
		end,

		---@param self af_services_vehicle_vehicle
		setInvulnerability = function(self, state)
			server.setVehicleInvulnerable(self.properties.vehicle_id, state)
		end,

		---@param self af_services_vehicle_vehicle
		setEditable = function(self, state)
			server.setVehicleEditable(self.properties.vehicle_id, state)
		end,

		---@param self af_services_vehicle_vehicle
		setTooltip = function(self, text)
			server.setVehicleTooltip(self.properties.vehicle_id, text)
		end
	}

	return AuroraFramework.services.vehicleService.vehicles[vehicle_id]
end

-- Remove vehicle data from a vehicle
---@param vehicle_id integer
AuroraFramework.services.vehicleService.internal.removeVehicleData = function(vehicle_id)
	AuroraFramework.services.vehicleService.vehicles[vehicle_id] = nil
end

-- Returns all recognised vehicles
---@return table<integer, af_services_vehicle_vehicle>
AuroraFramework.services.vehicleService.getAllVehicles = function()
	return AuroraFramework.services.vehicleService.vehicles
end

-- Get a vehicle by its ID
---@param vehicle_id integer
AuroraFramework.services.vehicleService.getVehicleByVehicleID = function(vehicle_id)
	return AuroraFramework.services.vehicleService.vehicles[vehicle_id]
end

-- Get a vehicle by its name
---@param input string
AuroraFramework.services.vehicleService.getVehicleByName = function(input)
	for i, v in pairs(AuroraFramework.services.vehicleService.getAllVehicles()) do
		if v.properties.name == input then
			return v
		end
	end
end

-- Search for a vehicle by name
---@param input string
AuroraFramework.services.vehicleService.getVehicleByNameSearch = function(input)
	for i, v in pairs(AuroraFramework.services.vehicleService.getAllVehicles()) do
		if v.properties.name:lower():find(input:lower()) then
			return v
		end
	end
end

-- Get the amount of spawned and recognised vehicles
AuroraFramework.services.vehicleService.getGlobalVehicleCount = function()
	return AuroraFramework.libraries.miscellaneous.getTableLength(AuroraFramework.services.vehicleService.vehicles)
end

-- Get a list of vehicles spawned by a player
---@param player af_services_player_player
---@return table<integer, af_services_vehicle_vehicle>
AuroraFramework.services.vehicleService.getAllVehiclesSpawnedByAPlayer = function(player)
	local list = {}

	for _, vehicle in pairs(AuroraFramework.services.vehicleService.vehicles) do
		if AuroraFramework.services.playerService.isSamePlayer(player, vehicle.properties.owner) then
			table.insert(list, vehicle)
		end
	end

	return list
end

-- Get the amount of vehicles spawned by a player
---@param player af_services_player_player
AuroraFramework.services.vehicleService.getVehicleCountOfPlayer = function(player)
	return #AuroraFramework.services.vehicleService.getAllVehiclesSpawnedByAPlayer(player)
end

-- Returns whether or not two vehicles are the same
---@param vehicle1 af_services_vehicle_vehicle
---@param vehicle2 af_services_vehicle_vehicle
AuroraFramework.services.vehicleService.isSameVehicle = function(vehicle1, vehicle2)
	return vehicle1.properties.vehicle_id == vehicle2.properties.vehicle_id
end

--------------------------------------------------------------------------------
--// Notification \\--
--------------------------------------------------------------------------------
AuroraFramework.services.notificationService = {}

-- Send a success notification
---@param title string "[Success] - title"
---@param message string "message"
---@param player af_services_player_player|nil If nil, everyone will see the notification
AuroraFramework.services.notificationService.success = function(title, message, player)
	server.notify(AuroraFramework.libraries.miscellaneous.getPeerID(player), "[Success] "..title, message, 4)
end

-- Send a warning notification
---@param title string "[Warning] - title"
---@param message string "message"
---@param player af_services_player_player|nil If nil, everyone will see the notification
AuroraFramework.services.notificationService.warning = function(title, message, player)
	server.notify(AuroraFramework.libraries.miscellaneous.getPeerID(player), "[Warning] "..title, message, 1)
end

-- Send a failure notification
---@param title string "[Failure] - title"
---@param message string "message"
---@param player af_services_player_player|nil If nil, everyone will see the notification
AuroraFramework.services.notificationService.failure = function(title, message, player)
	server.notify(AuroraFramework.libraries.miscellaneous.getPeerID(player), "[Failure] "..title, message, 3)
end

-- Send a custom notification
---@param title string "title"
---@param message string "message"
---@param player af_services_player_player|nil If nil, everyone will see the notification
---@param notificationType SWNotifiationTypeEnum
AuroraFramework.services.notificationService.custom = function(title, message, player, notificationType)
	server.notify(AuroraFramework.libraries.miscellaneous.getPeerID(player), title, message, notificationType)
end

--------------------------------------------------------------------------------
--// Players \\--
--------------------------------------------------------------------------------
AuroraFramework.services.playerService = {
	initialize = function()
		-- Give player data whenever a player joins
		AuroraFramework.game.callbacks.onPlayerJoin.internal:connect(function(...)
			-- give data and fire join event
			local player = AuroraFramework.services.playerService.internal.givePlayerData(...)
			AuroraFramework.services.playerService.events.onJoin:fire(player)
		end)

		-- Remove player data whenever a player leaves
		AuroraFramework.game.callbacks.onPlayerLeave.internal:connect(function(_, _, peer_id)
			-- fire leave event
			local player = AuroraFramework.services.playerService.getPlayerByPeerID(peer_id)

			if not player then
				return
			end

			AuroraFramework.services.playerService.events.onLeave:fire(player)

			-- remove player data
			AuroraFramework.services.playerService.internal.removePlayerData(peer_id)
		end)

		-- Die event
		AuroraFramework.game.callbacks.onPlayerDie.internal:connect(function(_, _, peer_id)
			local player = AuroraFramework.services.playerService.getPlayerByPeerID(peer_id)

			if not player then
				return
			end

			AuroraFramework.services.playerService.events.onDie:fire(player)
		end)

		-- Respawn event
		AuroraFramework.game.callbacks.onPlayerRespawn.internal:connect(function(peer_id)
			local player = AuroraFramework.services.playerService.getPlayerByPeerID(peer_id)

			if not player then
				return
			end

			AuroraFramework.services.playerService.events.onRespawn:fire(player)
		end)

		-- Character load event
		AuroraFramework.game.callbacks.onObjectLoad.internal:connect(function(object_id)
			local player = AuroraFramework.services.playerService.getPlayerByObjectID(object_id)

			if not player then
				return
			end

			player.properties.characterLoaded = true
			AuroraFramework.services.playerService.events.onCharacterLoad:fire(player)
		end)

		-- Update player properties
		AuroraFramework.libraries.timer.delay.create(0.01, function() -- wait a tick for addon to attach callbacks to player events
			-- Activate player join events
			for _, v in pairs(server.getPlayers()) do
				AuroraFramework.game.callbacks.onPlayerJoin.main:fire(v.steam_id, v.name, v.id, v.admin, v.auth)
				AuroraFramework.game.callbacks.onPlayerJoin.internal:fire(v.steam_id, v.name, v.id, v.admin, v.auth)
			end

			for _, v in pairs(AuroraFramework.services.playerService.getAllPlayers()) do
				v.properties.characterLoaded = true -- set character loaded to true on script reload n shit
				AuroraFramework.services.playerService.events.onCharacterLoad:fire(v)
			end

			-- Update player data
			AuroraFramework.libraries.timer.loop.create(0.01, function()
				for _, player in pairs(server.getPlayers()) do
					AuroraFramework.services.playerService.internal.givePlayerData(
						player.steam_id,
						player.name,
						player.id,
						player.admin,
						player.auth
					)
				end
			end)
		end)
	end,

	---@type table<integer, af_services_player_player>
	players = {},

	events = {
		onJoin = AuroraFramework.libraries.events.create("auroraFramework_onPlayerJoin"),
		onLeave = AuroraFramework.libraries.events.create("auroraFramework_onPlayerLeave"),
		onCharacterLoad = AuroraFramework.libraries.events.create("auroraFramework_onPlayerCharacterLoad"),
		onDie = AuroraFramework.libraries.events.create("auroraFramework_onPlayerDie"),
		onRespawn = AuroraFramework.libraries.events.create("auroraFramework_onPlayerRespawn")
	},

	internal = {}
}

-- Give player data to a player
AuroraFramework.services.playerService.internal.givePlayerData = function(steam_id, name, peer_id, admin, auth, characterLoaded)
	AuroraFramework.services.playerService.players[peer_id] = {
		properties = {
			steam_id = tostring(steam_id),
			name = name,
			peer_id = peer_id,
			admin = admin,
			auth = auth,
			isHost = peer_id == 0,
			storage = AuroraFramework.libraries.storage.create("player_"..peer_id.."_storage"),
			characterLoaded = characterLoaded or false
		},

		setItem = function(self, slot, to, active, int, float)
			server.setCharacterItem(self:getCharacter(), slot, to, active, int, float)
		end,

		removeItem = function(self, slot)
			server.setCharacterItem(self:getCharacter(), slot, 0, false)
		end,

		---@param self af_services_player_player
		kick = function(self)
			server.kickPlayer(self.properties.peer_id)
		end,

		---@param self af_services_player_player
		ban = function(self)
			server.banPlayer(self.properties.peer_id)
		end,

		---@param self af_services_player_player
		teleport = function(self, pos)
			server.setPlayerPos(self.properties.peer_id, pos)
		end,

		---@param self af_services_player_player
		getPosition = function(self)
			return (server.getPlayerPos(self.properties.peer_id)) -- in brackets to only get pos, not success
		end,

		---@param self af_services_player_player
		getCharacter = function(self)
			return (server.getPlayerCharacterID(self.properties.peer_id))
		end,

		---@param self af_services_player_player
		damage = function(self, amount)
			local character = self:getCharacter()
			local data = server.getCharacterData(character)

			if not data then
				return
			end

			return server.setCharacterData(character, data.hp - amount, data.interactible, data.ai)
		end,

		---@param self af_services_player_player
		kill = function(self)
			local character = self:getCharacter()

			if not character then
				return
			end

			server.killCharacter(character)
		end,

		---@param self af_services_player_player
		setAdmin = function(self, give)
			if give then
				server.addAdmin(self.properties.peer_id)
			else
				server.removeAdmin(self.properties.peer_id)
			end
		end,

		---@param self af_services_player_player
		setAuth = function(self, give)
			if give then
				server.addAuth(self.properties.peer_id)
			else
				server.removeAuth(self.properties.peer_id)
			end
		end
	}

	return AuroraFramework.services.playerService.players[peer_id]
end

-- Remove player data from a player
AuroraFramework.services.playerService.internal.removePlayerData = function(peer_id)
	AuroraFramework.services.playerService.players[peer_id] = nil
end

-- Returns all recognised players
AuroraFramework.services.playerService.getAllPlayers = function()
	return AuroraFramework.services.playerService.players
end

-- Returns whether or not two players are the same
---@param player1 af_services_player_player
---@param player2 af_services_player_player
AuroraFramework.services.playerService.isSamePlayer = function(player1, player2)
	return player1.properties.peer_id == player2.properties.peer_id
end

-- Get a player by their peer ID
---@param peer_id integer
AuroraFramework.services.playerService.getPlayerByPeerID = function(peer_id)
	return AuroraFramework.services.playerService.players[peer_id]
end

-- Get a player by their Steam ID
---@param steam_id string|integer
AuroraFramework.services.playerService.getPlayerBySteamID = function(steam_id)
	steam_id = tostring(steam_id)

	for _, player in pairs(AuroraFramework.services.playerService.players) do
		if player.properties.steam_id == steam_id then
			return player
		end
	end
end

-- Get a player by their character's object ID
---@param object_id integer
AuroraFramework.services.playerService.getPlayerByObjectID = function(object_id)
	for _, player in pairs(AuroraFramework.services.playerService.players) do
		if player:getCharacter() == object_id then
			return player
		end
	end
end

-- Get a player by name, partial or not
---@param name string
AuroraFramework.services.playerService.getPlayerByNameSearch = function(name)
	for _, player in pairs(AuroraFramework.services.playerService.players) do
		if player.properties.name:lower():find(name:lower()) then
			return player
		end
	end
end

-- Get a player by their exact name
---@param name string
AuroraFramework.services.playerService.getPlayerByName = function(name)
	for _, player in pairs(AuroraFramework.services.playerService.players) do
		if player.properties.name == name then
			return player
		end
	end
end

--------------------------------------------------------------------------------
--// HTTP \\--
--------------------------------------------------------------------------------
AuroraFramework.services.HTTPService = {
	initialize = function()
		AuroraFramework.game.callbacks.httpReply.internal:connect(function(port, url, reply)
			local data = AuroraFramework.services.HTTPService.ongoingRequests[port.."|"..url]

			if data then
				data.properties.event:fire(tostring(reply)) -- reply callback
				data:cancel() -- remove the request
			end
		end)
	end,

	---@type table<string, af_services_http_request>
	ongoingRequests = {},

	internal = {}
}

-- Send a HTTP request
---@param port integer
---@param url string
---@param callback function|nil
AuroraFramework.services.HTTPService.request = function(port, url, callback)
	AuroraFramework.services.HTTPService.ongoingRequests[port.."|"..url] = {
		properties = {
			port = port,
			url = url,
			event = AuroraFramework.libraries.events.create("auroraFramework_HTTPRequest_"..port.."|"..url)
		},

		---@param self af_services_http_request
		cancel = function(self)
			AuroraFramework.services.HTTPService.cancel(self.properties.port, self.properties.url)
		end
	}

	local data = AuroraFramework.services.HTTPService.ongoingRequests[port.."|"..url]

	if callback then
		data.properties.event:connect(callback) -- attach callback to reply event
	end

	server.httpGet(port, url)

	return data
end

-- Convert a table of args into URL parameters
---@param url string
AuroraFramework.services.HTTPService.URLArgs = function(url, ...)
	-- convert args to stuffs tghfgdfd
	local args = {}
	local packed = {...}

	for i, v in pairs(packed) do
		if not v.name or not v.value then
			goto continue
		end

		if i == 1 then
			table.insert(args, "?"..AuroraFramework.services.HTTPService.URLEncode(v.name).."="..AuroraFramework.services.HTTPService.URLEncode(v.value))
		else
			table.insert(args, "&"..AuroraFramework.services.HTTPService.URLEncode(v.name).."="..AuroraFramework.services.HTTPService.URLEncode(v.value))
		end

		::continue::
	end

	-- anddd return
	return url..table.concat(args)
end

-- URL encode a string
---@param input string
AuroraFramework.services.HTTPService.URLEncode = function(input)
	if type(input) ~= "string" or tonumber(input) then -- dont url encode numbers/non-strings
		return input
	end

	input = string.gsub(input, "\n", "\r\n")
    input = string.gsub(input, "([^%w %-%_%.%~])",
        function(c)
			return string.format("%%%02X", string.byte(c))
		end)
	input = string.gsub(input, " ", "+")

	return input
end

-- URL decode a string
---@param input string
AuroraFramework.services.HTTPService.URLDecode = function(input)
	input = string.gsub(input, "+", " ")
	input = string.gsub(input, "%%(%x%x)",
		function (hex)
			return string.char(tonumber(hex, 16))
		end
	)

	input = string.gsub(input, "\r\n", "\n")

	return input
end

-- Returns whether or not a response is ok
---@param response string
AuroraFramework.services.HTTPService.ok = function(response)
	local notOk = {
        ["Connection closed unexpectedly"] = true,
        ["connect(): Connection refused"] = true,
        ["recv(): Connection reset by peer"] = true,
        ["timeout"] = true,
		["nil"] = true,
		[""] = true
    }

    return notOk[response] == nil
end

-- Cancel a request
---@param port integer
---@param url string
AuroraFramework.services.HTTPService.cancel = function(port, url)
	AuroraFramework.services.HTTPService.ongoingRequests[port.."|"..url] = nil
end

--------------------------------------------------------------------------------
--// Messages \\--
--------------------------------------------------------------------------------
AuroraFramework.services.chatService = {
	initialize = function()
		AuroraFramework.game.callbacks.onChatMessage.internal:connect(function(peer_id, _, content)
			AuroraFramework.libraries.timer.delay.create(0.01, function() -- just so if the addon deletes the message, shit wont be fucked up (onchatmessage is fired before message is shown in chat)
				-- get player
				local player = AuroraFramework.services.playerService.getPlayerByPeerID(peer_id)

				if not player then
					return
				end

				-- construct message
				local message = AuroraFramework.services.chatService.internal.construct(player, content)

				-- enforce message limit
				if #AuroraFramework.services.chatService.messages >= 129 then
					table.remove(AuroraFramework.services.chatService.messages, 1)
				end

				-- save the message
				table.insert(AuroraFramework.services.chatService.messages, message)

				-- fire event
				AuroraFramework.services.chatService.events.onMessageSent:fire(message)
			end)
		end)
	end,

	events = {
		onMessageSent = AuroraFramework.libraries.events.create("auroraFramework_onMessageSent"), -- message
		onMessageDeleted = AuroraFramework.libraries.events.create("auroraFramework_onMessageDeleted"), -- message, player|nil
		onMessageEdited = AuroraFramework.libraries.events.create("auroraFramework_onMessageEdited") -- message, player|nil
	},

	---@type table<integer, af_services_chat_message>
	messages = {}, -- max of 129, since thats all the chat window can contain

	internal = {}
}

local af_messageID = 0

-- Construct a message
---@param _player af_services_player_player
---@return af_services_chat_message
AuroraFramework.services.chatService.internal.construct = function(_player, messageContent)
	af_messageID = af_messageID + 1

	return {
		properties = {
			author = _player,
			content = messageContent,
			id = af_messageID
		},

		---@param self af_services_chat_message
		---@param player af_services_player_player
		delete = function(self, player)
			return AuroraFramework.services.chatService.deleteMessage(self, player)
		end,

		---@param self af_services_chat_message
		---@param player af_services_player_player
		edit = function(self, newContent, player)
			return AuroraFramework.services.chatService.editMessage(self, newContent, player)
		end
	}
end

-- Get all messages sent by a player
---@param player af_services_player_player
---@return table<integer, af_services_chat_message>
AuroraFramework.services.chatService.getAllMessagesSentByAPlayer = function(player)
	local list = {}

	for _, message in pairs(AuroraFramework.services.chatService.messages) do
		if AuroraFramework.services.playerService.isSamePlayer(message.properties.author, player) then
			table.insert(list, message)
		end
	end

	return list
end

-- Get the newest message
AuroraFramework.services.chatService.getNewestMessage = function()
	return AuroraFramework.services.chatService.messages[#AuroraFramework.services.chatService.messages]
end

-- Get the oldest message
AuroraFramework.services.chatService.getOldestMessage = function()
	return AuroraFramework.services.chatService.messages[1]
end

-- Edit a message
---@param message af_services_chat_message
---@param player af_services_player_player|nil If player, the message will be edited for the player, else, everyone
AuroraFramework.services.chatService.editMessage = function(message, newContent, player)
	-- edit message
	message.properties.content = newContent

	-- clear chat
	AuroraFramework.services.chatService.clear(player)

	-- resend messages
	for i, msg in pairs(AuroraFramework.services.chatService.messages) do
		-- save edited message
		if AuroraFramework.services.chatService.isSameMessage(msg, message) then
			AuroraFramework.services.chatService.messages[i] = message
		end

		-- resend
		AuroraFramework.services.chatService.sendMessage(msg.properties.author.properties.name, msg.properties.content, player)
	end

	-- fire event
	AuroraFramework.services.chatService.events.onMessageEdited:fire(message, player)
end

-- Delete a message
---@param message af_services_chat_message
---@param player af_services_player_player|nil If player, the message will be deleted for the player, else, everyone
AuroraFramework.services.chatService.deleteMessage = function(message, player)
	-- clear chat
	AuroraFramework.services.chatService.clear(player)

	-- resend messages
	for i, msg in pairs(AuroraFramework.services.chatService.messages) do
		-- delete message
		if AuroraFramework.services.chatService.isSameMessage(msg, message) then
			AuroraFramework.services.chatService.messages[i] = nil
			goto continue -- prevent sending the deleted message
		end

		-- resend
		AuroraFramework.services.chatService.sendMessage(msg.properties.author.properties.name, msg.properties.content, player)

		-- next message
	    ::continue::
	end

	-- fire event
	AuroraFramework.services.chatService.events.onMessageDeleted:fire(message, player)
end

-- Whether or not both messages are the same
---@param message1 af_services_chat_message
---@param message2 af_services_chat_message
---@return boolean
AuroraFramework.services.chatService.isSameMessage = function(message1, message2)
	return message1.properties.id == message2.properties.id
end

-- Send a message to everyone/a player
---@param author any
---@param message any
---@param player af_services_player_player|nil
AuroraFramework.services.chatService.sendMessage = function(author, message, player)
	local peer_id = -1

	if player then
		peer_id = player.properties.peer_id
	end

	server.announce(tostring(author), tostring(message), peer_id)
end

-- Clear chat for everyone/a player
---@param player af_services_player_player|nil
AuroraFramework.services.chatService.clear = function(player)
	for _ = 1, 11 do
		AuroraFramework.services.chatService.sendMessage(" ", " ", player)
	end
end

--------------------------------------------------------------------------------
--// Commands \\--
--------------------------------------------------------------------------------
AuroraFramework.services.commandService = {
	initialize = function()
		-- handle commands
		AuroraFramework.game.callbacks.onCustomCommand.internal:connect(function(message, peer_id, admin, auth, command, ...)
			-- get variables n stuff
			local player = AuroraFramework.services.playerService.getPlayerByPeerID(peer_id)

			if not player then
				return
			end

			local args = {...}

			command = command:sub(2, -1)
			local loweredCommand = command:lower()

			-- go through all commands
			for _, cmd in pairs(AuroraFramework.services.commandService.commands) do
				if cmd.properties.requiresAdmin and not admin then
					goto continue
				end

				if cmd.properties.requiresAuth and not auth then
					goto continue
				end

				if cmd.properties.capsSensitive then
					if cmd.properties.name == command or AuroraFramework.libraries.miscellaneous.isValueInTable(command, cmd.properties.shorthands) then
						cmd.events.onActivation:fire(cmd, args, player)
						return -- no need to go through the rest of the commands
					end
				else
					if cmd.properties.name:lower() == loweredCommand or AuroraFramework.libraries.miscellaneous.isValueInTable(loweredCommand, AuroraFramework.libraries.miscellaneous.lowerStringValuesInTable(cmd.properties.shorthands)) then
						cmd.events.onActivation:fire(cmd, args, player)
						return -- no need to go through the rest of the commands 2
					end
				end

			    ::continue::
			end
		end)
	end,

	---@type table<string, af_services_commands_command>
	commands = {},

	internal = {}
}

-- Create a command
---@param callback function first param = command, second param = args in table, third = player
---@param name string
---@param shorthands table<integer, string>|nil
---@param capsSensitive boolean|nil
---@param description string|nil
---@param requiresAuth boolean|nil
---@param requiresAdmin boolean|nil
AuroraFramework.services.commandService.create = function(callback, name, shorthands, capsSensitive, description, requiresAuth, requiresAdmin)
	-- create the command
	AuroraFramework.services.commandService.commands[name] = {
		properties = {
			name = name,
			requiresAdmim = requiresAdmin or false,
			requiresAuth = requiresAuth or false,
			description = description or "",
			shorthands = shorthands or {},
			capsSensitive = capsSensitive or false
		},

		events = {
			onActivation = AuroraFramework.libraries.events.create("commandService_command_"..name),
		},

		---@param self af_services_commands_command
		remove = function(self)
			return AuroraFramework.services.commandService.remove(self.properties.name)
		end
	}

	-- attach callback
	local data = AuroraFramework.services.commandService.commands[name]
	data.events.onActivation:connect(callback)

	-- return
	return data
end

-- Remove a command
---@param name string
AuroraFramework.services.commandService.remove = function(name)
	AuroraFramework.services.commandService.commands[name] = nil
end

--------------------------------------------------------------------------------
--// UI \\--
--------------------------------------------------------------------------------
AuroraFramework.services.UIService = {
	initialize = function()
		-- show ui on join
		AuroraFramework.services.playerService.events.onJoin:connect(function(player) ---@param player af_services_player_player
			-- show all ui
			for _, uiContainers in pairs(AuroraFramework.services.UIService.UI) do
				for _, ui in pairs(uiContainers) do
					if not ui.properties.player then -- since the player who joined has a new peer id, they will never be the target of an ui object, so no point in checking
						-- show to all
						ui:refresh()
					end
				end
			end
		end)
	end,

	UI = {
		---@type table<integer, af_services_ui_screen>
		screen = {},

		---@type table<integer, af_services_ui_map_label>
		mapLabels = {},

		---@type table<integer, af_services_ui_map_object>
		mapObjects = {},

		---@type table<integer, af_services_ui_map_line>
		mapLines = {}
	},

	internal = {}
}

-- Create a Screen UI object
---@param id number
---@param text string
---@param x number
---@param y number
---@param player af_services_player_player|nil
AuroraFramework.services.UIService.createScreenUI = function(id, text, x, y, player)
	AuroraFramework.services.UIService.UI.screen[id] = {
		properties = {
			x = x,
			y = y,
			text = text,
			visible = true,
			player = player,
			id = id
		},

		---@param self af_services_ui_screen
		refresh = function(self)
			local peerID = AuroraFramework.libraries.miscellaneous.getPeerID(self.properties.player)
			server.setPopupScreen(peerID, self.properties.id, "", self.properties.visible, self.properties.text, self.properties.x, self.properties.y)
		end,

		---@param self af_services_ui_screen
		remove = function(self)
			return AuroraFramework.services.UIService.removeScreenUI(self.properties.id)
		end,
	}

	local data = AuroraFramework.services.UIService.UI.screen[id]
	data:refresh() -- show

	return data
end

-- Get a Screen UI object
---@param id number
AuroraFramework.services.UIService.getScreenUI = function(id)
	return AuroraFramework.services.UIService.UI.screen[id]
end

-- Remove a Screen UI object
---@param id number
AuroraFramework.services.UIService.removeScreenUI = function(id)
	local data = AuroraFramework.services.UIService.UI.screen[id]
	data.properties.visible = false
	data:refresh() -- hide ui

	AuroraFramework.services.UIService.UI.screen[id] = nil
end

-- Create a Map Label
---@param id number
---@param text string
---@param pos SWMatrix
---@param labelType SWLabelTypeEnum
---@param player af_services_player_player|nil
AuroraFramework.services.UIService.createMapLabel = function(id, text, pos, labelType, player)
	AuroraFramework.services.UIService.UI.mapLabels[id] = {
		properties = {
			pos = pos,
			text = text,
			visible = true,
			player = player,
			id = id,
			labelType = labelType
		},

		---@param self af_services_ui_map_label
		refresh = function(self)
			local peerID = AuroraFramework.libraries.miscellaneous.getPeerID(self.properties.player)
			server.removeMapLabel(peerID, self.properties.id)

			if not self.properties.visible then -- if not visible, dont add the label back
				return
			end

			server.addMapLabel(peerID, self.properties.id, self.properties.labelType, self.properties.text, self.properties.pos[13], self.properties.pos[15])
		end,

		---@param self af_services_ui_map_label
		remove = function(self)
			return AuroraFramework.services.UIService.removeMapLabel(self.properties.id)
		end,
	}

	local data = AuroraFramework.services.UIService.UI.mapLabels[id]
	data:refresh() -- show

	return data
end

-- Get a Map Label
---@param id number
AuroraFramework.services.UIService.getMapLabel = function(id)
	return AuroraFramework.services.UIService.UI.mapLabels[id]
end

-- Remove a Map Label
---@param id number
AuroraFramework.services.UIService.removeMapLabel = function(id)
	local data = AuroraFramework.services.UIService.UI.mapLabels[id]
	data.properties.visible = false
	data:refresh() -- hide ui

	AuroraFramework.services.UIService.UI.mapLabels[id] = nil
end

-- Create a Map Line
---@param id number
---@param startPoint SWMatrix
---@param endPoint SWMatrix
---@param thickness number
---@param player af_services_player_player|nil
---@param r integer|nil 0-255
---@param g integer|nil 0-255
---@param b integer|nil 0-255
---@param a integer|nil 0-255
AuroraFramework.services.UIService.createMapLine = function(id, startPoint, endPoint, thickness, r, g, b, a, player)
	AuroraFramework.services.UIService.UI.mapLines[id] = {
		properties = {
			startPoint = startPoint,
			endPoint = endPoint,
			visible = true,
			player = player,
			id = id,

			r = r or 255,
			g = g or 255,
			b = b or 255,
			a = a or 255,

			thickness = thickness
		},

		---@param self af_services_ui_map_line
		refresh = function(self)
			local peerID = AuroraFramework.libraries.miscellaneous.getPeerID(self.properties.player)
			server.removeMapLine(peerID, self.properties.id)

			if not self.properties.visible then -- if not visible, dont add the line back
				return
			end

			server.addMapLine(peerID, self.properties.id, self.properties.startPoint, self.properties.endPoint, self.properties.thickness, self.properties.r, self.properties.g, self.properties.b, self.properties.a)
		end,

		---@param self af_services_ui_map_line
		remove = function(self)
			return AuroraFramework.services.UIService.removeMapLine(self.properties.id)
		end,
	}

	local data = AuroraFramework.services.UIService.UI.mapLines[id]
	data:refresh() -- show

	return data
end

-- Get a Map Line
---@param id number
AuroraFramework.services.UIService.getMapLine = function(id)
	return AuroraFramework.services.UIService.UI.mapLines[id]
end

-- Remove a Map Line
---@param id number
AuroraFramework.services.UIService.removeMapLine = function(id)
	local data = AuroraFramework.services.UIService.UI.mapLines[id]
	data.properties.visible = false
	data:refresh() -- hide ui

	AuroraFramework.services.UIService.UI.mapLines[id] = nil
end

-- Create a Map Object
---@param id number
---@param title string
---@param subtitle string
---@param pos SWMatrix
---@param objectType SWMarkerTypeEnum
---@param player af_services_player_player|nil
---@param radius number
---@param r integer|nil 0-255
---@param g integer|nil 0-255
---@param b integer|nil 0-255
---@param a integer|nil 0-255
AuroraFramework.services.UIService.createMapObject = function(id, title, subtitle, pos, objectType, player, radius, r, g, b, a)
	AuroraFramework.services.UIService.UI.mapObjects[id] = {
		properties = {
			pos = pos,
			title = title,
			subtitle = subtitle,
			visible = true,
			player = player,
			id = id,
			objectType = objectType,
			positionType = 0,
			attachID = 0,

			r = r or 255,
			g = g or 255,
			b = b or 255,
			a = a or 255,

			radius = radius
		},

		---@param self af_services_ui_map_object
		refresh = function(self)
			local peerID = AuroraFramework.libraries.miscellaneous.getPeerID(self.properties.player)
			server.removeMapObject(peerID, self.properties.id)

			if not self.properties.visible then -- if not visible, dont add the object back
				return
			end

			server.addMapObject( -- what the FUCK
				peerID,
				self.properties.id,
				self.properties.positionType,
				self.properties.objectType,
				self.properties.pos[13],
				self.properties.pos[15],
				self.properties.pos[13],
				self.properties.pos[15],
				self.properties.attachID,
				self.properties.attachID,
				self.properties.title,
				self.properties.radius,
				self.properties.subtitle,
				self.properties.r,
				self.properties.g,
				self.properties.b,
				self.properties.a
			)
		end,

		---@param self af_services_ui_map_object
		remove = function(self)
			return AuroraFramework.services.UIService.removeMapObject(self.properties.id)
		end,

		---@param self af_services_ui_map_object
		attach = function(self, positionType, attach)
			self.properties.positionType = positionType
			self.properties.attachID = attach
			self:refresh()
		end
	}

	local data = AuroraFramework.services.UIService.UI.mapObjects[id]
	data:refresh() -- show

	return data
end

-- Get a Map Object
---@param id number
AuroraFramework.services.UIService.getMapObject = function(id)
	return AuroraFramework.services.UIService.UI.mapObjects[id]
end

-- Remove a Map Object
---@param id number
AuroraFramework.services.UIService.removeMapObject = function(id)
	local data = AuroraFramework.services.UIService.UI.mapObjects[id]
	data.properties.visible = false
	data:refresh() -- hide ui

	AuroraFramework.services.UIService.UI.mapObjects[id] = nil
end

--------------------------------------------------------------------------------
--// Callbacks \\--
--------------------------------------------------------------------------------
---@type table<string, af_game_callbacks_callback>
AuroraFramework.game.callbacks = {}

AuroraFramework.game.callbacks.onTick = {
	internal = AuroraFramework.libraries.events.create("callback_onTick_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onTick_addon")
}

function onTick(...)
	AuroraFramework.game.callbacks.onTick.internal:fire(...)
	AuroraFramework.game.callbacks.onTick.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onCreate = {
	internal = AuroraFramework.libraries.events.create("callback_onCreate_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onCreate_addon")
}

function onCreate(...)
	AuroraFramework.game.callbacks.onCreate.internal:fire(...)
	AuroraFramework.game.callbacks.onCreate.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onDestroy = {
	internal = AuroraFramework.libraries.events.create("callback_onDestroy_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onDestroy_addon")
}

function onDestroy(...)
	AuroraFramework.game.callbacks.onDestroy.internal:fire(...)
	AuroraFramework.game.callbacks.onDestroy.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onCustomCommand = {
	internal = AuroraFramework.libraries.events.create("callback_onCustomCommand_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onCustomCommand_addon")
}

function onCustomCommand(...)
	AuroraFramework.game.callbacks.onCustomCommand.internal:fire(...)
	AuroraFramework.game.callbacks.onCustomCommand.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onChatMessage = {
	internal = AuroraFramework.libraries.events.create("callback_onChatMessage_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onChatMessage_addon")
}

function onChatMessage(...)
	AuroraFramework.game.callbacks.onChatMessage.internal:fire(...)
	AuroraFramework.game.callbacks.onChatMessage.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onPlayerJoin = {
	internal = AuroraFramework.libraries.events.create("callback_onPlayerJoin_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onPlayerJoin_addon")
}

function onPlayerJoin(...)
	AuroraFramework.game.callbacks.onPlayerJoin.internal:fire(...)
	AuroraFramework.game.callbacks.onPlayerJoin.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onPlayerSit = {
	internal = AuroraFramework.libraries.events.create("callback_onPlayerSit_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onPlayerSit_addon")
}

function onPlayerSit(...)
	AuroraFramework.game.callbacks.onPlayerSit.internal:fire(...)
	AuroraFramework.game.callbacks.onPlayerSit.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onPlayerUnsit = {
	internal = AuroraFramework.libraries.events.create("callback_onPlayerUnsit_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onPlayerUnsit_addon")
}

function onPlayerUnsit(...)
	AuroraFramework.game.callbacks.onPlayerUnsit.internal:fire(...)
	AuroraFramework.game.callbacks.onPlayerUnsit.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onCharacterSit = {
	internal = AuroraFramework.libraries.events.create("callback_onCharacterSit_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onCharacterSit_addon")
}

function onCharacterSit(...)
	AuroraFramework.game.callbacks.onCharacterSit.internal:fire(...)
	AuroraFramework.game.callbacks.onCharacterSit.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onCharacterUnsit = {
	internal = AuroraFramework.libraries.events.create("callback_onCharacterUnsit_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onCharacterUnsit_addon")
}

function onCharacterUnsit(...)
	AuroraFramework.game.callbacks.onCharacterUnsit.internal:fire(...)
	AuroraFramework.game.callbacks.onCharacterUnsit.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onCharacterPickup = {
	internal = AuroraFramework.libraries.events.create("callback_onCharacterPickup_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onCharacterPickup_addon")
}

function onCharacterPickup(...)
	AuroraFramework.game.callbacks.onCharacterPickup.internal:fire(...)
	AuroraFramework.game.callbacks.onCharacterPickup.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onEquipmentPickup = {
	internal = AuroraFramework.libraries.events.create("callback_onEquipmentPickup_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onEquipmentPickup_addon")
}

function onEquipmentPickup(...)
	AuroraFramework.game.callbacks.onEquipmentPickup.internal:fire(...)
	AuroraFramework.game.callbacks.onEquipmentPickup.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onEquipmentDrop = {
	internal = AuroraFramework.libraries.events.create("callback_onEquipmentDrop_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onEquipmentDrop_addon")
}

function onEquipmentDrop(...)
	AuroraFramework.game.callbacks.onEquipmentDrop.internal:fire(...)
	AuroraFramework.game.callbacks.onEquipmentDrop.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onCharacterPickup = {
	internal = AuroraFramework.libraries.events.create("callback_onCharacterPickup_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onCharacterPickup_addon")
}

function onCharacterPickup(...)
	AuroraFramework.game.callbacks.onCharacterPickup.internal:fire(...)
	AuroraFramework.game.callbacks.onCharacterPickup.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onPlayerRespawn = {
	internal = AuroraFramework.libraries.events.create("callback_onPlayerRespawn_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onPlayerRespawn_addon")
}

function onPlayerRespawn(...)
	AuroraFramework.game.callbacks.onPlayerRespawn.internal:fire(...)
	AuroraFramework.game.callbacks.onPlayerRespawn.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onPlayerLeave = {
	internal = AuroraFramework.libraries.events.create("callback_onPlayerLeave_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onPlayerLeave_addon")
}

function onPlayerLeave(...)
	AuroraFramework.game.callbacks.onPlayerLeave.internal:fire(...)
	AuroraFramework.game.callbacks.onPlayerLeave.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onToggleMap = {
	internal = AuroraFramework.libraries.events.create("callback_onToggleMap_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onToggleMap_addon")
}

function onToggleMap(...)
	AuroraFramework.game.callbacks.onToggleMap.internal:fire(...)
	AuroraFramework.game.callbacks.onToggleMap.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onPlayerDie = {
	internal = AuroraFramework.libraries.events.create("callback_onPlayerDie_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onPlayerDie_addon")
}

function onPlayerDie(...)
	AuroraFramework.game.callbacks.onPlayerDie.internal:fire(...)
	AuroraFramework.game.callbacks.onPlayerDie.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onVehicleSpawn = {
	internal = AuroraFramework.libraries.events.create("callback_onVehicleSpawn_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onVehicleSpawn_addon")
}

function onVehicleSpawn(...)
	AuroraFramework.game.callbacks.onVehicleSpawn.internal:fire(...)
	AuroraFramework.game.callbacks.onVehicleSpawn.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onVehicleDespawn = {
	internal = AuroraFramework.libraries.events.create("callback_onVehicleDespawn_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onVehicleDespawn_addon")
}

function onVehicleDespawn(...)
	AuroraFramework.game.callbacks.onVehicleDespawn.internal:fire(...)
	AuroraFramework.game.callbacks.onVehicleDespawn.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onVehicleLoad = {
	internal = AuroraFramework.libraries.events.create("callback_onVehicleLoad_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onVehicleLoad_addon")
}

function onVehicleLoad(...)
	AuroraFramework.game.callbacks.onVehicleLoad.internal:fire(...)
	AuroraFramework.game.callbacks.onVehicleLoad.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onVehicleUnload = {
	internal = AuroraFramework.libraries.events.create("callback_onVehicleUnload_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onVehicleUnload_addon")
}

function onVehicleUnload(...)
	AuroraFramework.game.callbacks.onVehicleUnload.internal:fire(...)
	AuroraFramework.game.callbacks.onVehicleUnload.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onVehicleTeleport = {
	internal = AuroraFramework.libraries.events.create("callback_onVehicleTeleport_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onVehicleTeleport_addon")
}

function onVehicleTeleport(...)
	AuroraFramework.game.callbacks.onVehicleTeleport.internal:fire(...)
	AuroraFramework.game.callbacks.onVehicleTeleport.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onObjectLoad = {
	internal = AuroraFramework.libraries.events.create("callback_onObjectLoad_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onObjectLoad_addon")
}

function onObjectLoad(...)
	AuroraFramework.game.callbacks.onObjectLoad.internal:fire(...)
	AuroraFramework.game.callbacks.onObjectLoad.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onObjectUnload = {
	internal = AuroraFramework.libraries.events.create("callback_onObjectUnload_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onObjectUnload_addon")
}

function onObjectUnload(...)
	AuroraFramework.game.callbacks.onObjectUnload.internal:fire(...)
	AuroraFramework.game.callbacks.onObjectUnload.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onButtonPress = {
	internal = AuroraFramework.libraries.events.create("callback_onButtonPress_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onButtonPress_addon")
}

function onButtonPress(...)
	AuroraFramework.game.callbacks.onButtonPress.internal:fire(...)
	AuroraFramework.game.callbacks.onButtonPress.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onSpawnAddonComponent = {
	internal = AuroraFramework.libraries.events.create("callback_onSpawnAddonComponent_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onSpawnAddonComponent_addon")
}

function onSpawnAddonComponent(...)
	AuroraFramework.game.callbacks.onSpawnAddonComponent.internal:fire(...)
	AuroraFramework.game.callbacks.onSpawnAddonComponent.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onVehicleDamaged = {
	internal = AuroraFramework.libraries.events.create("callback_onVehicleDamaged_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onVehicleDamaged_addon")
}

function onVehicleDamaged(...)
	AuroraFramework.game.callbacks.onVehicleDamaged.internal:fire(...)
	AuroraFramework.game.callbacks.onVehicleDamaged.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.httpReply = {
	internal = AuroraFramework.libraries.events.create("callback_httpReply_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_httpReply_addon")
}

function httpReply(...)
	AuroraFramework.game.callbacks.httpReply.internal:fire(...)
	AuroraFramework.game.callbacks.httpReply.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onFireExtinguished = {
	internal = AuroraFramework.libraries.events.create("callback_onFireExtinguished_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onFireExtinguished_addon")
}

function onFireExtinguished(...)
	AuroraFramework.game.callbacks.onFireExtinguished.internal:fire(...)
	AuroraFramework.game.callbacks.onFireExtinguished.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onForestFireSpawned = {
	internal = AuroraFramework.libraries.events.create("callback_onForestFireSpawned_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onForestFireSpawned_addon")
}

function onForestFireSpawned(...)
	AuroraFramework.game.callbacks.onForestFireSpawned.internal:fire(...)
	AuroraFramework.game.callbacks.onForestFireSpawned.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onForestFireExtinguised = {
	internal = AuroraFramework.libraries.events.create("callback_onForestFireExtinguised_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onForestFireExtinguised_addon")
}

function onForestFireExtinguised(...)
	AuroraFramework.game.callbacks.onForestFireExtinguised.internal:fire(...)
	AuroraFramework.game.callbacks.onForestFireExtinguised.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onTornado = {
	internal = AuroraFramework.libraries.events.create("callback_onTornado_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onTornado_addon")
}

function onTornado(...)
	AuroraFramework.game.callbacks.onTornado.internal:fire(...)
	AuroraFramework.game.callbacks.onTornado.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onMeteor = {
	internal = AuroraFramework.libraries.events.create("callback_onMeteor_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onMeteor_addon")
}

function onMeteor(...)
	AuroraFramework.game.callbacks.onMeteor.internal:fire(...)
	AuroraFramework.game.callbacks.onMeteor.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onTsunami = {
	internal = AuroraFramework.libraries.events.create("callback_onTsunami_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onTsunami_addon")
}

function onTsunami(...)
	AuroraFramework.game.callbacks.onTsunami.internal:fire(...)
	AuroraFramework.game.callbacks.onTsunami.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onWhirlpool = {
	internal = AuroraFramework.libraries.events.create("callback_onWhirlpool_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onWhirlpool_addon")
}

function onWhirlpool(...)
	AuroraFramework.game.callbacks.onWhirlpool.internal:fire(...)
	AuroraFramework.game.callbacks.onWhirlpool.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onVolcano = {
	internal = AuroraFramework.libraries.events.create("callback_onVolcano_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onVolcano_addon")
}

function onVolcano(...)
	AuroraFramework.game.callbacks.onVolcano.internal:fire(...)
	AuroraFramework.game.callbacks.onVolcano.main:fire(...)
end

----------------

AuroraFramework.game.callbacks.onOilSpill = {
	internal = AuroraFramework.libraries.events.create("callback_onOilSpill_frameworkInternal"),
	main = AuroraFramework.libraries.events.create("callback_onOilSpill_addon")
}

function onOilSpill(...)
	AuroraFramework.game.callbacks.onOilSpill.internal:fire(...)
	AuroraFramework.game.callbacks.onOilSpill.main:fire(...)
end

--------------------------------------------------------------------------------
--// Inits \\--
--------------------------------------------------------------------------------
AuroraFramework.services.playerService.initialize()
AuroraFramework.services.vehicleService.initialize()
AuroraFramework.services.chatService.initialize()
AuroraFramework.services.commandService.initialize()
AuroraFramework.services.HTTPService.initialize()
AuroraFramework.services.UIService.initialize()
AuroraFramework.services.TPSService.initialize()

AuroraFramework.libraries.timer.handler()

-----------------
-- [Library | Folder: p0_framework] intellisense.lua
-----------------
-------------------------------------------------
-------------------------- Game Callbacks
-------------------------------------------------

---@class af_game_callbacks_callback
---@field internal af_libs_event_event To be used by the framework
---@field main af_libs_event_event To be used by your addon

-------------------------------------------------
-------------------------- Services
-------------------------------------------------

---------------- UI
---@class af_services_ui_screen
---@field properties af_services_ui_screen_properties The properties of this UI
---@field refresh function<self> Refreshes the UI
---@field remove function<self> Remove this UI

---@class af_services_ui_screen_properties
---@field x number -1 to 1
---@field y number -1 to 1
---@field text string The text shown in the UI
---@field visible boolean Whether or not this UI is visible
---@field player af_services_player_player|nil The player this UI is shown to. Everyone if nil
---@field id number The ID of this UI

---@class af_services_ui_map_label
---@field properties af_services_ui_map_label_properties The properties of this UI
---@field refresh function<self> Refreshes the UI
---@field remove function<self> Remove this UI

---@class af_services_ui_map_label_properties
---@field pos SWMatrix The position where this UI is shown on the map
---@field text string The text shown in the UI
---@field visible boolean Whether or not this UI is visible
---@field player af_services_player_player|nil The player this UI is shown to. Everyone if nil
---@field id number The ID of this UI
---@field labelType SWLabelTypeEnum The type of label

---@class af_services_ui_map_object
---@field properties af_services_ui_map_object_properties The properties of this UI
---@field refresh function<self> Refreshes the UI
---@field remove function<self> Remove this UI
---@field attach function<self, integer, integer> First param == Position Type, Second Param == Object ID/Vehicle ID

---@class af_services_ui_map_object_properties
---@field pos SWMatrix The position where this UI is shown on the map
---@field title string The title
---@field subtitle string The subtitle
---@field visible boolean Whether or not this UI is visible
---@field player af_services_player_player|nil The player this UI is shown to. Everyone if nil
---@field id number The ID of this UI
---@field objectType SWMarkerTypeEnum The type of map object
---@field positionType SWPositionTypeEnum 0, 1, or 2 (fixed, vehicle, object)
---@field attachID integer Vehicle ID/Object ID
---@field r integer 0-255
---@field g integer 0-255
---@field b integer 0-255
---@field a integer 0-255
---@field radius number The radius of this map object

---------------- HTTP
---@class af_services_http_request
---@field properties af_services_http_request_properties The properties of this request
---@field cancel function<self> Cancel this request

---@class af_services_http_request_properties
---@field port integer The port of this request
---@field url string The URL of this request
---@field event af_libs_event_event Reply event

---------------- Messages
---@class af_services_chat_message
---@field properties af_services_chat_message_properties The properties of this message
---@field delete function<self, af_services_player_player|nil> Delete this message
---@field edit function<self, string, af_services_player_player|nil> Edit this message

---@class af_services_chat_message_properties
---@field author af_services_player_player The player who sent this message
---@field content string The content of this message
---@field id integer The ID of this message
---@field isSentByPlayer boolean True = sent by player, False = sent by addon

---------------- Commands
---@class af_services_commands_command
---@field properties af_services_commands_command_properties The properties of this command
---@field events af_services_commands_command_events The events of this command
---@field remove function<self> Remove this command

---@class af_services_commands_command_events
---@field onActivation af_libs_event_event Event for the activation of this command

---@class af_services_commands_command_properties
---@field name string The name of this command
---@field requiresAdmin boolean Whether or not this command requires admin
---@field requiresAuth boolean Whether or not this command requires auth
---@field description string The description of this command. Unused by this framework
---@field shorthands table<integer, string> The shorthands of this command
---@field capsSensitive boolean Whether or not this command is caps sensitive (true = "?coMmand" doesn't works, false = "?ComMand" works)

---------------- Vehicles
---@class af_services_vehicle_vehicle
---@field properties af_services_vehicle_vehicle_properties The properties of this vehicle
---@field despawn function<self> Despawn this vehicle
---@field explode function<self, number|nil> Explode this vehicle. Second param is optional magnitude (0-1). Weapons DLC required
---@field teleport function<self, SWMatrix> Teleport this vehicle to a position
---@field getPosition function<self, number|nil, number|nil, number|nil> Get the position of this vehicle
---@field getLoadedVehicleData function<self> Raw vehicle data that can be retrieved when this vehicle is loaded
---@field setInvulnerability function<self, boolean> Sets whether or not this vehicle can receive damage (true = invincible, false = can receive damage)
---@field setEditable function<self, boolean> Sets whether or not this vehicle is editable (can be brought to the workbench)
---@field setTooltip function<self, string> Sets the tooltip of this vehicle

---@class af_services_vehicle_vehicle_properties
---@field owner af_services_player_player The owner of this player, or nil if addon spawned
---@field addonSpawned boolean Whether or not this vehicle was spawned by an addon
---@field name string The name of this vehicle
---@field vehicle_id integer The ID of this vehicle
---@field spawnPos SWMatrix The position this vehicle was spawned at
---@field cost number The cost of this vehicle, or 0 if infinite money is on
---@field loaded boolean Whether or not this vehicle is loaded
---@field storage af_libs_storage_storage The storage for this vehicle

---------------- Players
---@class af_services_player_player
---@field properties af_services_player_player_properties The properties of this player
---@field setItem function<self, SWSlotNumberEnum, SWEquipmentTypeEnum, boolean, integer|nil, float|nil> Give this player an item
---@field removeItem function<self, SWSlotNumberEnum> Remove whatever item is in the specified slotf rom this player
---@field kick function<self> Kick this player from the server
---@field ban function<self> Ban this player from the server
---@field teleport function<self, SWMatrix> Teleport this player to a position
---@field getPosition function<self> Get the position of this player
---@field getCharacter function<self> Get the object ID of this player's character
---@field damage function<self, number> Damage this player
---@field kill function<self> Kill this player
---@field setAdmin function<self, boolean> Gives/removes admin from this player
---@field setAuth function<self, boolean> Gives/removes auth from this player

---@class af_services_player_player_properties
---@field steam_id string The Steam ID of this player
---@field name string The name of this player
---@field peer_id integer The ID of this player
---@field admin boolean Whether or not this player is an admin
---@field auth boolean Whether or not this player has auth
---@field isHost boolean Whether or not this player is the host
---@field storage af_libs_storage_storage The storage for this player

-------------------------------------------------
-------------------------- Libraries
-------------------------------------------------

---------------- Storage
---@class af_libs_storage_storage
---@field name string The name of this storage
---@field data table<any, any> Table containing saved data
---
---@field save function<self, any, any> Save a value to this storage
---@field get function<self, any> Retrieve a value saved to this storage
---@field destroy function<self, any> Remove a value saved to this storage
---
---@field remove function<self> Remove this storage

---------------- Timer
---@class af_libs_timer_loop
---@field duration number Duration of the loop in seconds
---@field creationTime number
---@field event af_libs_event_event Event to connect functions to. The loop itself is the first param passed to the event on loop completion
---@field id integer The ID of this loop
---
---@field remove function<self> Remove this loop
---@field setDuration function<self, number> Set the duration of this loop

---@class af_libs_timer_delay
---@field duration number Duration of the delay in seconds
---@field creationTime number
---@field event af_libs_event_event Event to connect functions to. The delay itself is the first param passed to the event on delay completion
---@field id integer The ID of this delay
---
---@field remove function<self> Remove this delay
---@field setDuration function<self, number> Set the duration of this delay

---------------- Events
---@class af_libs_event_event
---@field name string The name of this event
---@field connections table<integer, function> Table containing functions connected to this event
---
---@field fire function<self> Call all functions connected to this event
---@field clear function<self> Clear all functions connected to this event
---@field remove function<self> Remove the event
---@field connect function<self, function> Connect a function to this event

-----------------
-- [Library | Folder: p1_libraries] announce.lua
-----------------
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

-----------------
-- [Library | Folder: p1_libraries] debug.lua
-----------------
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

-----------------
-- [Library | Folder: p1_libraries] miscellaneous.lua
-----------------
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

-----------------
-- [Library | Folder: p2_callbackHandlers] playerJoin.lua
-----------------
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

-----------------
-- [Library | Folder: p2_callbackHandlers] playerLeave.lua
-----------------
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

-----------------
-- [Library | Folder: p3_commands] help.lua
-----------------
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

-----------------
-- [Library | Folder: p3_commands] toggle.lua
-----------------
---------------------------------------
------------- [Command] Toggles whether or not oil spills are cleaned up
---------------------------------------

---@param command af_services_commands_command
---@param args table<integer, string>
---@param player af_services_player_player
AuroraFramework.services.commandService.create(function(command, args, player)
    if not player.properties.admin then
        return announceLibrary.status.failure("This command requires admin.", player)
    end

    local enabled = oilSpillCleanupEnabled
    oilSpillCleanupEnabled = not enabled

    chatAnnounce(player.properties.name.." has "..AuroraFramework.libraries.miscellaneous.switchbox("disabled", "enabled", not enabled).." oil spill cleanup.")
end, "oc_toggle", {"oct"}, false, "Toggles oil spill cleanup.")

-----------------
-- [Main File] main.lua
-----------------
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
------------- Oil Cleanup
-- Oil Cleanup Queue
---@type table<integer, SWMatrix>
local oilCleanupQueue = {}

AuroraFramework.libraries.timer.loop.create(0.005, function()
    local nextUp = oilCleanupQueue[1]

    if not nextUp then
        return
    end

    server.setOilSpill(nextUp, -100)
    server.setOilSpill(nextUp, 0)

    table.remove(oilCleanupQueue, 1)
end)

-- Clear oil
---@param pos SWMatrix
clearOil = function(pos)
    table.insert(oilCleanupQueue, pos)
end

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