local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable, amount)
	assert(type(amount) == "number", "TypeError: amount is not a number. (amount: "..type(amount)..")")
	assert(amount > 0, "TypeError: amount must be a non-zero positive number. ")
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
					local acc = {}
					local c = 0
					for i = seq - amount + 1, seq do 
						c = c + 1
						acc[c] = emissions[i]
					end 
					next(acc)
				end
				complete()
			end
		)
	end)
end