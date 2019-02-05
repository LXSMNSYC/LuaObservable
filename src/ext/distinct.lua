local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

local function defaultComparator(x)
	return x 
end

return function (observable, comparator)
		comparator = type(comparator) == "function" and comparator or defaultComparator
		return new(_, function (next, err, complete, closed)
			--[[
				Monitors the sequence uniqueness
			]]
			local flag = {}

			
			local cleanup
			cleanup = subscribe(observable,
				function (x)
					if(not closed()) then 
						local index = comparator(x)
						--[[
							Check if there is already an emitted value 
						]]
						if(not flag[index]) then 
							--[[
								If not, set its record
							]]
							flag[index] = true 

							next(x)
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