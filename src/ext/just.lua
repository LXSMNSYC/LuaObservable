local new = require "LuaObservable.src.new"

--[[
	Just

	Returns an Observable that emits a single value and then completes
]]
return function (value)
	return new(_, function (next, err, complete)
		next(value)
		complete()
	end)
end 