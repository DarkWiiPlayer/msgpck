/// C analogue to the msgpck.lua.raw module
// @module msgpck.native.raw

#include <lua.h>
#include <stdio.h>

/// Returns a string representing a messagepack nil value
// @function nil
int l_nil(lua_State *L)
{
	lua_pushliteral(L, "\xc0");
	return 1;
}

/// Returns a string representing a messagepack boolean value encoding the truthyness of the given element
// @param value Any Lua value to convert to a boolean
// @function bool
int l_bool(lua_State *L)
{
	if (lua_toboolean(L, lua_gettop(L))) {
		lua_pushliteral(L, "\xc3"); // True
	} else {
		lua_pushliteral(L, "\xc2"); // False
	}
	return 1;
}

/// Returns a string representing the lowest 7 bits of the input number as a fixnum
// @tparam number Number A number between -32 and 127 to convert
// @function fixnum
int l_fixnum(lua_State *L)
{
	int input = lua_tointeger(L, lua_gettop(L));
	char result;
	if (input >= 0)
		// 0XXX XXXX ( 0 to 127 (0x7f))
		{ result = input & 0x7f; }
	else
		// 111Y YYYY (-1 to -32 (0xe0))
		{ result = (input & 0x1f) | 0xe0; }
	lua_pushlstring(L, &result, 1);
	return 1;
}

void register_function(lua_State *L, int M, char *name, lua_CFunction func)
{
	lua_pushstring(L, name);
	lua_pushcfunction(L, func);
	lua_settable(L, M);
}

int luaopen_msgpck_native_raw(lua_State *L)
{
	lua_newtable(L);
	int M = lua_gettop(L);

	register_function(L, M, "nil", &l_nil);
	lua_pushstring(L, "Nil");
	lua_pushstring(L, "nil");
	lua_gettable(L, M);
	lua_settable(L, M);

	register_function(L, M, "bool", &l_bool);
	register_function(L, M, "fixnum", &l_fixnum);

	return 1;
}
