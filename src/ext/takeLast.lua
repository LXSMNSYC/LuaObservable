local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable, amount)
	assert(type(amount) == "number", "TypeError: index is not a number. (amount: "..type(amount)..")")
	assert(amount > 0, "TypeError: index must be a number greater than 0. (amount: "..amount..")")
	return new(_, function (next, err, complete, closed)
		local emissions = {}
		local seq = 0
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then
					seq = seq + 1
					emissions[seq] = x  
				else 
					cleanup()
				end 
			end,
			err,
			function ()
				if(seq >= amount) then 
					for i = seq - amount + 1, seq do 
						next(emissions[i])
					end 
				end
				complete()
			end
		)
	end)
end