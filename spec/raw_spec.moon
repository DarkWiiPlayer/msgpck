hex = (str) -> str\gsub(".", => string.format("0x%2x ", @byte!))\gsub("%s+$", '')

describe "raw module", ->
	for implementation in *{"lua", "native"}
		raw = require "msgpck.#{implementation}.raw"

		describe "#{implementation} implementation", ->
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
				it "should convert small numbers correctly", ->
					assert.equal hex("\x20"), hex(raw.fixnum(0x20))

			----- Floating point numbers

			----- Character strings

			----- Structured data types
