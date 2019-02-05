
local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable)
	return new(_, function (next, err, complete, closed)
		local minValue = 2^32
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					if(x < minValue) then 
						minValue = x 
					end
				else 
					cleanup()
				end
			end,
			err,
			function ()
				next(minValue)
				complete()
			end
		)
	end)
end 