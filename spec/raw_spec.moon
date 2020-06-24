describe "raw module", ->
	for implementation in *{"lua", "native"}
		raw = require "msgpck.#{implementation}.raw"
		describe "#{implementation} implementation", ->
			it "should work", -> assert.truthy false
