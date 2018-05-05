require("cocos.framework.ccs.ccsanim")
require("cocos.framework.ccs.ccsevt")
local M = {}
local M_EVT_NAME
local M_RES_PATH
local M_RES_INPUT_BG
local __txtcache =  cc.Director:getInstance():getTextureCache()
local __spfcache = cc.SpriteFrameCache:getInstance()
local function __path(p)
	return M_RES_PATH  .. p
end	
local function bind_layout(nd,t)
	local layout = ccui.LayoutComponent:bindLayoutComponent(nd)
	local a
	a = t.PrePosition
	if(a) then
		if(a.X) then
			layout:setPositionPercentX(a.X)
		end
		if(a.Y) then
			layout:setPositionPercentY(a.Y)
		end
	end
	a = t.PreSize
	if(a) then
		if(a.X) then
			layout:setPercentWidth(a.X)
		end
		if(a.Y) then
			layout:setPercentHeight(a.Y)
		end
	end
	a = t.Size
	if(a) then
		layout:setSize({width = a.X, height = a.Y})
	end
	if(t.LeftMargin) then
		layout:setLeftMargin(t.LeftMargin)
	end	
	if(t.RightMargin) then
		layout:setRightMargin(t.RightMargin)
	end
	if(t.TopMargin) then
		layout:setTopMargin(t.TopMargin)
	end
	if(t.BottomMargin) then
		layout:setBottomMargin(t.BottomMargin)
	end
end
local function set_param(nd,t,ignorcolor,ignorescale9)
	if(nd.setLayoutComponentEnabled) then
		nd:setLayoutComponentEnabled(true)
	end
	nd:setName(t.Name)
	nd:setTag(t.Tag)
	if(t.ZOrder and t.ZOrder ~= 0) then
        nd:setLocalZOrder(t.ZOrder)
	end
	-----------for use CCActionTimeline-----------
	if(t.ActionTag) then
		local com = ccs.ComExtensionData:create()
		com:setActionTag(t.ActionTag)
		nd:addComponent(com)
    end
    ----------------------------------------------
	nd:setCascadeColorEnabled(true)
	nd:setCascadeOpacityEnabled(true)
	local a
	a = t.Position
	if(a) then
		nd:setPosition(a.X or 0, a.Y or 0)
	end
	a = t.AnchorPoint
	if(a) then
		nd:setAnchorPoint(a.ScaleX or 0, a.ScaleY or 0)
	end
	a = t.Scale
	if(a and a.ScaleX) then
		nd:setScaleX(a.ScaleX)
	end
	if(a and a.ScaleY) then
		nd:setScaleY(a.ScaleY)
	end
	if(t.Alpha) then
		nd:setOpacity(t.Alpha)
	end

	if(t.RotationSkewX) then
		nd:setRotationSkewX(t.RotationSkewX)
	end
	if(t.RotationSkewY) then	
		nd:setRotationSkewY(t.RotationSkewY)
	end

	if(t.FlipX) then
		nd:setFlippedX(true)
	end
	if(t.FlipY) then
		nd:setFlippedY(true)
	end
	if(t.VisibleForFrame==false) then
		nd:setVisible(false)
	end

    a = t.BlendFunc
    if(a) then
		nd:setBlendFunc({src = a.Src, dst = a.Dst})
	end
	if(not ignorescale9) then
		if(t.Scale9Enable) then
			nd:setScale9Enabled(true)
			nd:setCapInsets({x = t.Scale9OriginX, y = t.Scale9OriginY, width = t.Scale9Width, height = t.Scale9Height})
		end
	end

	if(not ignorcolor) then
		a = t.CColor
		if (a and (a.R or a.G or a.B)) then
			nd:setColor({r = a.R or 255, g = a.G or 255, b = a.B or 255})
		end
	end
