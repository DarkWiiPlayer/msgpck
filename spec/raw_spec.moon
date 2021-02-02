hex = (str) -> str\gsub(".", => string.format("0x%02x ", @byte!))\gsub("%s+$", '')

describe "raw module", ->
	for implementation in *{"pack", "ffi", "native"}
		before_each -> export raw = require "msgpck.raw.#{implementation}"

		describe "#{implementation} implementation ##{implementation}", ->
			it "should return a module", ->
				assert.is.table raw

			----- Atoms

			describe "nil", ->
				it "should return a 'nil' value", ->
					assert.equal "\xc0", raw.nil()
				it "should be aliased as Nil", ->
					assert.equal raw.nil, raw.Nil

			describe "bool", ->
				it "should return 'false' for nil values", ->
					assert.equal hex("\xc2"), hex(raw.bool(false))
				it "should return 'false' for false values", ->
					assert.equal hex("\xc2"), hex(raw.bool(false))

			----- Integers

			describe "fixnum", ->
				it "should convert small positive numbers correctly", ->
					assert.equal hex("\x20"), hex(raw.fixnum(0x20))
					assert.equal hex("\x30"), hex(raw.fixnum(0x30))
					assert.equal hex("\x32"), hex(raw.fixnum(0x32))
--					assert.equal hex("\x05"), hex(raw.fixnum(0x85))
				it "should convert small negative numbers correctly", ->
					assert.equal hex("\xff"), hex(raw.fixnum(-1))
					assert.equal hex("\xf6"), hex(raw.fixnum(-10))
					assert.equal hex("\xe0"), hex(raw.fixnum(-32))

			----- Floating point numbers

			----- Character strings

			----- Structured data types
