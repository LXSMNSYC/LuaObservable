local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"
--[[
	
]]
local function defaultFlatMapMutator(x)
	return x
end 

return function (observable, onNext, onError, onComplete)
	onNext = type(onNext) == "function" and onNext or defaultFlatMapMutator
	onError = type(onError) == "function" and onError or defaultFlatMapMutator
	onComplete = type(onComplete) == "function" and onComplete or defaultFlatMapMutator

	return new(_, function (next, err, complete, closed)
		local cleanup 
		
		local function globalHandler(handler, x)
			if(not closed()) then 
				local status, result = pcall(function ()
					return handler(x)
				end)

				if(status) then 
					if(isObservable(result)) then 
						local lastSubscription
						
						lastSubscription = subscribe(observable,
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
		end
		
		cleanup = subscribe(observable,
			function (x)
				globalHandler(onNext, x)
			end,
			function (x)
				globalHandler(onError, x)
			end,
			function ()
				globalHandler(onComplete)
			end
		)
	end)
end 