end
local function set_background(nd,t)
	local tp = t.ComboBoxIndex
	local a 
	if (tp == 1) then
		-- print("gen_panel",c.r,c.g,c.b,c.a)
		local a = t.SingleColor
		local c
		if (a) then
			c = {r = a.R or 255, g = a.G or 255, b = a.B or 255}
			nd:setBackGroundColorType(1)
			nd:setBackGroundColor(c)
			nd:setBackGroundColorOpacity(t.BackColorAlpha or 255)
		end		
	elseif (tp == 2) then
		local a = t.FirstColor or {}
		local b = t.EndColor or {}

		local v = t.ColorVector or {}
		local ac = {r = a.R or 255, g = a.G or 255, b = a.B or 255}
		local bc = {r = b.R or 255, g = b.G or 255, b = b.B or 255}
		local vp = {v.ScaleX or 0, v.ScaleY or 0}
		nd:setBackGroundColorType(2)
		nd:setBackGroundColor(ac,bc)
		nd:setBackGroundColorVector({x = -0.8191521, y = 0.5735765})
		nd:setBackGroundColorOpacity(t.BackColorAlpha or 255)
	end
	a = t.FileData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:setBackGroundImage(a.Path,1)
		else
			nd:setBackGroundImage(__path(a.Path),0)
		end	
		if(t.Scale9Enable) then
			nd:setBackGroundImageCapInsets({x = t.Scale9OriginX, y = t.Scale9OriginY, width = t.Scale9Width, height = t.Scale9Height})
			nd:setBackGroundImageScale9Enabled(true)
        end
	end
end	
local function gen_sp(t)
	local sp
	local a 
	a = t.FileData
	if(a.Type=='PlistSubImage') then
		sp = cc.Sprite:createWithSpriteFrameName(a.Path)
	else
		sp = cc.Sprite:create(__path(a.Path))
	end
	set_param(sp,t)
	bind_layout(sp,t)
	return sp
end

local function gen_node(t)
	local nd = cc.Node:create()
	set_param(nd,t,true)
	bind_layout(nd,t)
	return nd
end

local function gen_layer(t)
	return gen_node(t)
end

local function gen_btn(t, class)
	local nd = ccui.Button:create()
	local a 
	nd:ignoreContentAdaptWithSize(false)
	a = t.NormalFileData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadTextureNormal(a.Path,1)
		else
			nd:loadTextureNormal(__path(a.Path),0)	
		end
	end
	a = t.PressedFileData
	if(not a) then
		nd:setPressedActionEnabled(true)
		a = t.NormalFileData
	end
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadTexturePressed(a.Path,1)
		else
			nd:loadTexturePressed(__path(a.Path),0)	
		end	
	end
	a = t.DisabledFileData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadTextureDisabled(a.Path,1)
		else
			nd:loadTextureDisabled(__path(a.Path),0)	
		end
	end

	

	set_param(nd,t)

	if(t.FontSize) then
		nd:setTitleFontSize(t.FontSize)
	end
	if(t.ButtonText) then
		nd:setTitleText(t.ButtonText)
	end
	a = t.TextColor
	if (a and (a.R or a.G or a.B)) then
		nd:setTitleColor({r = a.R or 255, g = a.G or 255, b = a.B or 255})
	end

	bind_layout(nd,t)	

	if (M_EVT_NAME and t.CallBackType) then
		local evt_name = M_EVT_NAME
		nd:addClickEventListener(function(...)
			ccsevt.dispatchEvent(ccsevt.genevt(evt_name, t.CallBackType, t.CallBackName, nd))
		end)
	end
	return nd
end

local function gen_checkbox(t)
	local nd = ccui.CheckBox:create()
	nd:ignoreContentAdaptWithSize(false)
	local a
	a = t.NormalBackFileData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadTextureBackGround(a.Path,1)
		else
			nd:loadTextureBackGround(__path(a.Path),0)	
		end
	end
	a = t.PressedBackFileData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadTextureBackGroundSelected(a.Path,1)
		else
			nd:loadTextureBackGroundSelected(__path(a.Path),0)	
		end
	end
	a = t.DisableBackFileData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadTextureBackGroundDisabled(a.Path,1)
		else
			nd:loadTextureBackGroundDisabled(__path(a.Path),0)	
		end
	end
	a = t.NodeNormalFileData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadTextureFrontCross(a.Path,1)
		else
			nd:loadTextureFrontCross(__path(a.Path),0)	
		end
	end
	a = t.NodeDisableFileData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadTextureFrontCrossDisabled(a.Path,1)
		else
			nd:loadTextureFrontCrossDisabled(__path(a.Path),0)	
		end
	end

	nd:setSelected(t.CheckedState and true or false)

	set_param(nd,t)
	bind_layout(nd,t)
		
	if (M_EVT_NAME and t.CallBackType) then
		local evt_name = M_EVT_NAME
		nd:addEventListener(function(sender, eventType)
			local evt = ccsevt.genevt(evt_name, t.CallBackType, t.CallBackName, nd)
	        if eventType == 0 then
	            evt.select = true
	        else
	            evt.select = false
	        end
			ccsevt.dispatchEvent(evt)
    	end)
	end
	return nd
