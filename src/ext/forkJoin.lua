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

local function defaultCombinator(...)
	return {...}
end

--[[
	forkJoin
	
	combines the last values from the source Observable and the passed Observable
	Will only emit when both Observables are completed.
]]

return function (observable, emitter, combinator)
	assert(isObservable(emitter), "TypeError: emitter must be an Observable.")
	combinator = type(combinator) == "function" and combinator or defaultCombinator
	return new(_, function (next, err, complete, closed)
		local lastValueA = nil
		local lastValueB = nil

		local readyA = false
		local readyB = false 

		local cleanupA 
		local cleanupB 
		
		cleanupA = subscribe(observable,
			function (x)
				if(not closed()) then 
					lastValueA = x
					readyA = true 
				else 
					cleanupA()
				end
			end,
			err, 
			function ()
				if(readyB) then 
					local status, result = pcall(function ()
						return combinator(lastValueA, lastValueB)
					end)
					
					if(status) then 
						next(result)
						complete()
					end 
				end 
			end 
		)

		cleanupB = subscribe(emitter,
			function (x)
				if(not closed()) then 
					lastValueB = x 
					readyB = true 
				else 
					cleanupB()
				end 
			end,
			err, 
			function ()
				if(readyA) then 
					local status, result = pcall(function ()
						return combinator(lastValueA, lastValueB)
					end)
					
					if(status) then 
						next(result)
						complete()
					end 
				end 
			end
		)
	end)
end 