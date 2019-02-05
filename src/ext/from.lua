local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"

local empty = require("LuaObservable.src.ext.empty")
--[[
	From 

	Converts any table or Observables into an Observable
]]
return function (object)
	--[[
		Check if the object is an observable
	]]
	if(isObservable(object)) then 
		--[[
			Create a new Observable where the observer 
			is subscribed to the object 
			
		]]
		return new(_, function (next, err, complete, closed)
			--[[
				In case that the Observable is closed,
				we need to cleanup the subscription
			]]
			local cleanup
			--[[
				Get the subscription 
			]]
			cleanup = subscribe(object, function (x)
				--[[
					Check if the Observable is closed 
				]]
				if(not closed()) then 
					--[[
						Emit value if not closed 
					]]
					next(x)
				else 
					--[[
						Do a cleanup
						
						This is necessary specially if the source Observable 
						emits eternally.
						
						If it is an eternal Observable and the returned 
						Observable is already closed, we need to unsubscribe
						because the emissions are of no longer use.
					]]
					cleanup()
				end
			end, err, complete)
		end)
	elseif(type(object) == "table") then 
		--[[
			Create an Observable that turns the table's contents 
			into a sequence of emissions
		]]
		return new(_, function (next, err, complete, closed)
			for k, v in ipairs(object) do 
				next(v)
				if(closed()) then 
					return 
				end
			end 
			complete()
		end)
	end 
	
	return empty()
end 