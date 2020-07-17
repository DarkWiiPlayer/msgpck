--- Implements raw conversions from Lua values to MessagePack strings.
-- All conversions in this module assume the passed data is of the correct format and within the correct range.
-- @module msgpck.lua.raw

local major, minor = _VERSION:match("(%d+)%.(%d+)")
major, minor = tonumber(major), tonumber(minor)

if not major and minor then
	error("Could not figure out Lua version (Check compatibility)")
end

local raw = {}

--- Returns a string representing a messagepack nil value
function raw.Nil()
	return "\xc0"
end
raw['nil'] = raw.Nil

--- Returns a string representing a messagepack boolean value encoding the truthyness of the given element
-- @param value Any Lua value to convert to a boolean
function raw.bool(elem)
	return elem and "\xc3" or "\xc2"
end

--- Returns a string representing the lowest 7 bits of the input number as a fixnum
-- @tparam number A number between -32 and 127 to convert
-- @function fixnum
function raw.fixnum(elem)
	return string.char(math.floor(elem % 0x100))
end

return raw
