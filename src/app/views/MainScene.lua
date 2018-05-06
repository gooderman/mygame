
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()

    printLog('NET','xxnet=%d,%s,%d',1,'mmkk',100) 
    -- printFilter(false,{"DUMP","ZIP","INFO"})
    printFilter(true,"ZIP")
    -- add background image
    if(true) then
        local sp = cc.Sprite:create("HelloWorld.png")
        self:addChild(sp)
    end

    local sp = display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self):setName('sp')

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 80)
        :move(display.cx, display.cy + 400)
        :addTo(self):setName("lable")

   dump(cc.LuaZipFile,'cc.LuaZipFile=')
   local fs = cc.FileUtils:getInstance()
   local fullpath = fs:fullPathForFilename("framework.zip")
   printLog("GOOD",'zippath',fullpath)

   local zipfile = cc.LuaZipFile:create(fullpath)
   print('new Luazipfile',zipfile)
   dumpTag('ZIP',zipfile:getFileList(),"getfilelist")

   -- local savepath = fs:getWritablePath() .. "framework"
   -- print('extract_async to 123',savepath)
   -- zipfile:extract_async(savepath,function(st,max,cur)
   --                          print(st,max,cur)
   --                       end)

   sp:runAction(cc.RotateBy:create(20.0, {x=0,y=1800,z=0}))

   local cjson = require('cjson')
   print(cjson.encode({a=1,b=2}))
   local lpack = require('pack')
   local sproto  = require('sproto.core')
   local netxx = cc.NetXX:getInstance()
   netxx:init()
   netxx:setEndpoint("www.baidu.com","",80)
   netxx:setLuaListener(function(a,b,c) 
      printLog('NET','xxnet',a,b,c) 
      if(a==0 and b==2) then
        netxx:setConnectWaitTimeout(1000*math.random(1,5))
        netxx:shutdown()
      end  
   end)
   netxx:startConnect()


   local zlip = require('zlib')
   local sqlite = require('lsqlite3')
   local unqlite  = require('unqlite')
   local pb  = require('pb')
   local lpeg  = require('lpeg')
   local lfs = require('lfs')
   local bit = require('bit')

   local str = '123456789'
   local str64 = cc.Crypto:encodeBase64(str,string.len(str))
   printInfo('encodeBase64',str64)



   local root = cc.CSLoader:createNode("main.csb",function(nd) print('load',nd:getName()) end)
   
   if(root) then
       local childs = root:getChildren()
       for _,cc in ipairs(childs) do
          local isui = iskindof(cc, 'ccui.Widget')
          print('child',cc,cc:getName(),isui,iskindof(cc, 'ccui.Button'),cc:getCallbackType(),cc:getCallbackName())

       end 
   end

   self:addChild(root)


   dump(cc.Crypto,'cc.Crypto')
   dump(cc.DownloaderLua,'cc.DownloaderLua')
   -- cc.DownloaderLua:resetListener(1)

   print("urlencode",string.urlencode('www.163.com'))
   print("utf8trim",string.utf8trim('我1们2345',1.5,'?'))

   local ddll = cc.DownloaderLua
   ddll:createDownloadDataTask("https://t10.baidu.com/it/u=3903969777,3048841688&fm=173&app=12&f=JPEG?w=500&h=527&s=A69131C4C373B7DC887F5B9C0300508E",
   function(a,b,c,d) print("ddll callback",a,b,c,d) end)

   local path = cc.FileUtils:getInstance():getWritablePath()..'a.gif'
    ddll:createDownloadFileTask("https://s.ip-cdn.com/img/logo.gif",
    path,
   function(a,b,c,d) printLog('NET','ddll callback',a,b,c,d) end)



   local path = cc.FileUtils:getInstance():getWritablePath()..'ali_hb.jpg'
    ddll:createDownloadFileTask("https://s.ip-cdn.com/img/ali_hb.jpg",
    path,
   function(a,b,c,d) printLog('NET',a,b,c,d) end)

    
   



end

return MainScene
