local new = require "LuaObservable.src.new"

--[[
	Empty

	Returns a completed observable
]]

return function ()
	return new(_, function (next, err, complete)
		complete()        
	end)
end 