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
	buffer

	Emits the previous sequences of emissions by buffers given that the
	current emission returns true if passed into the boundary criteria
]]
return function (observable, boundary)
	assert(type(boundary) == "function", "TypeError: boundary is not a function (boundary: "..type(boundary)..")")
	return new(_, function (next, err, complete, closed)
		--[[
			Accumulator buffer 
			
			contains all accumulated values
			emitted if boundary is met
		]]
		local acc = {}
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					local status, result = pcall(function ()
						return boundary(x)
					end)
	
					if(status) then 
						--[[
							Insert to buffer
						]]
						acc[#acc + 1] = x
						
						--[[
							Check if boundary is met
						]]
						if(result) then 
							--[[
								Emit the buffer then reset
							]]
							next(acc)
							acc = {}
						end 
					else 
						err(result)
					end 
				else 
					cleanup()
				end
			end,
			err,
			function ()
				--[[
					Emit the remaining buffer
				]]
				next(acc)

				complete()
			end
		)
	end)
end 