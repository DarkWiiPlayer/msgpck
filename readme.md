MsgPck
================================================================================

A flexible MessagePack library for Lua.

Customisable
----------------------------------------

The following things can be overridden to customise the library:

- `nil`-placeholder, for better integration with other libraries
- Array predicate
	- Can return a static length
	- Otherwise `ipairs` is used
- Array length hook to handle array lengths after decoding
