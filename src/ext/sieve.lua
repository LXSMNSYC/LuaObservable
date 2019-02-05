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

local filter = require "LuaObservable.src.ext.filter"
local elementAt = require "LuaObservable.src.ext.elementAt"

local BASE_LEVEL = 128
--[[
	Sieve
	
	An Infinite Observable
	
	Sieve or Sieve of Eratosthenes emits the prime numbers.
	The primality of a number relies upon the level passed to the sieve.
	Level indicates the nth-prime based upon the (n - 1)th cycle of the sieve
	The prime at that level will be used a the base factor of the whole sequence filter.
	
	Subscribing to this Infinite Observable must be handled correctly. Cleanup must be done
	to the subscription if it is unnecessary to listen to the Observable any further.
]]
return function (level)
	local sieve = new(_, function (next, err, complete, closed)
		local seq = 0
		while(1) do
			seq = seq + 1
			next(seq)
			if(closed()) then 
				return 
			end 
		end
	end)
	
	level = (type(level) == "number" and level or BASE_LEVEL) + 1
	
	for i = 2, level do 
		local temp = 0
		
		subscribe(elementAt(sieve, i),
			function (value)
				temp = value
			end
		)
		
		sieve = filter(sieve, function (x)
			return (x == temp) or (x % temp ~= 0)
		end)
	end 
	
	return sieve
end