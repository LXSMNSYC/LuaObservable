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
	Generator
	
	An Infinite Observable
	
	Generates an infinite sequence of emissions through a function 
]]
return function (handler, start, step)
	assert(type(handler) == "function", "TypeError: handler is not a function. (handler: "..type(handler)..")")
	start = type(start) == "number" and start or 0
	step = type(step) == "number" and step or 1
	return new(_, function (next, err, complete, closed)
		local seq = start
		while(1) do
			local status, result = pcall(function ()
				return handler(seq)
			end)
			
			if(status) then 
				next(result)
				if(closed()) then 
					return 
				end 
				seq = seq + step
			else 
				err(result)
				return
			end 
		end
	end)
end