end

local function gen_map(t)
	local nd = cc.Node:create()
	set_param(nd,t)
	bind_layout(nd,t)
	return nd
end

local function gen_imgview(t)
	-- print('gen_imgview')
	local img = ccui.ImageView:create()
	img:ignoreContentAdaptWithSize(false)
	local a
	a = t.FileData

	if(a.Type=='PlistSubImage') then
		img:loadTexture(a.Path,1)
	else
		img:loadTexture(__path(a.Path),0)
	end
	set_param(img,t)
	bind_layout(img,t)
	return img
end
local list_param_map =
{
	Horizontal = 0,
	Vertical = 1,

	Align_Left = 0,
	Align_Right = 1,
	Align_HorizontalCenter = 2,

	Align_Top = 0,
	Align_Bottom = 1,
	Align_VerticalCenter = 2,
}
local function gen_listview(t)
	local nd = ccui.ListView:create()
	set_background(nd,t)
	--scrollview  ScrollDirectionType is number
	-- enum class Direction
 --    {
 --        NONE,
 --        VERTICAL,
 --        HORIZONTAL,
 --        BOTH
 --    };
	if(t.DirectionType=='Vertical') then
		nd:setDirection(1)
		local g = list_param_map[t.HorizontalType] or 0
		nd:setGravity(g)

	else
		nd:setDirection(2)
		local g = list_param_map[t.VerticalType] or 0
		nd:setGravity(g)
	end	
	if(t.ClipAble) then
		nd:setClippingEnabled(true)
	else
		nd:setClippingEnabled(false)	
	end
	if(t.ItemMargin) then
		nd:setItemsMargin(t.ItemMargin)
	end	
	if(t.IsBounceEnabled) then
		nd:setBounceEnabled(true)
	else
		nd:setBounceEnabled(false)
	end
	set_param(nd, t, true,true)
	bind_layout(nd,t)
	return nd,'listview'
end

local function gen_loading(t)
	local nd = ccui.LoadingBar:create()
	local a 
	a = t.ImageFileData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadTexture(a.Path,1)
		else
			nd:loadTexture(__path(a.Path),0)	
		end
	end
	-- must be called after loadTexture, otherwise pecent always 100
	nd:ignoreContentAdaptWithSize(false)

	a = t.ProgressType
	if(a and a=="Right_To_Left") then
		nd:setDirection(1)
	else
		nd:setDirection(0)	
	end
	a = t.ProgressInfo
	if(a) then
		-- print('gen_loading percent',a)
		nd:setPercent(a)
	end
	set_param(nd, t)
	bind_layout(nd,t)
	return nd
end

local function gen_slider(t)
	local nd = ccui.Slider:create()
	nd:ignoreContentAdaptWithSize(false)
	local a 
	a =  t.BackGroundData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadBarTexture(a.Path,1)
		else
			nd:loadBarTexture(__path(a.Path),0)	
		end
	end
	a =  t.ProgressBarData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadProgressBarTexture(a.Path,1)
		else
			nd:loadProgressBarTexture(__path(a.Path),0)	
		end
	end	
	a =  t.BallNormalData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadSlidBallTextureNormal(a.Path,1)
		else
			nd:loadSlidBallTextureNormal(__path(a.Path),0)	
		end
	end		
	a =  t.BallPressedData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadSlidBallTexturePressed(a.Path,1)
		else
			nd:loadSlidBallTexturePressed(__path(a.Path),0)	
		end
	end		
	a =  t.BallDisabledData
	if(a) then
		if(a.Type=='PlistSubImage') then
			nd:loadSlidBallTextureDisabled(a.Path,1)
		else
			nd:loadSlidBallTextureDisabled(__path(a.Path),0)	
		end
	end
	a = t.PercentInfo
	if(a) then
		-- print('gen_slider percent',a)
		nd:setPercent(a)
		nd:setMaxPercent(100)
	end
	a = t.DisplayState
	if(a==false) then
		nd:setBright(false)
		nd:setEnabled(false)
	end
	set_param(nd, t)
	bind_layout(nd,t)
	return nd
