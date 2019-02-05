local new = require "LuaObservable.src.new"
local isObservable = require "LuaObservable.src.is"
local subscribe = require "LuaObservable.src.subscribe"
--[[
	
]]

local function defaultConcatMapMutator(x)
	return x
end 
return function (observable, mutator)
	mutator = type(mutator) == "function" and mutator or defaultConcatMapMutator

	return new(_, function (next, err, complete, closed)
		--[[
			Enqueues emitted observables 
		]]
		local queue = {}
		--[[
			Signals that the last emission was the last Observable to 
			emit the completion signal
		]]
		local lastEmission = false

		--[[
			Enqueue 
		]]
		local function enqueue(x)
			if(not queue.first) then 
				queue.first = x 
			else 
				queue[queue.last] = x 
			end 
			queue.last = x 
			queue[x] = nil 
		end 
		--[[
			Dequeue
		]]
		local function dequeue()
			local first = queue.first
			queue.first = queue[first]
			return first
		end 
		--[[
			Prepares the next Observable 
		]]
		local function prepareSubscription(obs)
			--[[
				Check if there are no Observables emitting
				and that the next Observable is ready for emission
			]]
			if(ready) then 
				ready = false
				
				local cleanup
				
				cleanup = subscribe(obs,
					function (x)
						if(not closed()) then 
							next(x)
						else 
							cleanup()
						end
					end,
					err,
					function () 
						if(not closed()) then 
							if(queue.first) then 
								--[[
									If there is an Observable inline,
									prepare it 
								]]
								prepareSubscription(dequeue())
							elseif(lastEmission) then 
								--[[
									This completed Observable is the last 
									emitted Observable, signal completion 
								]]
								complete()
							else
								--[[
									The Observable is ready to emit from 
									the future Observable 
								]]
								ready = true
							end 
						end
					end 
				)
			else 
				--[[
					There is a working emitted Observable,
					enqueue the Observable until the working 
					Observable has completed.
				]]
				enqueue(obs)
			end
		end


		local cleanup 
		
		cleanup = subscribe(observable,
			function (x)
				if(not closed()) then 
					local status, result = pcall(function ()
						return mutator(x)
					end)

					if(status) then 
						--[[
							Check if the mutator returned an Observable 
						]]
						if(isObservable(result)) then 
							--[[
								Prepare the Observable 
							]]
							prepareSubscription(result)
						else 
							--[[
								Otherwise, emit it.
							]]
							next(result, seq)
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
				--[[
					Signal that the previous emission was the last emission.
				]]
				lastEmission = true
			end
		)
	end)

end