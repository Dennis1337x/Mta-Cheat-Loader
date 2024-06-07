local character = new('CHARACTER')

function character.prototype.____constructor(self)
    --/////////////////////////////////////////////////////////
    self._function = {}
    self._function.display = function(...) self:_display(self) end
    self._function.load = function(...) self:_load(self) end
    self._function.loadF10 = function(...) self:_loadF10(self) end
    self._function.render = function(...) self:_render(self) end
    self._function.success = function(...) self:_success(self) end
    self._function.change = function(...) self:_change(self) end
    self._function.write = function(...) self:_write(self, ...) end
    --/////////////////////////////////////////////////////////
    self.screen = Vector2(guiGetScreenSize())
    self.w, self.h = 250, 25
    self.x, self.y = (self.screen.x-self.w), (self.screen.y-self.h)
    self.font = exports.assets:getFont('in-medium',11)
    self.fonttext = exports.assets:getFont('in-regular',10)
    self.fonttext2 = exports.assets:getFont('in-regular',8)
    self.fontbb2 = exports.assets:getFont('in-medium',8)
    self.fontB = exports.fonts:getFont('RobotoB',10)
    self.fontB2 = exports.fonts:getFont('RobotoB',13)
    self.fontB3 = exports.assets:getFont('in-bold',13)
    self.fontB4 = exports.assets:getFont('in-medium',11)
    self.fontBB2 = exports.assets:getFont('in-bold',15)

    self.fontaw = exports.assets:getFont('FontAwesome',14)
    self.fontawe = exports.assets:getFont('FontAwesome',8)
    self.ricon = exports.assets:getFont('FontAwesome',45)
    self.fontpl = exports.assets:getFont('in-bold',33)
    self.awe = exports.assets:getFont('FontAwesome',11)
    self.awe2 = exports.assets:getFont('FontAwesome',12)

    --/////////////////////////////////////////////////////////
    self:_get(self)
end

local startX, startY, startZ, startX2, startY2, startZ2 = 2130.2700195312, -2267.9233398438, 21.166923522949, 2230.1213378906, -2266.5261230469, 15.896944046021 
local endX, endY, endZ, endX2, endY2, endZ2 = 2151.0009765625, -2256.5043945312, 13.560199737549, 2169.7116699219, -2158.4006347656, 8.501859664917 

local duration = 5000

function playCreate()
    local startTime = getTickCount()
    addEventHandler("onClientRender", root, function()
        local now = getTickCount()
        local elapsedTime = now - startTime
        
        if elapsedTime < duration then
            local progress = elapsedTime / duration
            local currentX = interpolateBetween(startX, 0, 0, endX, 0, 0, progress, "Linear")
            local currentY = interpolateBetween(startY, 0, 0, endY, 0, 0, progress, "Linear")
            local currentZ = interpolateBetween(startZ, 0, 0, endZ, 0, 0, progress, "Linear")
            local currentX2 = interpolateBetween(startX2, 0, 0, endX2, 0, 0, progress, "Linear")
            local currentY2 = interpolateBetween(startY2, 0, 0, endY2, 0, 0, progress, "Linear")
            local currentZ2 = interpolateBetween(startZ2, 0, 0, endZ2, 0, 0, progress, "Linear")
            
            setCameraMatrix(currentX, currentY, currentZ, currentX2, currentY2, currentZ2)
        else
            removeEventHandler("onClientRender", root, playCreate)
        end
    end)
end


