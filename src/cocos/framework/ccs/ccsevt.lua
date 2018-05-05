local Event = require("cocos.framework.components.event")
local M = Event.new()
M:init_()
local MM={}

MM.addEventListenerByTarget 		= function(target,...) 
										local hd = M.addEventListener(M, ...) 
										target.__CCSEVTHDS = target.__CCSEVTHDS or {}
										table.insert(target.__CCSEVTHDS,hd)
										return hd
								  end
MM.removeEventListenerByTarget 	= function(target) 
										if(target.__CCSEVTHDS) then
											for _,hd in pairs(target.__CCSEVTHDS) do
												M.removeEventListener(M,hd)
											end	
											target.__CCSEVTHDS = {}										
										end
								  end

MM.addEventListener 		= function(...) return M.addEventListener(M, ...) end
MM.dispatchEvent 			= function(...) M.dispatchEvent(M, ...) end
MM.removeEventListener 	= function(...) M.removeEventListener(M, ...) end
MM.removeEventListenersByTag = function(...) M.removeEventListenersByTag(M, ...) end
MM.removeEventListenersByEvent = function(...) M.removeEventListenersByEvent(M, ...) end
MM.removeAllEventListenersForEvent = function(...) M.removeEventListenersByEvent(M, ...) end
MM.removeAllEventListeners = function(...) M.removeAllEventListeners(M, ...) end
MM.hasEventListener = function(...) M.hasEventListener(M, ...) end
MM.dumpAllEventListeners = function(...) M.dumpAllEventListeners(M, ...) end

MM.genevt = function(ename,type,data,node)
	local types=
	{
		Touch = 'touch',
		Click = 'click',
		Event = 'event',
		input = 'input'
	}
	local evt=
	{
		name = ename,
		type = types[type] or "",
		data = data,
		node = node,
	}
	return evt
end

-- cc.exports.ccsevt = MM
ccsevt = MM