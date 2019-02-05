--[[
    Lua Cold Observables
	
    MIT License
    Copyright (c) 2019 Alexis Munsayac
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"

--[[
	(static) forkJoin
	
	Emits all last emitted values from all completed Observables as an array.
	Only emits once all Observables passed have completed.
]]

return function (...)
	local observables = {...}
	local count = #observables

	for i = 1, count do 
		local obs = observables[i]
		
		assert(isObservable(obs), "TypeError: Argument #"..i.." is not an Observable.")
	end 
	
	return new(_, function (next, err, complete, closed)
		local values = {}
		local ready = count
		for k, obs in ipairs(observables) do 
			local cleanup 
			
			cleanup = subscribe(obs,
				function (x)
					if(not closed()) then 
						values[k] = x 
					else 
						cleanup()
					end
				end,
				err,
				function ()
					ready = ready - 1
					if(ready == 0) then 
						next(values)
						complete()
					end 
				end 
			)
		end 
	end)
end