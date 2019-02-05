local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable, index)
	assert(type(index) == "number", "TypeError: index is not a number. (index: "..type(index)..")")
	assert(index > 0, "TypeError: index must be a number greater than 0. (index: "..index..")")
	return new(_, function (next, err, complete, closed)
		local seq = 0
		
		local cleanup 
		cleanup = subscribe(observable, 
			function (x)
				if(not closed()) then 
					seq = seq + 1
					if(index == seq) then 
						next(x)
						complete()
					end 
				else 
					cleanup()
				end
			end,
			err,
			function ()
				if(seq < index) then 
					err("Argument out of range")
				else 
					complete()
				end 
			end 
		)
	end)
end