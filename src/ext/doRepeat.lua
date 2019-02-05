local new = require "LuaObservable.src.new"
--[[
	doRepeat

	Returns an Observable that emits a value multiple times
]]
return function (value, iterations)
	assert(type(iterations) == "number", "TypeError: iterations is not a number (iterations : "..type(iterations)..")")
	assert(iterations > -1, "TypeError: iterations is not a positive number ")
	return new(_, function (next, err, complete, closed)
		for i = 1, iterations do
			next(i)

			if(closed()) then 
				return 
			end 
		end 
		complete()
	end)
end 