end
local function gen_pageview(t)
	local nd = ccui.PageView:create()
	set_background(nd,t)
	if(t.ClipAble) then
		nd:setClippingEnabled(true)
	else
		nd:setClippingEnabled(false)	
	end	
	if(t.IsBounceEnabled) then
		nd:setBounceEnabled(true)
	else
		nd:setBounceEnabled(false)
	end	
	set_param(nd, t, true,true)
	bind_layout(nd,t)
	return nd,'pageview'
end

local function gen_panel(t)
	local nd = ccui.Layout:create()
	set_background(nd,t)
	if(t.ClipAble) then
		nd:setClippingEnabled(true)
	else
		nd:setClippingEnabled(false)	
	end
	set_param(nd, t, true,true)
	bind_layout(nd,t)
	return nd
end

local function gen_particle(t)
	local a = t.FileData
	if (a and a.Path) then
		local nd = cc.ParticleSystemQuad:create(__path(a.Path))
		if (nd) then
			set_param(nd, t)
			bind_layout(nd, t)
			return nd
		end
	end
end

local function gen_scrollview(t)
	local nd = ccui.ScrollView:create()
	set_background(nd,t)
	local a 
	a = t.InnerNodeSize
	if(a) then
		nd:setInnerContainerSize({width = a.Width, height = a.Height})
	end
	--scrollview  ScrollDirectionType is string
	a = t.ScrollDirectionType
	if(a=='Vertical') then
		nd:setDirection(1)
	elseif(a=='Horizontal') then
		nd:setDirection(2)
	elseif(a=='Vertical_Horizontal') then
		nd:setDirection(3)
	end
	if(t.ClipAble) then
		nd:setClippingEnabled(true)
	else
		nd:setClippingEnabled(false)	
	end	
	if(t.IsBounceEnabled) then
		nd:setBounceEnabled(true)
	else
		nd:setBounceEnabled(false)
	end
	set_param(nd, t, true, true)
	bind_layout(nd,t)
	return nd,'scrollview'
end

local function gen_audio(t)
end

local function gen_sprite(t)
	return gen_sp(t)
end
local function gen_textatlas(t)
	if (t.LabelAtlasFileImage_CNB and t.LabelAtlasFileImage_CNB.Path and t.CharWidth and t.CharHeight and t.StartChar) then
		local nd = ccui.TextAtlas:create(t.LabelText or "", __path(t.LabelAtlasFileImage_CNB.Path),
														t.CharWidth,
														t.CharHeight,
														t.StartChar)
		set_param(nd, t)
		bind_layout(nd,t)
		return nd
	end
end

local function gen_input(t)
	local inputbg = M_RES_INPUT_BG
	if(not inputbg) then
		return
	end
	local size=cc.size(t.Size.X, t.Size.Y)
	local nd = ccui.EditBox:create(size,inputbg)
	local a
	if(t.PlaceHolderText) then
		nd:setPlaceHolder(t.PlaceHolderText)
	end
	if (t.FontResource and t.FontResource.Path) then
		nd:setFontName(__path(t.FontResource.Path))
	end
	nd:setFontSize(t.FontSize)
	a = t.CColor
	if (a and (a.R or a.G or a.B)) then
		nd:setFontColor({r = a.R or 255, g = a.G or 255, b = a.B or 255})
	end
	a = t.CColor
	if (a and (a.R or a.G or a.B)) then
		nd:setFontColor({r = a.R or 255, g = a.G or 255, b = a.B or 255})
	end
	if(t.LabelText) then
		nd:setText(t.LabelText)
	end	
	if(t.MaxLengthEnable) then
		nd:setMaxLength(t.MaxLengthText)
    end
	if(t.PasswordEnable) then
		nd:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD);
    end
   	if(t.IsCustomSize) then
		nd:ignoreContentAdaptWithSize(false)
	else
		nd:ignoreContentAdaptWithSize(true)
	end
    nd:setReturnType(cc.KEYBOARD_RETURNTYPE_DONE)
    nd:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)

    set_param(nd, t, true)
	bind_layout(nd,t)

    if (M_EVT_NAME) then
    	local evt_name = M_EVT_NAME
		nd:registerScriptEditBoxHandler(function(strEventName,pSender)		
			ccsevt.dispatchEvent(ccsevt.genevt(evt_name,'input', strEventName, nd))
		end)
	end
	return nd
