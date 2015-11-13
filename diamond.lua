local dbug = true

local function dprint(...)
	if dbug then
		print(...)
	end
end

dprint("Loading libraries")
local lfs = require("lfs")
local modules = {}
for item in lfs.dir("libraries") do
	if not item:match("^%.") and item:match("%..lua$") then
		modules[item:match("^.+%.lua$"):lower()] = require(item)
		-- This shows up as the name with the first character capitalized unless
		-- you give a .title() method
	end
end

library = assert(loadfile("lib.lua")) -- Just to test

dprint("Running server functions")
srv.Use(mw.Logger())

srv.GET("/", mw.new(function()
	lib = require("lib")
	return lib.page("Yay")
end))

srv.GET("/:page", mw.new(function()
	lib = require("lib")
	return lib.genpage()
end))
