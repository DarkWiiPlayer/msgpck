/// C analogue to the msgpck.lua.raw module
// @module msgpck.native.raw

#include <lua.h>

int l_nil(lua_State *L)
{
	lua_pushliteral(L, "\xc0");
	return 1;
}

int l_bool(lua_State *L)
{
	if (lua_toboolean(L, lua_gettop(L))) {
		lua_pushliteral(L, "\xc3"); // True
	} else {
		lua_pushliteral(L, "\xc2"); // False
	}
	return 1;
}

int l_fixnum(lua_State *L)
{
	int result = lua_tointeger(L, lua_gettop(L)) & 0x127;
	lua_pushlstring(L, (char*)&result, 1);
	return 1;
}

int luaopen_msgpck_native_raw(lua_State *L)
{
	lua_newtable(L);
	int M = lua_gettop(L);

	lua_pushstring(L, "nil");
	lua_pushcfunction(L, &l_nil);
	lua_settable(L, M);

	lua_pushstring(L, "Nil");
	lua_pushstring(L, "nil");
	lua_gettable(L, M);
	lua_settable(L, M);

	lua_pushstring(L, "bool");
	lua_pushcfunction(L, &l_bool);
	lua_settable(L, M);

	return 1;
}
