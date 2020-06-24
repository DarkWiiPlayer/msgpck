/// C analogue to the msgpck.lua.raw module
// @module msgpck.native.raw

#include <lua.h>

int luaopen_msgpck_native_raw(lua_State *L)
{
	lua_newtable(L);
	return 1;
}
