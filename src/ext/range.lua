local new = require "LuaObservable.src.new"

local abs = math.abs

--[[
	Range

	Turns a given range, regardless of the direction (whether descending
	or ascending) into an Observable
]]
return function (s, e)
	assert(type(s) == "number", "TypeError: s is not a number (s : "..type(s)..")")
	assert(type(e) == "number", "TypeError: e is not a number (e : "..type(e)..")")
	local sgn = (e - s)/abs(e - s)
	return new(_, function (next, err, complete, closed)
		for i = s, e, sgn do 
			next(i)

			if(closed()) then 
				return 
			end 
		end 
		complete()
	end)
end 