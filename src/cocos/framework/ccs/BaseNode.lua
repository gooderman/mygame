
require("cocos.framework.ccs.ccsload")
require("cocos.framework.ccs.ccsanim")
require("cocos.framework.ccs.ccsevt")

local BaseNode  = class("BaseNode", cc.Node)

function BaseNode:ctor(...)
	self:enableNodeEvents()

	self.touchEnable = false
	self.touchListener = nil
end

function BaseNode:onEnter()
end

function BaseNode:onExit()
end

function BaseNode:onCleanup()
	self:delccsevt()
end

function BaseNode:setSwallowsTouches(flag)
	if(self.touchListener) then
		self.touchListener:setSwallowTouches(flag)
	end	
end
function BaseNode:setTouchEnabled(enable)
	if(self.touchEnable~=enable) then
		self.touchEnable = enable
		if(enable) then
			if(self.touchListener) then
				return
			end
			local listener = cc.EventListenerTouchOneByOne:create()
			listener:setSwallowTouches(true)
			self.touchListener = listener
			local function touchbegan( ... ) return self:onTouchEvt(1,...) end
			local function touchmoved( ... ) return self:onTouchEvt(2,...) end
			local function touchcancelled( ... ) return self:onTouchEvt(3,...) end	
			local function touchended( ... ) return self:onTouchEvt(4,...) end
			listener:registerScriptHandler(touchbegan, cc.Handler.EVENT_TOUCH_BEGAN)
			listener:registerScriptHandler(touchmoved, cc.Handler.EVENT_TOUCH_MOVED)
			listener:registerScriptHandler(touchcancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
			listener:registerScriptHandler(touchended, cc.Handler.EVENT_TOUCH_ENDED)
			self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
		else
			if(self.touchListener) then
				self::getEventDispatcher():removeEventListener(self.touchListener)
			end
			self.touchListener = nil
		end
	end
end	

function BaseNode:onTouchEvt(tp, touch, evt)
	-- local location = touch:getLocation()
	-- local pos  = tt.node:convertToNodeSpace(location)
	return false
end

function BaseNode:loadccs(file, isevt,respath)
	return ccsload.load(file, isevt and tostring(self),respath)
end
function BaseNode:loadccs_tb(tb, isevt,respath)
	return ccsload.load_tb(tb, isevt and tostring(self),respath)
end

function BaseNode:loadccs_child(file, isevt, respath,child)
	return ccsload.load_child(file, isevt and tostring(self), respath,child)
end
function BaseNode:loadccs_child_tb(tb, isevt, respath,child)
	return ccsload.load_child_tb(tb, isevt and tostring(self), respath,child)
end

function BaseNode:addccsevt(listener)
	ccsevt.addEventListenerByTarget(self, tostring(self), listener)
end

function BaseNode:delccsevt()
	-- print("BaseNode:delccsevt",self)
	ccsevt.removeEventListenerByTarget(self)
end

function BaseNode:initUi()
end

return BaseNode