function character.prototype._render(self)
    dxDrawRectangle(0, 0, self.screen.x, self.screen.y, tocolor(0,0,0,50))

   if self.page == 5 then
    dxDrawImage(self.x/2-200, self.y/2-125, 200, 200, 'assets/logo.png', 0, 0, 0, tocolor(255,255,255,self.alpha))
   end
    self.counter = 0
    self.addY = 0
    self.characters = localPlayer:getData('account:characters') or {}
    if #self.characters > 0 then 
        setElementAlpha(self.ped, 255)
    else
        if self.page == 1 then
            setElementAlpha(self.ped, 255)
        else
            setElementAlpha(self.ped, 0)
        end
    end

    if self.page == 1 then

        roundedDraw("sf", self.screen.x/2-400, self.screen.y-100, 810, 60, 10,tocolor(15,15,15,250))


        if mouse(self.screen.x/2-385, self.screen.y-90, 230, 60-20,"text") then
            roundedDraw("t-t", self.screen.x/2-385, self.screen.y-90, 230, 60-20, 10,tocolor(25,25,25,250))
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                self.selectedText = 'name'
                if self.name == 'Örnek: Mustafa_Demir' then
                    self.name = ''
                end
            end
        else
            roundedDraw("t-t", self.screen.x/2-385, self.screen.y-90, 230, 60-20, 10,tocolor(20,20,20,250))
        end
                              
        dxDrawText(self.name, self.screen.x/2-330, self.screen.y-75, nil, nil, tocolor(175,175,175,225), 1, self.fonttext2)
        dxDrawText("", self.screen.x/2-370, self.screen.y-80, nil, nil, tocolor(175,175,175,180), 1, self.awe2)
        if self.selectedText == 'name' then
            self.textSize = dxGetTextWidth(self.name,1,self.fonttext2)
            dxDrawText('l', self.screen.x/2-330+(1*self.textSize), self.screen.y-77, nil, nil, tocolor(175, 175, 175, self.textAlpha), 1, self.font)
        end

        if mouse(self.screen.x/2-140, self.screen.y-90, 80, 60-20,"text") then
            roundedDraw("t-t", self.screen.x/2-140, self.screen.y-90, 80, 60-20, 10,tocolor(25,25,25,250))
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                self.selectedText = 'age'
                if self.age == '18' then
                    self.age = ''
                end
            end
        else
            roundedDraw("t-t", self.screen.x/2-140, self.screen.y-90, 80, 60-20, 10,tocolor(20,20,20,250))
        end
        dxDrawText(self.age, self.screen.x/2-90, self.screen.y-78, 50, 28, tocolor(175,175,175,225), 1, self.fonttext)
        dxDrawText("", self.screen.x/2-125, self.screen.y-78, nil, nil, tocolor(175,175,175,225), 1, self.awe2)

        if self.selectedText == 'age' then
            self.textSize = dxGetTextWidth(self.age,1,self.fonttext)
            dxDrawText('l', self.screen.x/2-90+(1*self.textSize), self.screen.y-77, nil, nil, tocolor(175, 175, 175, self.textAlpha), 1, self.font)
        end

        if mouse(self.screen.x/2-45, self.screen.y-90, 110, 60-20,"text") then
            roundedDraw("t-t", self.screen.x/2-45, self.screen.y-90, 110, 60-20, 10,tocolor(25,25,25,250))
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                self.selectedText = 'height'
                if self.height == '180' then
                    self.height = ''
                end
            end
        else
            roundedDraw("t-t", self.screen.x/2-45, self.screen.y-90, 110, 60-20, 10,tocolor(20,20,20,250))
        end
        dxDrawText("", self.screen.x/2-28, self.screen.y-75, nil, nil, tocolor(175,175,175,225), 1, self.fontawe)
        dxDrawText(''..self.height..'cm', self.screen.x/2-1, self.screen.y-78, nil, nil, tocolor(175,175,175,225), 1, self.fonttext)
        if self.selectedText == 'height' then
            self.textSize = dxGetTextWidth(''..self.height..'',1,self.font)
            dxDrawText('l', self.screen.x/2-1+(1*self.textSize), self.screen.y-77, nil, nil, tocolor(175, 175, 175, self.textAlpha), 1, self.font)
        end

        if mouse(self.screen.x/2+80, self.screen.y-90, 110, 60-20 ,"text") then
            roundedDraw("t-t", self.screen.x/2+80, self.screen.y-90, 110, 60-20, 10,tocolor(25,25,25,250))
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                self.selectedText = 'weight'
                if self.weight == '70' then
                    self.weight = ''
                end
            end
        else
            roundedDraw("t-t", self.screen.x/2+80, self.screen.y-90, 110, 60-20, 10,tocolor(20,20,20,250))
        end
        dxDrawText(''..self.weight..'kg', self.screen.x/2+125, self.screen.y-78, nil, nil, tocolor(175,175,175,225), 1, self.fonttext)
        dxDrawText('', self.screen.x/2+100, self.screen.y-76, nil, nil, tocolor(175,175,175,225), 1, self.fontawe)

        if self.selectedText == 'weight' then
            self.textSize = dxGetTextWidth(self.weight,1,self.fonttext)
            dxDrawText('l', self.screen.x/2+125+(1*self.textSize), self.screen.y-77, nil, nil, tocolor(175, 175, 175, self.textAlpha), 1, self.font)
        end

        if mouse(self.screen.x/2+205, self.screen.y-90, 50, 60-20,"hand") then
            roundedDraw("t-t", self.screen.x/2+205, self.screen.y-90, 50, 60-20, 10,tocolor(25,25,25,250))
            dxDrawText('', self.screen.x/2+221, self.screen.y-80, nil, nil, tocolor(200,200,200,200), 1, self.awe2)
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                setElementModel(self.ped, math.random(0,200))
            end
        else 
            roundedDraw("t-t", self.screen.x/2+205, self.screen.y-90, 50, 60-20, 10,tocolor(20,20,20,250))
            dxDrawText('', self.screen.x/2+221, self.screen.y-80, nil, nil, tocolor(200,200,200,200), 1, self.awe2)
        end

            if mouse(self.screen.x/2-290, self.screen.y-160, 610/2-20, 60-20,"hand") then
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.gender = 0
                    setElementModel(self.ped, 50)
                    self.ped:setAnimation("ped", "idle_chat")

                end
            end

            if mouse(self.screen.x/2-(290)+290+15, self.screen.y-160, 610/2-20, 60-20,"hand") then
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.gender = 1
                    setElementModel(self.ped, 59)
                    self.ped:setAnimation("ped", "woman_idlestance")
                end
            end

        if mouse(self.screen.x/2+270, self.screen.y-90, 125, 60-20, "hand") then
            if getKeyState('mouse1') and self.click+400 <= getTickCount () then 
			self.click = getTickCount ()	
                triggerServerEvent('auth.char.create', localPlayer, self.name, self.age, self.weight, self.height, self.country, self.ped.model, self.gender)
            end
            roundedDraw("t-t", self.screen.x/2+270, self.screen.y-90, 125, 60-20, 10,tocolor(20,20,20,250))
        else
            roundedDraw("t-t", self.screen.x/2+270, self.screen.y-90, 125, 60-20, 10,tocolor(20,20,20,250))
        end
        dxDrawText('karakteri oluştur',  self.screen.x/2+286, self.screen.y-77, nil, nil, tocolor(175,175,175,225), 1, self.fonttext2)

        if mouse(self.screen.x/2+430, self.screen.y-90, 40, 60-20,"hand") then
            roundedDraw("t-t", self.screen.x/2+420, self.screen.y-100, 60, 60, 10,tocolor(15,15,15,250))
            roundedDraw("t-t", self.screen.x/2+430, self.screen.y-90, 40, 60-20, 10,tocolor(25,25,25,250))
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                self.page = 0
            end
        else
            roundedDraw("t-t", self.screen.x/2+420, self.screen.y-100, 60, 60, 10,tocolor(15,15,15,250))
            roundedDraw("t-t", self.screen.x/2+430, self.screen.y-90, 40, 60-20, 10,tocolor(20,20,20,250))
        end
        dxDrawText('x', self.screen.x/2+444, self.screen.y-85, nil, nil, tocolor(175,175,175,160), 1, self.fontBB2)

        if getKeyState('backspace') and self.click+120 <= getTickCount() then
            self.click = getTickCount()
            if self.selectedText == 'name' then
                self.fistPart = self.name:sub(0, self.charName-1)
                self.lastPart = self.name:sub(self.charName+1, #self.name)
                self.name = self.fistPart..self.lastPart
                self.charName = string.len(self.name)
            elseif self.selectedText == 'age' then
                self.fistPart = self.age:sub(0, self.charAge-1)
                self.lastPart = self.age:sub(self.charAge+1, #self.age)
                self.age = self.fistPart..self.lastPart
                self.charAge = string.len(self.age)
            elseif self.selectedText == 'height' then
                self.fistPart = self.height:sub(0, self.charHeight-1)
                self.lastPart = self.height:sub(self.charHeight+1, #self.height)
                self.height = self.fistPart..self.lastPart
                self.charHeight = string.len(self.height)
            elseif self.selectedText == 'weight' then
                self.fistPart = self.weight:sub(0, self.charWeight-1)
                self.lastPart = self.weight:sub(self.charWeight+1, #self.weight)
                self.weight = self.fistPart..self.lastPart
                self.charWeight = string.len(self.weight)
            end
        end

        roundedDraw("Bösdlşaö", self.screen.x/2-300, self.screen.y-170, 610, 60, 10,tocolor(15,15,15,250))
        roundedDraw("Bösdlşaö", self.screen.x/2-290, self.screen.y-160, 610/2-20, 60-20, 10,tocolor(20,20,20,250))
        roundedDraw("Bösdlşaö", self.screen.x/2-(290)+290+15, self.screen.y-160, 610/2-20, 60-20, 10,tocolor(20,20,20,250))

        if self.gender == 1 then
            dxDrawText("", self.screen.x/2-155, self.screen.y-149, self.screen.x/2, nil, tocolor(0,155,255,50), 1, self.awe)
        else
            dxDrawText("", self.screen.x/2-155, self.screen.y-149, self.screen.x/2, nil, tocolor(0,155,255,255), 1, self.awe)
        end

        if self.gender == 0 then
            dxDrawText("", self.screen.x/2+150, self.screen.y-149, self.screen.x/2, nil, tocolor(255,0,255,50), 1, self.awe)
        else
            dxDrawText("", self.screen.x/2+150, self.screen.y-149, self.screen.x/2, nil, tocolor(255,0,255,255), 1, self.awe)
        end
    else
        self.count = 0
        for index, value in ipairs(self.characters) do
            self.count = self.count - 65
            self.counter = self.counter + 1
            if self.selected == index then          

            else

            end

            if mouse(self.screen.x/2-300, self.screen.y-100, 610, 60,"hand") then
                if getKeyState('mouse1') and self.click+400 <= getTickCount () then 
                    self.click = getTickCount ()    
                    self.page = 1
                    setElementModel(self.ped, 50)
                    self.ped:setAnimation("ped", "idle_chat")
                end
            end

            roundedDraw("B1", self.screen.x/2-300, self.screen.y-160-17-self.addY*2+11, 610, 60, 10, tocolor(15,15,15,250))
            roundedDraw("B2", self.screen.x/2-300, self.screen.y-100, 610, 60, 10,mouse(self.screen.x/2-300, self.screen.y-100, 610, 60,"hand") and tocolor(15,15,15,230) or tocolor(15,15,15,250))
            roundedDraw("B3", self.screen.x/2-290, self.screen.y-150-17-self.addY*2+11, 200, 40, 7, tocolor(25,25, 25,180))
            roundedDraw("B4", self.screen.x/2-290+210, self.screen.y-150-17-self.addY*2+11, 200, 40, 7, tocolor(25,25, 25,180))
            roundedDraw("B5", self.screen.x/2-290+210+210, self.screen.y-150-17-self.addY*2+11, 80, 40, 7, tocolor(25,25, 25,180))
            roundedDraw("B6", self.screen.x/2-290+210+210+90, self.screen.y-150-17-self.addY*2+11, 80, 40, 7, tocolor(25,25, 25,180))
            dxDrawText(""..value[2],  self.screen.x/2-300+30+20,self.screen.y-160-17-self.addY*2+32, nil, nil, tocolor(175,175,175,175), 1,  self.fonttext, nil, nil, false, false, false, true, false)
            dxDrawText("", self.screen.x/2-300+15+225,self.screen.y-160-17-self.addY*2+32, 200, 40, tocolor(175,175,175,175), 1, self.awe)

            dxDrawText('$'..exports.global:formatMoney(value[4]),  self.screen.x/2-300+30+5+230,self.screen.y-160-17-self.addY*2+32, nil, nil, tocolor(175,175,175,175), 1,  self.fonttext, nil, nil, false, false, false, true, false)
            dxDrawText("", self.screen.x/2-300+25,self.screen.y-160-17-self.addY*2+32, 200, 40, tocolor(175,175,175,175), 1, self.awe)
            if value[10] == 0 then
                self.toGender = 'Erkek'
                self.toGender1 = ''
            else
                self.toGender = 'Kadın'
                self.toGender1 = ''
            end
            dxDrawText(self.toGender,  self.screen.x/2-300+30+5+216+200,self.screen.y-160-17-self.addY*2+32, nil, nil, tocolor(175,175,175,175), 1,  self.fonttext, nil, nil, false, false, false, true, false)
            if value[3] == 1 then
                self.state = 'Ölü'
            else
                self.state = 'Yaşıyor'
            end
            roundedDraw("bm", self.screen.x/2+327.5+7.5, self.screen.y-160-17-self.addY*2+11, 60, 60, 10, tocolor(15,15,15,250))

            if mouse(self.screen.x/2+343.5,  self.screen.y-160-17-self.addY*2+18, 45, 45, 'hand') then
                if getKeyState('mouse1') and self.click+600 <= getTickCount() then
                    self.click = getTickCount()
                    triggerServerEvent('auth.spawn', localPlayer, value[1])
                    self:_spawn(self)
                    --setCameraMatrix(localPlayer,localPlayer)
                    --removeEventHandler("onClientRender", root, playCreate)
                    --setCameraTarget(localPlayer,localPlayer)
                end
                roundedDraw("bm", self.screen.x/2+343.5, self.screen.y-160-17-self.addY*2+18, 45, 45, 7, tocolor(20, 20, 20,180))
            else
                roundedDraw("bm", self.screen.x/2+343.5, self.screen.y-160-17-self.addY*2+18, 45, 45, 7, tocolor(25,25,25,180))
            end
            dxDrawText('>', self.screen.x/2+360, self.screen.y-160-17-self.addY*2+25, nil, nil, tocolor(180, 180, 180, 180), 1, self.fontBB2)

            dxDrawText(self.state,  self.screen.x/2-300+30+5+216+206+80,self.screen.y-160-17-self.addY*2+32, nil, nil, tocolor(175,175,175,175), 1,  self.fonttext, nil, nil, false, false, false, true, false)
       --     dxDrawText("", self.screen.x/2-300+15+216+205+89,self.screen.y-160-17-self.addY*2+32, 200, 40, tocolor(175,175,175,175), 1, self.awe)
            self.addY = self.addY + 34
        end
    end
    if self.page == 1 then
        dxDrawText('karakter içeriğini doldur ve oluştur', 0, 0, self.screen.x, self.screen.y-200, tocolor(150,150,150,200), 1, self.fontBB2, 'center', 'bottom')
    else
        roundedDraw("B2", self.screen.x/2-300, self.screen.y-100, 610, 60, 10,mouse(self.screen.x/2-300, self.screen.y-100, 610, 60,"hand") and tocolor(15,15,15,230) or tocolor(15,15,15,250))
        dxDrawText('', self.screen.x/2,self.screen.y-79,self.screen.x/2-360,nil, mouse(self.screen.x/2-300, self.screen.y-100, 610, 60,"hand") and tocolor(175,175,175,145) or tocolor(175,175,175,175), 1, self.awe,"center",nil)
        dxDrawText('Karakterinden sıkıldın mı? Yenisini oluşturmak için tıkla!', self.screen.x/2,self.screen.y-79,self.screen.x/2+30,nil, mouse(self.screen.x/2-300, self.screen.y-100, 610, 60,"hand") and tocolor(175,175,175,145) or tocolor(175,175,175,175), 1, self.fonttext,"center",nil)


            if mouse(self.screen.x/2-300, self.screen.y-100, 610, 60,"hand") then
                if getKeyState('mouse1') and self.click+400 <= getTickCount () then 
                    self.click = getTickCount ()    
                    self.page = 1
                    setElementModel(self.ped, 50)
                    self.ped:setAnimation("ped", "idle_chat")
                end
            end
    end
   end



function character.prototype._success(self)
    self.page = 0
end

function character.prototype:_write(self, char)
    if self.selectedText == 'name' then
        if self.click+50 <= getTickCount() then
            self.click = getTickCount()
            if string.len(self.name) <= 23 then
                self.name = ''..self.name..''..char
                self.charName = string.len(self.name)+1
                Sound("assets/key.mp3")
            end
        end
    elseif self.selectedText == 'age' then
        if tonumber(char) then
            if self.click+50 <= getTickCount() then
                self.click = getTickCount()
                if string.len(self.age) <= 1 then
                    self.age = ''..self.age..''..char
                    self.charAge = string.len(self.age)+1
                    Sound("assets/key.mp3")
                end
            end
        end
    elseif self.selectedText == 'height' then
        if tonumber(char) then
            if self.click+50 <= getTickCount() then
                self.click = getTickCount()
                if string.len(self.height) <= 2 then
                    self.height = ''..self.height..''..char
                    self.charHeight = string.len(self.height)+1
                    Sound("assets/key.mp3")
                end
            end
        end
    elseif self.selectedText == 'weight' then
        if tonumber(char) then
            if self.click+50 <= getTickCount() then
                self.click = getTickCount()
                if string.len(self.weight) <= 1 then
                    self.weight = ''..self.weight..''..char
                    self.charWeight = string.len(self.weight)+1
                    Sound("assets/key.mp3")
                end
            end
        end
    end
end

function character.prototype._spawn(self)
    if isTimer(self.timer) then
        killTimer(self.timer)
    end
    if song then
        stopSound(song)
        song = nil
    end
    showChat(true)
    showCursor(false)
    self.ped:destroy()
    removeEventHandler('onClientRender', root, self._function.render)
    localPlayer:setData('auth.f10', false)
    self.active = false
end

function character.prototype._stop(self)
    exports.blur:destroyBlurBox(self.blur)
    self.selectedText = ''
    self.blur = nil
    self.click = 0
    self.country = 1
    self.gender = 0

    self.page = 0
    self.clicked = 0
    self.selected = 1
    self.age = '18'
    self.height = '180'
    self.weight = '70'
    self.name = 'Örnek: Mustafa_Demir'
    self.charName = string.len(self.name)+1
    self.charAge = string.len(self.age)+1
    self.charHeight = string.len(self.height)+1
    self.charWeight = string.len(self.weight)+1
    self.timer = Timer(function()
        if self.textAlpha == 0 then
            self.textAlpha = 175
        else
            self.textAlpha = 0
        end
    end, 700, 0)
    removeEventHandler('onClientRender', root, self._function.load)
    removeEventHandler('onClientRender', root, playCreate)
    addEventHandler('onClientRender', root, self._function.render, true, 'low-10')

    self.dimension = getElementDimension(localPlayer)
    self.ped = createPed(50, 2151.314453125, -2254.9345703125, 13.29797744751)
    self.ped:setInterior(0)
    self.ped:setDimension(self.dimension)
    setElementModel(self.ped, 59)
    setElementRotation(self.ped, 0, 0, 168)
    self.ped:setAnimation("ped", "woman_idlestance")
    self.ped.frozen = true
end

function character.prototype._load(self)
    if self.rot == 2 then
        playCreate()
    end
    if self.rot < 330 then
       self.rot = self.rot + 1
    end
    if self.alphax < 255 then
        self.alphax = self.alphax + 1
    end 
    if self.time < 551 then
        self.time = self.time + 1
    end  
    
    dxDrawRectangle(0, 0, self.screen.x, self.screen.y, tocolor(0,0,0,170))
    dxDrawText("karakterlerin yükleniyor", 0, 0, self.screen.x, self.screen.y, tocolor(175,175,175,self.alphax), 1, self.fontB3, 'center', 'center')
    if self.time >= 525 then
    -- if self.rot >= 1 then
        if self.loadstate then else
            self.loadstate = true
            self.randomdim = math.random(1, 999) 
            self:_stop(self)
        end
    end
end



function character.prototype._display(self)
    self.loadstate = false
    self.rot = 0
    self.alphax = 0
    self.time = 0
 --   Camera.setMatrix(806.51129150391, 57.75569152832, 966.06408691406, 860.27404785156, -26.544515609741, 964.31915283203)
 -- setElementModel(localPlayer, 59)
 -- setElementDimension(localPlayer, self.randomdim)
 -- setElementInterior(localPlayer, 3, 800, 55, 965)
 -- -- self.blur = exports.blur:createBlurBox(0,0,self.screen.x,self.screen.y,175,175,175,255,false)
  addEventHandler('onClientRender', root, self._function.load, true, 'low-10')
  --playCreate()
  --setElementDimension(localPlayer, 0)
  --setElementInterior(localPlayer, 0)
    self.active = true
end

function character.prototype._stopF10(self)
    self.loadstate = false
    showChat(false)
    showCursor(true)
    setElementDimension(localPlayer, math.random(1,999))
    setElementInterior(localPlayer, 3)
    self:_display(self)
    removeEventHandler('onClientRender', root, self._function.loadF10)
end

function character.prototype._loadF10(self)
    self.rot = self.rot + 10
    dxDrawRectangle(0, 0, self.screen.x, self.screen.y, tocolor(7,7,7,145))
    dxDrawImage(self.screen.x/2-32, self.screen.y/2-32, 32, 32, 'assets/loading.png', self.rot)
    if self.rot >= 225 then
        if self.loadstate then else
            self.loadstate = true
            self:_stopF10(self)
        end
    end
end

function character.prototype._change(self)
    if localPlayer:getData('loggedin') == 1 then
        if self.active then else
            localPlayer:setData('auth.f10', true)
            self.active = true
            self.loadstate = false
            self.rot = 0
            setElementDimension(localPlayer, 0)
            setElementInterior(localPlayer, 0)
            localPlayer.alpha = 150
            triggerServerEvent('auth.save', localPlayer)
            addEventHandler('onClientRender', root, self._function.loadF10, true, 'low-10')
        end
    end
end

function character.prototype._get(self)
    addEvent('auth.change.client', true)
    addEventHandler('auth.change.client', root, self._function.change)
    addEventHandler('onClientCharacter', root, self._function.write)
    addEvent('auth.character.screen', true)
    addEventHandler('auth.character.screen', root, self._function.display)
    addEvent('auth.char.success', true)
    addEventHandler('auth.char.success', root, self._function.success)
end


function character.prototype:roundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

    function mouse(x, y, w, h, type)
       if isCursorShowing() then
            local cx, cy = getCursorPosition()
			local sx,sy = guiGetScreenSize()
            cx, cy = cx*sx, cy*sy
            if (cx >= x and cx <= x+w and cy >= y and cy <= y+h) then
                if type then
                    exports.cursor:setPointer(type)
                end
                return true
            end
       end
       return false
    end

character = load(character)


local rounded = {};
function roundedDraw(id,x, y, w, h, radius, color, post)
    if not rounded[id] then
        rounded[id] = {}
    end
    if not rounded[id][w] then
        rounded[id][w] = {}
    end
    if not rounded[id][w][h] then
        local path = string.format([[<svg width="%s" height="%s" viewBox="0 0 %s %s" fill="none" xmlns="http://www.w3.org/2000/svg"><rect opacity="1" width="%s" height="%s" rx="%s" fill="#FFFFFF"/></svg>]], w, h, w, h, w, h, radius)
        rounded[id][w][h] = svgCreate(w, h, path)
    end
    if rounded[id][w][h] then
        dxDrawImage(x, y, w, h, rounded[id][w][h], 0, 0, 0, color, (post or false))
    end
end

local sm = {moov = 0, object1 = nil, object2 = nil}

local function removeCamHandler()
    if (sm.moov == 1) then
        sm.moov = 0
    end
end
 
local function camRender()
    if (sm.moov == 1) then
        local x1,y1,z1 = getElementPosition(sm.object1)
        local x2,y2,z2 = getElementPosition(sm.object2)
        setCameraMatrix(x1, y1, z1, x2, y2, z2)
    else
        removeEventHandler("onClientPreRender", root, camRender)
    end
end

 
function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time)
    if (sm.moov == 1) then return false end
    sm.object1 = createObject(1337, x1, y1, z1)
    sm.object2 = createObject(1337, x1t, y1t, z1t)
    setElementCollisionsEnabled(sm.object1, false) 
    setElementCollisionsEnabled(sm.object2, false) 
    setElementAlpha(sm.object1, 0)
    setElementAlpha(sm.object2, 0)
    setObjectScale(sm.object1, 0.01)
    setObjectScale(sm.object2, 0.01)
    moveObject(sm.object1, time, x2, y2, z2, 0, 0, 0, "InOutQuad")
    moveObject(sm.object2, time, x2t, y2t, z2t, 0, 0, 0, "InOutQuad")
    sm.moov = 1
    setTimer(removeCamHandler, time, 1)
    setTimer(destroyElement, time, 1, sm.object1)
    setTimer(destroyElement, time, 1, sm.object2)
    addEventHandler("onClientPreRender", root, camRender)
    return true
end