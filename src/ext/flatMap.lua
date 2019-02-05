local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"
--[[
	flatMap

	Transforms every emission into an Observable and then 
	sequences those observables into a single Observable flows
]]
local function defaultFlatMapMutator(x)
	return x
end 
local function flatMap(observable, mutator)
	mutator = type(mutator) == "function" and mutator or defaultFlatMapMutator
	return new(_, function (next, err, complete, closed)
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					local status, result = pcall(function ()
						return mutator(x)
					end)
	
					if(status) then 
						if(isObservable(result)) then
							local lastSubscription 
							
							lastSubscription = subscribe(result,
								function (v)
									if(not closed()) then 
										next(v)
									else 
										lastSubscription()
									end
								end,
								err
							)
						else 
							next(result)
						end 
					else 
						err(result)
					end
				else 
					cleanup()
				end
			end,
			err,
			complete
		)
	end)
end 