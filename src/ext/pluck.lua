local map = require "LuaObservable.src.ext.map"

return function (observable, key)
	assert(key ~= nil, "TypeError: key is nil")
	return map(observable, function (x)
		return x[key]
	end)
end 