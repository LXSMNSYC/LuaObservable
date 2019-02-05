local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable)
	return new(_, function (next, err, complete, closed)
		local maxValue = -2^32
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					if(x > maxValue) then 
						maxValue = x 
					end
				else 
					cleanup()
				end
			end,
			err,
			function ()
				next(maxValue)
				complete()
			end
		)
	end)
end 