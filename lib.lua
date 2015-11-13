local lib = {}

function lib.page(content, errnum)
	local T=tag
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

function lib.genpage(title)
	local page = params("page"):lower()
	if not modules[page] then
		page = 404
	end
	return content(page(modules[page].generate()))
end

return lib
