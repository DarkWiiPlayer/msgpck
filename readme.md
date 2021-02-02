MsgPck
================================================================================

A flexible MessagePack library for Lua

Implementations:
  - `string.pack` for 5.3 and above
  - Using FFI types for LuaJIT
  - Native for the lolz

Structure:
  - Raw
    - Atomic types
    - Preamble for complex types
  - User
    - universal encode / decode
    - something for arrays
    - (?)
