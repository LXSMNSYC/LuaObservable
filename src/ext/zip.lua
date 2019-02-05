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
	zip 
	
	Emits a table of new emissions from passed Observables.
	The last argument can be a combinator function which combines all the emissions.
]]

return function (...)
	local observables = {...}
	local count = #observables
	local combinator = observables[count]

	if(type(combinator) == "function") then 
		count = count - 1
	else 
		combinator = defaultCombinator
	end 

	for i = 1, count do 
		local obs = observables[i]
		
		assert(isObservable(obs), "TypeError: Argument #"..i.." is not an Observable.")
	end 

	return new(_, function (next, err, complete, closed)
		local lastValue = {}
		local flags = {}
		local ready = count

		for i = 1, count do 
			local cleanup 
			
			cleanup = subscribe(observables[i],
				function (x)
					if(not closed()) then 
						lastValue[i] = x 
						if(ready == 0) then 
							local status, result = pcall(function ()
								return combinator(unpack(lastValue))
							end)

							if(status) then 
								next(result)
								ready = count
								flags = {}
							else 
								err(result)
							end 
						elseif(not flags[i]) then
							ready = ready - 1
							flags[i] = true
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