msgpck = require 'msgpck'

shorten = (n=10) => @gsub("^(#{'.'\rep(n)}).*(#{'.'\rep(n)})$", "%1...%2 (#{#@})")

hex = => @gsub ".", => string.format '%02x', @byte!

describe 'msgpck', ->
	pending "number_encoder", ->
	describe "string_encoder", ->
		prefixes = (prefix, item) ->
			assert.equal shorten(prefix..hex(item), 10), shorten(hex(msgpck\encode(item)), 10)

		it "encodes fixstr", ->
			prefixes 'a0', ''
			prefixes 'bf', 'x'\rep 31
		it "encodes str 8", ->
			prefixes 'd920', 'x'\rep 32
			prefixes 'd9ff', 'x'\rep 255
		it "encodes str 16", ->
			prefixes 'da0100', 'x'\rep 256
			prefixes 'daffff', 'x'\rep 256*256-1
		it "encodes str 32 #slow", ->
			prefixes 'db00010000', 'x'\rep 256*256
			prefixes 'db0001ffff', 'x'\rep 256*256*2-1

	describe "array_encoder", ->
		it "encodes fixarray", ->
			assert.equal hex('\x91\xa0'), hex(msgpck\encode({''}))
			assert.equal hex('\x92\xa0\xa0'), hex(msgpck\encode({'', ''}))
	pending "map_encoder", ->
