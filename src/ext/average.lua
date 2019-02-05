local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable)
	return new(_, function (next, err, complete, closed)
		local acc = 0
		local seq = 0
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					acc = acc + x 
					seq = seq + 1
				else 
					cleanup()
				end
			end,
			err,
			function ()
				if(seq == 0) then 
					next(0)
				else 
					next(acc/seq)
				end
				complete()
			end
		)
	end)
end 