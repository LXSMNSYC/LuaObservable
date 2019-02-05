local M = require "LuaObservable.src.M"
return function (_, subscriber)
	local observable = {}

	observable.subscriber = subscriber

	return setmetatable(observable, M)
end 