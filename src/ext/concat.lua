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

return function (observable, ...)
	local observables = {...}
	local count = #observables 
	
	for i = 1, count do 
		assert(isObservable(observables[i]), "TypeError: Argument #"..i.." is not an Observable.")
	end 
	
	observables[0] = observable
	
	return new(_, function (next, err, complete, closed)
		--[[
			Enqueues emitted observables 
		]]
		local queue = {}
		--[[
			Enqueue 
		]]
		local function enqueue(x)
			if(not queue.first) then 
				queue.first = x 
			else 
				queue[queue.last] = x 
			end 
			queue.last = x 
			queue[x] = nil 
		end 
		--[[
			Dequeue
		]]
		local function dequeue()
			local first = queue.first
			queue.first = queue[first]
			return first
		end 
		
		--[[
			Recursive preparation for observable list
		]]
		local function prepareObservable(index)
			local cleanup 
			
			cleanup = subscribe(observables[index],
				function (x)
					if(not closed()) then
						next(x)
					else 
						cleanup()
					end 
				end,
				err,
				function ()
					local nextObservable = observables[index + 1]
					if(isObservable(nextObservable)) then 
						prepareObservable(index + 1)
					else 
						complete()
					end
				end
			)
		end 
		
		prepareObservable(0)
	end)
end