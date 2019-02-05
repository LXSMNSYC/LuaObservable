local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable, amount)
	assert(type(amount) == "number", "TypeError: index is not a number. (index: "..type(amount)..")")
	assert(amount > 0, "TypeError: index must be a number greater than 0. (index: "..amount..")")
	return new(_, function (next, err, complete, closed)
		local emissions = {}
		local seq = 0
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					seq = seq + 1
					emissions[seq] = x 

					if(seq > amount) then 
						next(emissions[seq - amount])
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