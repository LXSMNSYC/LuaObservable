local new = require "LuaObservable.src.new"

--[[
	Never

	Returns an Observable that neither emits, throws errors or completes
]]
return function ()
	return new(_, function () end)
end 