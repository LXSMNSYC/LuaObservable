local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

local function defaultFilter(x)
	return true 
end

return function (observable, criteria)
	criteria = type(criteria) == "function" and criteria or defaultFilter
	return new(_, function (next, err, complete, closed)
		local seq = 0
		
		local cleanup 
		
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					seq = seq + 1
					local status, result = pcall(function ()
						return criteria(x, seq, observable)
					end)

					if(status) then 
						if(result) then 
							next(x)
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