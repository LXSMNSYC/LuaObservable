local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"
--[[
	
]]
local function defaultScanner(acc, x)
	return x 
end 

return function (observable, handler, seed)
	handler = type(handler) == "function" and handler or defaultScanner
	return new(_, function (next, err, complete, closed)
		local acc = seed
		
		local cleanup 
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					local status, result = pcall(function ()
						return handler(acc, x)
					end)

					if(status) then 
						acc = result 

						next(acc)
					else 
						err(result)
					end 
				else 
					cleanup()
				end
			end,
			err,
			complete
		)
	end)
end 