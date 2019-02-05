local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"

local function defaultCombinator(...)
	return {...}
end

return function (observable, emitter, combinator)
	assert(isObservable(emitter), "TypeError: emitter must be an Observable.")
	combinator = type(combinator) == "function" and combinator or defaultCombinator
	return new(_, function (next, err, complete, closed)

		local emissionReadyA = false
		local emissionReadyB = false
		local lastValueA = nil
		local lastValueB = nil

		local endA = false 
		local endB = false 
		
		local cleanupA 
		local cleanupB

		cleanupA = subscribe(observable,
			function (x)
				if(not closed()) then 
					lastValueA = x 
					emissionReadyA = true 
					if(emissionReadyB) then 
						local status, result = pcall(function ()
							return combinator(lastValueA, lastValueB)
						end)

						if(status) then 
							next(result)
						else 
							err(result)
						end 
					end 
				else 
					cleanupA()
				end
			end,
			err, 
			function ()
				endA = true 
				if(endB) then 
					complete()
				end
			end 
		)

		cleanupB = subscribe(emitter,
			function (x)
				if(not closed()) then 
					lastValueB = x 
					emissionReadyB = true 
				else 
					cleanupB()
				end
			end,
			err, 
			function ()
				endB = true 
				if(endA) then 
					complete()
				end
			end 
		)
	end)
end