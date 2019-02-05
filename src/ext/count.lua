local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable)
	return new(_, function (next, err, complete, closed)
		local seq = 0
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					seq = seq + 1
				else 
					cleanup()
				end
			end,
			err,
			function ()
				next(seq)
				complete()
			end
		)
	end)
end