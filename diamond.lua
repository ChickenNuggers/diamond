local debug = true

local function dprint(...)
	if debug then
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
local T=tag

dprint("Initializing functions")
function page(content, errnum)
	local names = {}
	for k in pairs(modules) do
		if not tonumber(k) then
			table.append(names, k)
		end
	end
	local text = doctype()(
		T"head"(
			T"title""Diamond", -- Add in scripts and CSS as needed
			T"link"[{rel="stylesheet", href="https://ajax.googleapis.com/ajax/libs/angular_material/1.0.0-rc1/angular-material.min.css"}]()
		),
		T"body"[{layout="column"}](
			T"md-toolbar"[{layout="row"}](
				T"div"[{class="mdl-toolbar-tools"}](
					T"h1""Diamond - Linux System Interface"
				)
			),
			T"div"[{layout="row", class="flex"}](
				T"md-sidenav"[{layout="column", class="md-sidenav-left md-whiteframe-4dp", ["md-component-id"]="left"}](
					T"md-button"[{class="md-accent"}](names[1])
				),
				T"div"[{layout="column", id="content", class="flex"}](
					T"md-content"[{layout="column", class="flex md-padding"}](
						T"div"(content)
					)
				)
			)
		)
	):render()
	return text, errnum
end

function genpage(title)
	local page = params("page"):lower()
	if not modules[page] then
		page = 404
	end
	return content(page(modules[page].generate()))
end

dprint("Running server functions")
srv.Use(mw.Logger())

srv.GET("/", mw.new(function()
	return page("Yay")
end))

srv.GET("/:page", mw.new(genpage))
