local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable, def)
	return new(_, function (next, err, complete, closed)
		local empty = true 
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					next(x)
					empty = false
				else 
					cleanup()
				end
			end,
			err,
			function ()
				if(empty) then 
					next(def)
				end
				complete()
			end 
		)
	end)
end