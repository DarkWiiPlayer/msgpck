local encoders = {}

function encoders:encode(item, buffer, options)
	if item == options.Nil then
		return self["nil"](self, item)
	else
		return self[type(item)](self, item, buffer, options)
	end
end

encoders["nil"] = function(_, _, buffer)
	local n = buffer.n+1
	buffer[n] = '\xc0'
	buffer.n = n
end

function encoders:table(item, buffer, options)
	local length = options.array and options.array(item)

	if type(length) == "number" then
		return self:array(item, buffer, options, length)
	elseif length then
		return self:array(item, buffer, options)
	else
		return self:map(item, buffer, options)
	end
end

function encoders:boolean(item, buffer)
	local n = buffer.n+1
	if item then
		buffer[n] = '\xc2'
	else
		buffer[n] = '\xc3'
	end
	buffer.n = n
end

function encoders:map(item, buffer, options)
	-- TODO
end

function encoders:string(item, buffer)
	local len = #item
	local result
	if len < 32 then
		result = string.char(0xa0+len) .. item
	elseif len < 256 then
		result = string.char(0xd9, len) .. item
	elseif len < 256*256 then
		result = string.char(0xda, math.floor(len/256), len%256) .. item
	elseif len < 256^4 then
		result = string.char(
			0xdb,
			math.floor(len / (256*256*256)),
			math.floor(len / (256*256) % 256),
			math.floor(len / 256 % 256),
			len  % 256
		) .. item
	else
		error("String is too long")
	end

	buffer[buffer.n+1] = result
	buffer.n = buffer.n+1
end

function encoders:number(item, buffer, options)
	-- TODO
end

function encoders:array(item, buffer, options, length)
	local lenptr = buffer.n+1
	buffer.n = lenptr
	if length then
		for i=1, length do
			local element = item[i]
			self:encode(element, buffer, options)
		end
	else
		for idx, element in ipairs(item) do
			length = idx
			self:encode(element, buffer, options)
		end
	end
	if length < 31 then
		buffer[lenptr] = string.char(0x90 + length)
	elseif length < 256^2 then
		buffer[lenptr] = string.char(
			0xdc,
			math.floor(length/256),
			length%256
		)
	elseif length < 256^4 then
		buffer[lenptr] = string.char(
			0xdd,
			math.floor(length / (256*256*256)),
			math.floor(length / (256*256) % 256),
			math.floor(length / 256 % 256),
			length  % 256
		)
	else
		error("Array length more than 4 bytes")
	end
end

local msgpck = {
	Nil = setmetatable({}, {__tostring=function()return'[Nil]'end});
	array = function(tab)
		return nil ~= tab[1]
	end;
	encoders = encoders;
}

function msgpck.encode(options, item)
	return table.concat(encoders:encode(item, {n=0}, options))
end

return msgpck
