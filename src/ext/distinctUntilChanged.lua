local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

local function defaultComparator(x)
	return x 
end

return function (observable, comparator)
	comparator = isFunction(comparator) and comparator or defaultComparator
	return new(_, function (next, err, complete, closed)
		local previous = nil
		local first = true

		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then
					local index = comparator(x)
					if(previous ~= index and not first) then 
						next(x)
					elseif(first) then
						next(x)
						first = false
					end 
					previous = index 
				else 
					cleanup()
				end
			end,
			err,
			complete
		)
	end)
end