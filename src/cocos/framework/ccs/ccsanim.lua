local function set_easact(frame,f)
    if(f.Tween==false) then
        frame:setTween(false)
    elseif(f.EasingData) then
        frame:setTween(true)
        frame:setTweenType(f.EasingData.Type)
        local pp = f.EasingData.Points
        if(pp) then
            local param = {pp[1].X,pp[1].Y, pp[2].X,pp[2].Y, pp[3].X,pp[3].Y, pp[4].X,pp[4].Y}
            frame:setEasingParams(param)
        end
    end
end

local function gen_pos(frames,extra)
    local timeline = ccs.Timeline:create()
    -- local px,py=extra.pos[1],extra.pos[2]
    for _,f in ipairs(frames) do        
        local frame = ccs.PositionFrame:create()
        frame:setFrameIndex(f.FrameIndex)
        frame:setX(f.X)
        frame:setY(f.Y)
        set_easact(frame,f)
        timeline:addFrame(frame)
    end
    return timeline
end
local function gen_scale(frames)
    local timeline = ccs.Timeline:create()
    for _,f in ipairs(frames) do        
        local frame = ccs.ScaleFrame:create()
        frame:setFrameIndex(f.FrameIndex)
        frame:setScaleX(f.X)
        frame:setScaleY(f.Y)
        set_easact(frame,f)
        timeline:addFrame(frame)
    end
    return timeline
end
local function gen_rotate(frames)
    local timeline = ccs.Timeline:create()
    for _,f in ipairs(frames) do        
        local frame = ccs.RotationSkewFrame:create()
        frame:setFrameIndex(f.FrameIndex)
        frame:setSkewX(f.X)
        frame:setSkewX(f.Y)
        set_easact(frame,f)
        timeline:addFrame(frame)
    end
    return timeline
end
local function gen_anchor(frames)
    local timeline = ccs.Timeline:create()
    for _,f in ipairs(frames) do        
        local frame = ccs.AnchorPointFrame:create()
        frame:setFrameIndex(f.FrameIndex)
        frame:setAnchorPoint({x=f.X,y=f.Y})
        set_easact(frame,f)
        timeline:addFrame(frame)
    end
    return timeline
end

local function gen_visible(frames)
    local timeline = ccs.Timeline:create()
    for _,f in ipairs(frames) do        
        local frame = ccs.VisibleFrame:create()
        frame:setFrameIndex(f.FrameIndex)
        frame:setVisible(f.Value)
        set_easact(frame,f)
        timeline:addFrame(frame)
    end
    return timeline
end
local function gen_color(frames)
    local timeline = ccs.Timeline:create()
    for _,f in ipairs(frames) do        
        local frame = ccs.ColorFrame:create()
        frame:setFrameIndex(f.FrameIndex)
        if(f.Color) then
            local c =  {r=f.Color.R or 255, g=f.Color.G or 255, b=f.Color.B or 255}
            frame:setColor(c)
        end
        set_easact(frame,f)
        timeline:addFrame(frame)
    end
    return timeline
end
local function gen_alpha(frames)
    local timeline = ccs.Timeline:create()
    for _,f in ipairs(frames) do        
        local frame = ccs.AlphaFrame:create()
        frame:setFrameIndex(f.FrameIndex)
        frame:setAlpha(f.Value)
        set_easact(frame,f)
        timeline:addFrame(frame)
    end
    return timeline
end
local function gen_evt(frames)
    local timeline = ccs.Timeline:create()
    for _,f in ipairs(frames) do        
        local frame = ccs.EventFrame:create()
        frame:setFrameIndex(f.FrameIndex)
        frame:setEvent(f.Value)
        set_easact(frame,f)
        timeline:addFrame(frame)
    end
    return timeline
end
local function gen_texture(frames)
    local timeline = ccs.Timeline:create()
    for _,f in ipairs(frames) do        
        local frame = ccs.TextureFrame:create()
        frame:setFrameIndex(f.FrameIndex)
        local t = f.TextureFile
        if(t) then
          frame:setTextureName(t.Path)
        end
        set_easact(frame,f)
        timeline:addFrame(frame)
    end
    return timeline
end
local function gen_blendfunc(frames)
    local timeline = ccs.Timeline:create()
    for _,f in ipairs(frames) do        
        local frame = ccs.BlendFuncFrame:create()
        frame:setFrameIndex(f.FrameIndex)
        frame:setBlendFunc( {src=f.Src, dst=f.Dst} )
        set_easact(frame,f)
        timeline:addFrame(frame)
    end
    return timeline
end

local config=
{
    Position            = gen_pos,
    Scale               = gen_scale,
    AnchorPoint         = gen_anchor,
    RotationSkew        = gen_rotate,
    VisibleForFrame     = gen_visible,
    CColor        = gen_color,
    Alpha         = gen_alpha,
    FrameEvent    = gen_evt,
    FileData      = gen_texture,
    BlendFunc     = gen_blendfunc,
}

local function ccsanim_genaction(tag,anim,animlist,evthandler,extra)
  -- print("========================")
  -- print("=======")
  -- print("=======")
  -- print("ccsanim_genaction ",tagorname)
  -- print("ccsanim_genaction ",anim)
  -- print("ccsanim_genaction ",animlist)
  -- print("ccsanim_genaction ",evthandler)
  -- print("=======")
  -- print("=======")
  -- print("========================")
  
  --false or number
  if(type(tag)~='string')then
  --gen one action by tag
      local tb={}

      local action = ccs.ActionTimeline:create()
      action:setDuration(anim.Duration)
      action:setTimeSpeed(anim.Speed)
      for _,v in ipairs(anim.Timelines) do
          if((not tag) or v.ActionTag==tag) then
              local f=config[v.Property]
              --print("==",v.Property,f)
              if(f) then
                  local timeline = f(v.Frames,extra)
                  if(timeline) then
                      timeline:setActionTag(v.ActionTag)
                      action:addTimeline(timeline)
                  end
              end
          end
      end
      action:setFrameEventCallFunc(function(frame)        
            local str = frame:getEvent()
            if(str and evthandler) then
                evthandler(str)
            end   
        end)

      if(animlist) then
          for _,v in ipairs(animlist) do
            local info = {name=v.Name, startIndex=v.StartIndex, endIndex=v.EndIndex}
            action:addAnimationInfo(info)
          end
      end
      
      return action
  else
  --string name
  end
end

local M = {}
M.gen = ccsanim_genaction

-- cc.exports.ccsanim = M
ccsanim = M