end

local align_map =
{
	HT_Left = 0,
	HT_Center = 1,
	HT_Right = 2,
	VT_Top = 0,
	VT_Center = 1,
	VT_Bottom = 2,
}

local function gen_text(t)
	local nd = ccui.Text:create()
	if(t.IsCustomSize) then
		-- nd:ignoreContentAdaptWithSize(false)
		-- use fixed width ,auto increace height
		nd:ignoreContentAdaptWithSize(true)	
		nd:setTextAreaSize({width = t.Size.X, height = 0})
	else
		nd:ignoreContentAdaptWithSize(true)	
		nd:setTextAreaSize({width = 0, height = 0})
	end

	local a 
	a = t.FontResource
	if(a) then
		nd:setFontName(__path(a.Path))
	end
	nd:setFontSize(t.FontSize)
 	nd:setString(t.LabelText)

	nd:setTextHorizontalAlignment(align_map[t.HorizontalAlignmentType] or 0)
	nd:setTextVerticalAlignment(align_map[t.VerticalAlignmentType] or 0)

	if(t.ShadowEnabled) then
		a = t.ShadowColor
 		nd:enableShadow({r = a.R or 255, g = a.G or 255, b = a.B or 255}, {width = t.ShadowOffsetX or 2, height = t.ShadowOffsetY or -2}, 0)
	end
	if(t.OutlineEnabled) then	
		a = t.OutlineColor
		nd:enableOutline({r = a.R or 255, g = a.G or 255, b = a.B or 255}, t.OutlineSize or 1)
	end
	a = t.CColor
	if (a and (a.R or a.G or a.B)) then
		nd:setTextColor({r = a.R or 255, g = a.G or 255, b = a.B or 255})
	end
	set_param(nd, t, true)
	bind_layout(nd,t)
	return nd
end

local function gen_bmfont(t)

	local a = t.LabelBMFontFile_CNB
	if (a and a.Path) then
		local nd = ccui.TextBMFont:create()
		if (nd) then
			nd:setFntFile(__path(a.Path))
			nd:setString(t.LabelText or "")
			set_param(nd, t)
			bind_layout(nd,t)
			return nd
		end
	end
end

-- local CheckBoxGroup = require("uis.CheckBoxGroup")
local function gen_checkbox_group(t)
	-- local nd = CheckBoxGroup.new()
	-- if (nd) then
	-- 	nd:setName(t.Name)
	-- 	set_param(nd, t)
	-- 	-- dump(t,"gen_checkbox_group")
	-- 	if(t.userdata and t.userdata.mode) then
	-- 		nd:setMode(t.userdata.mode)
	-- 	end
	-- 	if (M_EVT_NAME) then
	-- 		local evt_name = M_EVT_NAME
	-- 		nd:onSelecgChanged(function(...)
	-- 			-- ccsevt.dispatchEvent(ccsevt.genevt(evt_name, t.CallBackType, t.CallBackName, nd))
	-- 			-- Node type in editor hasnot t.CallBackName,insteadby t.FrameEvent
	-- 			ccsevt.dispatchEvent(ccsevt.genevt(evt_name, t.CallBackType, t.FrameEvent, nd))
	-- 		end)
	-- 	end
	-- 	return nd
	-- end
end

