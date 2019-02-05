local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable)
	return new(_, function (next, err, complete, closed)
		local acc = 0
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					acc = acc + x 
				else 
					cleanup()
				end
			end,
			err,
			function ()
				next(acc)
				complete()
			end
		)
	end)
	
end 