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

local function defaultSortingComparator(a, b)
	return b - a
end

--[[
	sorted
	
	emits true on completion if the sequence of emissions are sorted by value
	emits false on next if sorting fails.
]]

return function (observable, comparator)
	comparator = type(comparator) == "function" and comparator or defaultSortingComparator
	return new(_, function (next, err, complete, closed)
		local prev
		
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					if(prev) then 
						local status, result = pcall(function ()
							return comparator(prev, x)
						end)

						if(status) then 
							if(result < 0) then 
								next(false)
								complete()
							end 
						else 
							err(result)
						end
					end 
					prev = x
				else 
					cleanup()
				end
			end,
			err,
			function ()
				next(true)
				complete()
			end
		)
	end)
end