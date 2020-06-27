--- Implements raw conversions from Lua values to MessagePack strings
-- @module msgpck.lua.raw

local major, minor = _VERSION:match("(%d+)%.(%d+)")
major, minor = tonumber(major), tonumber(minor)

if not major and minor then
	error("Could not figure out Lua version (Check compatibility)")
end

local raw = {}

function raw.Nil()
	return "\xc0"
end
raw['nil'] = raw.Nil

function raw.bool(elem)
	return elem and "\xc3" or "\xc2"
end

return raw
