local new = require "LuaObservable.src.new"
local subscribe = require "LuaObservable.src.subscribe"

return function (observable)
	return new(_, function (next, err, complete, closed)
		local cleanup 
		
		cleanup = subscribe(observable,
			function ()
				if(closed()) then 
					cleanup()
				end
			end,
			err,
			complete
		)
	end)
end