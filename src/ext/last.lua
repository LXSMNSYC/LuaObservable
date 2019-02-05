local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

local function defaultFilter()
	return true 
end

return function (observable, predicate, last)
	predicate = type(predicate) == "function" or defaultFilter
	return new(_, function (next, err, complete, closed)
		local seq = 0
		
		local cleanup
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					seq = seq + 1 

					local status, result = pcall(function ()
						return predicate(x, seq, observable)
					end)

					if(status) then 
						if(result) then 
							last = x
						end
					else 
						err(result)
					end 
				else 
					cleanup()
				end
			end,
			err,
			function ()
				if(seq == 0 or not last) then 
					err("Sequence contains no elements.")
				else 
					next(last)
					complete()
				end 
			end
		)
	end)
end