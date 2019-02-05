local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

local function defaultFilter()
	return true 
end

return function (observable, criteria)
	criteria = type(criteria) == "function" and criteria or defaultFilter
	return new(_, function (next, err, complete, closed)
		local endEmission = false 
		local seq = 0
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					seq = seq + 1
					if(endEmission) then 
						complete()
					else 
						local status, result = pcall(function ()
							return criteria(x, seq, observable)
						end)

						if(status) then
							if(result) then 
								next(x)
							else 
								endEmission = true 
								complete()
							end 
						else 
							err(result)
						end 
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