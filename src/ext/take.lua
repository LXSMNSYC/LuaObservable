local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable, amount)
	assert(type(amount) == "number", "TypeError: index is not a number. (amount: "..type(amount)..")")
	assert(amount > 0, "TypeError: index must be a number greater than 0. (amount: "..amount..")")
	return new(_, function (next, err, complete, closed)
		local counter = 0
		
		local cleanup 

		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					counter = counter + 1
					if(counter <= amount) then 
						next(x)
					else 
						complete()
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