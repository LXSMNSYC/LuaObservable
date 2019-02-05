local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"
--[[
	flatMapLatest

	Like flatMap, except that if a new value is emitted from the observable,
	enters the mutator and returns an Observable, it completes the previously
	emitted Observable.
]]
local function defaultFlatMapMutator(x)
	return x
end 
return function (observable, mutator)
	mutator = type(mutator) == "function" and mutator or defaultFlatMapMutator
	return new(_, function (next, err, complete, closed)
		local lastSubscription
		
		local cleanup
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					local status, result = pcall(function ()
						return mutator(x)
					end)
	
					if(status) then 
						if(isObservable(result)) then 
							if(lastSubscription) then 
								lastSubscription()
							end 
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