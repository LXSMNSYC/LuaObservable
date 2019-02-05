local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"
--[[
	doWhile

	Returns an Observable that doesn't stop until the passed handler returns false.
	If the Observable completes without the handler returning false, the Observable
	then re-emits the sequence of emissions
]]
return function (observable, handler)
	assert(type(handler) == "function", "TypeError: handler is not a function (handler: "..type(handler))
	return new(_, function (next, err, complete, closed)
		local seq = 0

		--[[
			A function that handles the subscription for the observable
			
			In case that the condition is not yet met, the Observable 
			needs to resubscribe to produce the same sequence of emissions
		]]
		local function resubscribe()
			local cleanup 
			cleanup = subscribe(observable,
				function (x)
					if(not closed()) then 
						local status, result = pcall(function ()
							return handler(x)
						end)
	
						if(status) then 
							if(result) then 
								seq = seq + 1
								next(x, seq, observable)
							else 
								complete()
							end 
						else 
							err(result)
						end
					else 
						cleanup()
					end 
				end,
				err,
				resubscribe
			)
		end
		resubscribe()
	end)
end