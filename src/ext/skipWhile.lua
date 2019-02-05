local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"

local function defaultFilter()
	return true 
end

return function (observable, criteria)
	criteria = isFunction(criteria) and criteria or defaultFilter
	return new(_, function (next, err, complete, closed)
		local beginEmission = false
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
						if(not (result or beginEmission)) then 
							beginEmission = true
						end 

						if(beginEmission) then 
							next(x)
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