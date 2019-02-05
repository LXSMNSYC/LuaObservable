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
	amb
	
	Only emit values from the first Observable that notifies.
]]

return function (...)
	local observables = {...}
	
	for i = 1, #observables do 
		local obs = observables[i]
		
		assert(isObservable(obs), "TypeError: Argument #"..i.." is not an Observable.")
	end 

	return new(_, function (next, err, complete, closed)
		local first 
		for k, observable in ipairs(observables) do 
			local cleanup 
			
			cleanup = subscribe(observable,
				function (...)
					if(not closed()) then 
						if(not first) then 
							first = observable
						end 

						if(observable == first) then 
							next(...)
						end   
					else 
						cleanup()
					end  
				end,
				err,
				complete
			)
		end 
	end)
end 