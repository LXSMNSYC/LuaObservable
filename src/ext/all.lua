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

local function defaultFilter()
	return true
end

--[[
	all
	
	emits true if all emitted values passed the criteria (on completion)
	emits false if one of the emitted values failed (on next)
]]

return function (observable, criteria)
	criteria = type(criteria) == "function" and criteria or defaultFilter

	return new(_, function (next, error, complete, closed)
		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					local status, result = pcall(function ()
						return criteria(x)
					end)

					if(status) then 
						if(not result) then 
							next(false)
							complete()
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
				next(true)
				complete()
			end 
		)
	end)
end 