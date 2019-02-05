local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable, emitter)
	assert(isObservable(emitter), "TypeError: emitter must be an Observable.")
	return new(_, function (next, err, complete, closed)
		local beginEmission = false 

		local cleanupA
		local cleanupB 
		
		cleanupA = subscribe(observable,
			function (x)
				if(not closed()) then 
					if(beginEmission) then 
						next(x)
					end
				else 
					cleanupA()
				end
			end,
			err,
			complete
		)

		cleanupB = subscribe(emitter,
			function (x)
				if(beginEmission or not closed()) then 
					beginEmission = true 
				else 
					cleanupB()
				end 
			end
		)
	end)
end