--------------------------------------
local config =
{
	SingleNodeObjectData = gen_node, --scene.ccs root node
	LayerObjectData = gen_layer, --layer.css root node
	ButtonObjectData = gen_btn,
	CheckBoxObjectData = gen_checkbox,
	ImageViewObjectData = gen_imgview,
	ListViewObjectData = gen_listview,
	LoadingBarObjectData = gen_loading,
	SliderObjectData = gen_slider,
	PageViewObjectData = gen_pageview,
	PanelObjectData = gen_panel,
	ParticleObjectData = gen_particle,
	ScrollViewObjectData = gen_scrollview,
	-- CheckBoxGroup = gen_checkbox_group, --custom class

	-- --SimpleAudioObjectData	= gen_audio,
	SpriteObjectData = gen_sprite,
	TextAtlasObjectData = gen_textatlas,
	TextFieldObjectData = gen_input,
	TextObjectData = gen_text,
	TextBMFontObjectData = gen_bmfont,
}
--------------------------------------
--[[[
"ccsload" = {
    "childs" = {
        "AtlasLabel" = {
            "node" = userdata: 05FCD028
            "tag"  = 18
        }
        "Button" = {
            "node" = userdata: 05FCB720
            "tag"  = 14
        }
        "Image" = {
            "node" = userdata: 05FCCAD0
            "tag"  = 16
        }
        "LoadingBar" = {
            "node" = userdata: 05FCD0B8
            "tag"  = 19
        }
        "Particle" = {
            "node" = userdata: 05FCB5B8
            "tag"  = 9
        }
        "Sprite" = {
            "node" = userdata: 05FCCBF0
            "tag"  = 12
        }
        "Text" = {
            "node" = userdata: 05FCCDE8
            "tag"  = 17
        }
        "TextField" = {
            "node" = userdata: 05FCD1D8
            "tag"  = 21
        }
    }
    "node"   = userdata: 05FCAD90
    "tag"    = -1
}
--]]
--------------------------------------
M.__index = function(self, k)
	if (M[k]) then
		return M[k]
	elseif (type(k) == "string") then
		if (string.byte(k) == 95) then --'_'
			return M.getChildRoot(self, string.sub(k, 2))
		else
			return M.getChildByName(self, k)
		end
	elseif (type(k) == "number") then
		return M.getChildByTag(self, k)
	end
	return nil
end
function M:getChildByTag(tag)
	if (tag >= 0) then
		local childs = rawget(self, 'childs')
		if (childs) then
			for _, v in pairs(childs) do
				if (v.tag == tag) then
					return rawget(v, 'node')
				end
			end
		end
	end
end

function M:getChildByName(name)
	--return self.childs and self.childs[name] and self.childs[name].node
	local r = rawget(self, 'childs')
	r = r and rawget(r, name)
	r = r and rawget(r, 'node')
	return r
end

function M:getChildRoot(name)
	-- print("------getChildRoot")
	-- return self.childs and self.childs[name]
	local r = rawget(self, 'childs')
	r = r and rawget(r, name)
	return r
end

function M:playAnim(rpt, handler)
	local act = self:genAction(self.actag, handler)
	-- print('playAnim',self.actag,act)
	if (act) then
		act:setTag(self.actag)
		self.node:runAction(act)
		if(rpt==-1) then		
			act:gotoFrameAndPlay(0,true)
		else
			act:gotoFrameAndPlay(0,false)	
		end
		return act
	end
end

function M:stopAnim()
	if (self.actag) then
		self.node:stopActionByTag(self.actag)
	end
end
function M:playAll(rpt, handler)
	local act = self:genAction(false, handler)
	-- print('playAll',act)
	if (act) then
		act:setTag(self.actag)
		self.node:runAction(act)
		if(rpt==-1) then		
			act:gotoFrameAndPlay(0,true)
		else
			act:gotoFrameAndPlay(0,false)	
		end
		return act
	end
end

-- r.tag = a.Tag or -1
-- r.actag = a.ActionTag or 0
-- r.json = a
-- r.childs
-- r.parent
function M:genAction(tag, handler)
	local anim = self.anim
	local animlist = self.animlist
	local parent = self.parent
	while ((not anim) and parent) do
		anim = parent.anim
		animlist = parent.animlist
		parent = parent.parent
	end
	-- print("genAction---111",tag)
	if (anim) then
		-- print("genAction---222")
		local act = ccsanim.gen(tag, anim, animlist, handler)
		-- print("genAction---333",act)
		if (not act) then
			return
		end
		return act
	end
end


M.play = M.playAnim
M.childroot = M.getChildRoot
M.action = M.genAction
--samewith NodeEx.lua

local function get_file_data(jsonfile)
	local name = cc.FileUtils:getInstance():fullPathForFilename(jsonfile)
	print('get_file_data',name)
	return cc.FileUtils:getInstance():getStringFromFile(name)
end	
local function gen_userdata(str)
	local tb={}
	local aa,bb = string.gsub(str,"([%w-_]+)%s*=%s*([%w-_]+)",function(a,b)
            tb[a]=b
    end)
    if(bb==0) then
        tb[1] = str
    end
    return tb
end

local function gen(a)
	local tp = a.ctype
	if (not tp) then
		return
	end
	-------------Node Userdata class---------
	local userdata = a.UserData and gen_userdata(a.UserData) or {}
	local userclass = userdata.class or a.type
	-------------Node Userdata class---------
	--print("-----"..tp)
	local f = config[userclass] or config[a.CustomClassName] or config[tp]
	if (not f) then
		print("-----no config----" .. tp)
		return
	end
	local r = {}
	a.userdata = userdata
	r.node,r.type = f(a) --r.type for listview scrollview pageview
	if (not r.node) then
		return
	end
	r.tag = a.Tag or -1
	r.actag = a.ActionTag or 0
	r.json = a
	r.name = a.Name or ""

	if(r.node.setUserData) then
		r.node:setUserData(a.UserData)
	end

	if (a.Children) then
		r.childs = {}
		--parse childs
		for _, v in ipairs(a.Children) do
			local n = gen(v)
			if (n and n.node) then
				if(r.type=='listview') then
					r.node:pushBackCustomItem(n.node)
				elseif(r.type=='pageview') then	
					r.node:addPage(n.node)
				else
					r.node:addChild(n.node)	
				end
				--table.insert(r.childs,n)
				r.childs[v.Name] = n
				n.parent = r
			end
		end
	end
	setmetatable(r, M)
	return r
end
function M.loadjson(jsonfile)
	local str = get_file_data(jsonfile)
	if (not str) then
		return false
	end
	local rst = {}
	local jsontb = json.decode(str)
	if (not jsontb) then
		return false
	end
	return jsontb
end
--conver json to table
function M.load_tb(jsontb, evtname, respath,func)
	M_EVT_NAME = evtname
	M_RES_PATH = respath
	local res = jsontb.Content.Content.UsedResources
	local root = jsontb.Content.Content.ObjectData
	local anim = jsontb.Content.Content.Animation
	local animlist = jsontb.Content.Content.AnimationList
	--use custom class name force if editor not mark
	if (func) then
		-- local rt = root
		root = func(root)
		-- print(tostring(rt))
		-- print(tostring(root))
		if not root then
			return
		end
	end
	------------------------------------------------
	for _, v in ipairs(res) do
		if (string.match(v, '%.plist$')) then
			local path = __path(v)
			-- print('__spfcache:addSpriteFrames',path,__spfcache.addSpriteFrames)
			__spfcache:addSpriteFrames(__path(v))
		end
	end
	------------------------------------------------
	local size = root.Size
	local name = root.Name
	local nodes = root.Children
	local r = gen(root)
	if (r) then
		r.anim = anim
		r.animlist = animlist
	end
	return r
end

function M.load(jsonfile, evtname, respath,func)
	local str = get_file_data(jsonfile)
	if (not str) then
		return false
	end
	local rst = {}
	local jsontb = json.decode(str)
	if (not jsontb) then
		return false
	end
	return M.load_tb(jsontb, evtname, respath, func),jsontb
end
function M.load_child(jsonfile, evtname, respath,childname)
	return M.load(jsonfile, evtname, respath,function(root)
		local function search(parent, name)
			for _, v in ipairs(parent.Children or {}) do
				if (v.Name == name) then
					return v
				else
					local r = search(v, name)
					if (r) then
						return r
					end
				end
			end
		end

		root = search(root, childname)
		return root
	end)
end
function M.load_child_tb(tb, evtname, respath,childname)
	return M.load_tb(tb, evtname, respath, function(root)
		local function search(parent, name)
			for _, v in ipairs(parent.Children or {}) do
				if (v.Name == name) then
					return v
				else
					local r = search(v, name)
					if (r) then
						return r
					end
				end
			end
		end

		root = search(root, childname)
		return root
	end)
end
function M.set_input_bg(bg)
	M_RES_INPUT_BG = bg
end
----------------------------------------------
--[[
1.can parse scene.ccs and layer.css as same format Node
2.Text custom size,ignore height, that make its heiht auto resize. --gen_text
3.LoadingBar ignoreContentAdaptWithSize(false) -- must be called after loadTexture, otherwise pecent always 100 --gen_loading
--]]

-- cc.exports.ccsload = M
ccsload = M
 
