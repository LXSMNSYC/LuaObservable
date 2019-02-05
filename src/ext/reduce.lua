local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"

local function defaultReductor(acc, x)
	return x
end 

return function (observable, reductor)
	reductor = type(reductor) == "function" and reductor or defaultReductor
	return new(_, function (next, err, complete, closed)
		local acc
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					local status, result = pcall(function ()
						return reductor(acc or 0, x)
					end)

					if(status) then 
						acc = result 
					else 
						err(result)
					end
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