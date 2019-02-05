local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable)
	return new(_, function (next, err, complete, closed)
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					next(false)
					complete()
				else 
					cleanup()
				end
			end,
			err,
			function ()
				next(true)
				complete()
			end 
		)
	end)
end 