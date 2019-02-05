local from = require("LuaObservable.src.ext.from")
--[[
	Of

	Converts the sequence of arguments into an Observable
]]
return function (...)
	--[[
		Of method is quite simple, it just a variant 
		of the 'From' method
	]]
	return from({...})
end