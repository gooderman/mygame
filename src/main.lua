
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"

display.setOpenGLView(CC_DESIGN_RESOLUTION)

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
