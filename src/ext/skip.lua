local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable, amount)
	assert(type(amount) == "number", "TypeError: index is not a number. (index: "..type(amount)..")")
	assert(amount > 0, "TypeError: index must be a number greater than 0. (index: "..amount..")")
	return new(_, function (next, err, complete, closed)
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					if(amount == 0) then 
						next(x)
					else
						amount = amount - 1
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