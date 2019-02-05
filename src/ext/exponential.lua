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
local subscribe = require "LuaObservable.src.subscribe"
--[[
	Exponential
	
	An Infinite Observable
	
	Exponential starts with a value and emits the value, after which the next emissions multiplies
	by step, infinitely.
	
	Subscribing to this Infinite Observable must be handled correctly. Cleanup must be done
	to the subscription if it is unnecessary to listen to the Observable any further.
]]
return function (start, step)
	assert(type(start) == "number", "TypeError: start must be a number. (start: "..type(start)..")")
	
	step = type(step) == "number" and step or 0
	
	return new(_, function (next, err, complete, closed)
		local value = start 
		
		while (1) do 
			next(value)
			if(closed()) then 
				return 
			end 
			value = value * step
		end 
	end)
end