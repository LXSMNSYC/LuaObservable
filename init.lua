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
local M = require "LuaObservable.src.M"

local Observable = setmetatable({}, M)

M.__call = require "LuaObservable.src.new"
M.__index = {
	is = require "LuaObservable.src.is",
	subscribe = require "LuaObservable.src.subscribe",
}

local loaded = false

Observable.loadExtensions = function ()
	if(not loaded) then 
		local status, err = pcall( function ()
			local extPath = "LuaObservable.src.ext."
			local function load(moduleName)
				return require(extPath..moduleName)
			end
			--[[
				Creating Observables
			]]
			Observable.from = load("from")
			Observable.of = load("of")
			Observable.empty = load("empty")
			Observable.never = load("never")
			Observable.throw = load("throw")
			Observable.just = load("just")
			Observable.range = load("range")
			Observable.doRepeat = load("doRepeat")
			
			Observable.zip = load("zip")
			Observable.staticForkJoin = load("staticForkJoin")
			
			Observable.amb = load("amb")
			
			local index = M.__index 
			--[[
				Creating Observables
			]]
			index.doWhile = load("doWhile")
			--[[
				Transforming Observables
			]]
			index.buffer = load("buffer")
			index.concatMap = load("concatMap")
			index.flatMap = load("flatMap")
			index.flatMapLatest = load("flatMapLatest")
			index.flatMapObserver = load("flatMapObserver")
			index.map = load("map")
			index.pluck = load("pluck")
			index.scan = load("scan")
			--[[
				Filtering Observables
			]]
			index.distinct = load("distinct")
			index.distinctUntilChanged = load("distinctUntilChanged")
			index.elementAt = load("elementAt")
			index.filter = load("filter")
			index.first = load("first")
			index.single = load("single")
			index.find = load("find")
			index.ignore = load("ignore")
			index.last = load("last")
			index.skip = load("skip")
			index.skipLast = load("skipLast")
			index.skipUntil = load("skipUntil")
			index.skipWhile = load("skipWhile")
			index.take = load("take")
			index.takeLast = load("takeLast")
			index.takeLastBuffer = load("takeLastBuffer")
			index.takeUntil = load("takeUntil")
			index.takeWhile = load("takeWhile")
			--[[
				Combining Observables
			]]
			index.concat = load("concat")
			index.combineLatest = load("combineLatest")
			index.withLatestFrom = load("withLatestFrom")
			index.merge = load("merge")
			index.startWith = load("startWith")
			index.forkJoin = load("forkJoin")
			--[[
				Error handling
			]]
			index.catch = load("catch")
			index.onErrorResumeNext = load("onErrorResumeNext")
			--[[
				Utility
			]]
			index.tap = load("tap")
			index.tapOnNext = load("tapOnNext")
			index.tapOnError = load("tapOnError")
			index.tapOnComplete = load("tapOnComplete")
			index.finally = load("finally")
			--[[
				Conditional and Boolean
			]]
			index.all = load("all")
			index.sorted = load("sorted")
			index.contains = load("contains")
			index.indexOf = load("indexOf")
			index.findIndex = load("findIndex")
			index.isEmpty = load("isEmpty")
			index.defaultIfEmpty = load("defaultIfEmpty")
			--[[
				Aggregates
			]]
			index.average = load("average")
			index.count = load("count")
			index.max = load("max")
			index.min = load("min")
			index.sum = load("sum")
			index.reduce = load("reduce")
			--[[
				Infinite
			]]
			index.linear = load("linear")
			index.exponential = load("exponential")
			index.sieve = load("sieve")
			index.fibonacci = load("fibonacci")
			index.generator = load("generator")
		end)
		
		if(status) then 
			loaded = true 
		else 
			error(err)
		end
	end 
	
	
end

return Observable


