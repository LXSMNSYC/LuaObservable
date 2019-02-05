local M = require "LuaObservable.src.M"
return function (x)
	return type(x) == "table" and getmetatable(x) == M
end 