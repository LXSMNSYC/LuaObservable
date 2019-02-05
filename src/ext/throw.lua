local new = require "LuaObservable.src.new"
--[[
	Throw 

	Returns an Observable that throws an error
]]
return function (throwable)
	return new(_, function (next, err, complete)
		err(throwable)
	end)
end 