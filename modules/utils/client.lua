if not lib then return end

local Utils = {}

function Utils.PlayAnim(wait, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
	lib.requestAnimDict(dict)
	TaskPlayAnim(cache.ped, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
	RemoveAnimDict(dict)

	if wait > 0 then Wait(wait) end
end

function Utils.PlayAnimAdvanced(wait, dict, name, posX, posY, posZ, rotX, rotY, rotZ, blendIn, blendOut, duration, flag,
                                time)
	lib.requestAnimDict(dict)
	TaskPlayAnimAdvanced(cache.ped, dict, name, posX, posY, posZ, rotX, rotY, rotZ, blendIn, blendOut, duration, flag, time
		, 0, 0)
	RemoveAnimDict(dict)

	if wait > 0 then Wait(wait) end
end

---@param flag number
---@param destination? vector3
---@param size? number
---@return number | false
---@return number?
function Utils.Raycast(flag, destination, size)
	local playerCoords = GetEntityCoords(cache.ped)
	destination = destination or GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 2.2, -0.25)
	local rayHandle = StartShapeTestCapsule(playerCoords.x, playerCoords.y, playerCoords.z + 0.5, destination.x,
		destination.y, destination.z, size or 2.2, flag or 30, cache.ped, 4)
	while true do
		Wait(0)
		local result, _, coords, _, entityHit = GetShapeTestResult(rayHandle)
		if result ~= 1 then
			-- DrawLine(playerCoords.x, playerCoords.y, playerCoords.z + 0.5, destination.x, destination.y, destination.z, 0, 0, 255, 255)
			-- DrawLine(playerCoords.x, playerCoords.y, playerCoords.z + 0.5, coords.x, coords.y, coords.z, 255, 0, 0, 255)
			-- The shape test returns 0 when it hits no entity, and 0 is a **truthy** value in Lua; so the check
			-- `if entityHit then` used to pass the zero to GET_ENTITY_TYPE so it threw:
			--   Error executing native 0x97F696ACA466B4E0
			-- (it shows on pressing U near nothing). We check the handle before any native.
			local entityType
			if entityHit and entityHit ~= 0 and DoesEntityExist(entityHit) then
				entityType = GetEntityType(entityHit)
			end
			if entityType and entityType ~= 0 then
				return entityHit, entityType
			end
			return false
		end
	end
end

-- ============================================================
-- Notifications: the library draws them (w.notify). The server sends dictionary keys
-- (`key` + `args`, or a `title`/`description` that is a key) and the client translates
-- them here, so every player reads the message in his own language.
-- ============================================================

--- The label of an item in the player's language (the client catalogue), for a message
--- argument the server wrote as { item = '<name>', text? = '<format with one %s>' }.
---@param arg any
---@return any
local function resolveArg(arg)
	if type(arg) ~= 'table' or type(arg.item) ~= 'string' then return arg end

	local Items = require 'modules.items.client'
	local def = Items[arg.item] or Items(arg.item)
	local label = def and def.label or arg.item

	return type(arg.text) == 'string' and arg.text:format(label) or label
end

---@param data NotifyProps | string | { key?: string, args?: any[] }
function Utils.Notify(data)
	if type(data) == 'string' then data = { description = data } end
	if type(data) ~= 'table' then return end

	if data.key then
		local args = data.args or {}
		-- unpack as many values as the template has specifiers: a trailing nil argument
		-- (an item with no label) must not shorten the list and break string.format
		local _, specifiers = tostring(locale(data.key)):gsub('%%[-%d%.]*%a', '')
		local count = math.max(specifiers, #args)

		for i = 1, count do args[i] = resolveArg(args[i]) end

		data.description = locale(data.key, table.unpack(args, 1, count))
		data.key, data.args = nil, nil
	elseif type(data.description) == 'string' then
		-- locale() hands back a string that is not a key untouched
		data.description = locale(data.description)
	end

	if type(data.title) == 'string' and data.title ~= '' then
		data.title = locale(data.title)
	end

	local text = data.text or data.description or ''
	if text == '' then return end

	data.description = text
	data.text = nil
	data.id = nil
	data.isRTL = shared.localeKey() == 'ar'

	w.notify(data)
end

RegisterNetEvent('w_inventory:notify', Utils.Notify)
exports('notify', Utils.Notify)

---@param data { [1]: SlotWithItem, [2]: 'ui_added' | 'ui_removed' | 'ui_equipped' | 'ui_holstered', [3]: number? }
function Utils.ItemNotify(data)
	if not client.itemnotify then
		return
	end

	local item = data[1]
	local count = math.floor(tonumber(data[3]) or 1) -- a whole number: %d in Lua 5.4 refuses fractional numbers
	local added = data[2] == 'ui_added' or data[2] == 'ui_equipped'
	-- a custom (metadata) label as it is; a catalogue label in the player's language
	local label = item and (item.metadata?.label or (item.name and resolveArg({ item = item.name })) or item.label) or ''
	-- the item's own picture (client.image, already a full nui:// path) as the bag shows it: the file is
	-- not always named after the item (the hunting parts, satchel_small -> bag_small ...); else <name>.png
	local def = item and item.name and (require 'modules.items.client')[item.name]
	local image = def and type(def.client) == 'table' and def.client.image
	local iconUrl = (type(image) == 'string' and image ~= '' and image)
		or ((item and item.name) and ('nui://w_inventory/web/images/' .. item.name .. '.png')) or nil

	-- a removed item is not an error: its word says what happened, and red stays the mark of a
	-- real failure (the notice's frame turns red only for type 'error')
	w.notify({
		description = ('%s ×%d %s'):format(locale(data[2]), count, label),
		icon        = iconUrl,
		type        = added and 'success' or 'inform',
		duration    = 3500,
		isRTL       = shared.localeKey() == 'ar',
	})
end

RegisterNetEvent('w_inventory:itemNotify', Utils.ItemNotify)

-- ============================================================
-- Walk-up places (shops, crafting benches, stashes, evidence lockers, drops): a marker
-- drawn from afar and the library's proximity prompt (w.prompt.at) shown next to it.
-- Labels are dictionary readers (functions) so a live language switch relabels every
-- place that is alive (Utils.RelabelPlaces, called once the dictionary is reloaded).
-- ============================================================
local places = {}
local nextPlace = 0

---The prompt is never offered while the bag (or any other page) holds the keyboard, while
---the bag is busy (an item in use) or while the player is down or cuffed - the states that
---refuse to open any inventory.
---@param canInteract? fun(): boolean
---@return fun(): boolean
local function placeCanInteract(canInteract)
	return function()
		local state = LocalPlayer.state

		if state.invOpen or state.invBusy or IsNuiFocused() then return false end
		if PlayerData.dead or IsPedCuffed(cache.ped) then return false end

		return not canInteract or canInteract() == true
	end
end

---@param value string | fun(): string
---@return string
local function readLabel(value)
	if type(value) == 'function' then return tostring(value() or '') end
	return tostring(value or '')
end

---@class WPlacePrompt
---@field key string keyboard key name ('J', 'G', ...)
---@field label string | fun(): string a dictionary reader
---@field hold? number | false hold time in ms
---@field onComplete fun(place: WPlace)

---@class WPlaceOptions
---@field coords vector3
---@field distance? number how close the player must stand for the prompt (default 1.2)
---@field markerDistance? number how far the marker is drawn from (default 16)
---@field marker? { r: number, g: number, b: number } | false marker colour; false draws none
---@field title? string | false | fun(): string
---@field prompts WPlacePrompt[]
---@field canInteract? fun(): boolean re-checked every frame while the player stands inside

---@class WPlace
---@field id integer
---@field coords vector3
---@field point CPoint? the marker point
---@field prompt table the w.prompt.at record
---@field remove fun()

-- The marker is paint, and every interface is RDR's black and white: paper, never a hue.
-- A caller's colour is kept only as a paper tone picked by its luminance (paper, paper-dim,
-- paper-faint), so an old call site that still passes a colour can never draw one.
local MARKER_PAPER = { r = 242, g = 242, b = 242 }
local MARKER_TONES = { { 242, 242, 242 }, { 180, 180, 180 }, { 122, 122, 122 } }

---@param r? number
---@param g? number
---@param b? number
---@return number, number, number
local function markerTone(r, g, b)
	r, g, b = tonumber(r), tonumber(g), tonumber(b)
	if not (r and g and b) then return 242, 242, 242 end

	local lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
	local best, bestDist = MARKER_TONES[1], math.huge

	for i = 1, #MARKER_TONES do
		local tone = MARKER_TONES[i]
		local dist = math.abs(lum - (0.2126 * tone[1] + 0.7152 * tone[2] + 0.0722 * tone[3]))
		if dist < bestDist then best, bestDist = tone, dist end
	end

	return best[1], best[2], best[3]
end

---A walk-up place: one marker point plus one library prompt record.
---@param opts WPlaceOptions
---@return WPlace
function Utils.Place(opts)
	nextPlace += 1

	local place = { id = nextPlace, coords = opts.coords, labels = {}, title = opts.title }
	local canInteract = placeCanInteract(opts.canInteract)
	local prompts = {}

	for i = 1, #opts.prompts do
		local entry = opts.prompts[i]
		local key = tostring(entry.key):upper()

		place.labels[key] = entry.label
		prompts[i] = {
			key = key,
			label = readLabel(entry.label),
			hold = entry.hold or false,
			onComplete = function() entry.onComplete(place) end,
		}
	end

	place.prompt = w.prompt.at({
		coords = opts.coords,
		distance = opts.distance or 1.2,
		title = type(opts.title) == 'function' and readLabel(opts.title) or opts.title or false,
		prompts = prompts,
		canInteract = canInteract,
	})

	local marker = opts.marker

	if marker ~= false then
		marker = marker or MARKER_PAPER
		local r, g, b = markerTone(marker.r or marker[1], marker.g or marker[2], marker.b or marker[3])

		place.point = lib.points.new({
			coords = opts.coords,
			distance = opts.markerDistance or 16,
			nearby = function(point)
				if opts.canInteract and not opts.canInteract() then return end
				---@diagnostic disable-next-line: param-type-mismatch
				DrawMarker(0x07DCE236, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, r, g, b, 222, false, false, 0, true, false, false, false)
			end,
		})
	end

	function place.remove()
		if places[place.id] == nil then return end

		places[place.id] = nil
		place.prompt.remove()

		if place.point then
			place.point:remove()
			place.point = nil
		end
	end

	places[place.id] = place

	return place
end

---Re-read every label of every live place (the dictionary was just reloaded).
function Utils.RelabelPlaces()
	for _, place in pairs(places) do
		for key, label in pairs(place.labels) do
			place.prompt.setLabel(key, readLabel(label))
		end

		if type(place.title) == 'function' then
			place.prompt.setTitle(readLabel(place.title))
		end
	end
end

-- Suspend inventory weapon use while another activity owns the weapon wheel.
-- Weapon switching and ammunition are handled by the RedM weapon engine.
---@param state? boolean Omit to retain the current mode across ped/seat changes.
function Utils.WeaponWheel(state)
	if state == nil then state = EnableWeaponWheel end

	EnableWeaponWheel = state == true
end

exports('weaponWheel', Utils.WeaponWheel)

return Utils
