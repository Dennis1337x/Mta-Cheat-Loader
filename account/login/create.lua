local auth = new('AUTH')
local exports = exports
local getKeyState = getKeyState
local getTickCount = getTickCount
local dxDrawText = dxDrawText
local dxDrawRectangle = dxDrawRectangle
local dxDrawCircle = dxDrawCircle
local dxDrawImage = dxDrawImage
local guiGetScreenSize = guiGetScreenSize
local tocolor = tocolor
local triggerEvent = triggerEvent
local triggerServerEvent = triggerServerEvent
local removeEventHandler = removeEventHandler
local addEvent = addEvent
local addEventHandler = addEventHandler
local localPlayer = getLocalPlayer()
local root = getRootElement()

function auth.prototype.____constructor(self)
	--/////////////////////////////////////////////////////////
	self._function = {}
	self._function.load = function(...) self:_load(self) end
    self._function.render = function(...) self:_render(self) end
    self._function.write = function(...) self:_write(self, ...) end
    self._function.success = function(...) self:_success(self, ...) end
    self._function.remember = function(...) self:_remember(self, ...) end
	--/////////////////////////////////////////////////////////
	self.screen = Vector2(guiGetScreenSize())
    self.w, self.h = 250, 25
    self.x, self.y = (self.screen.x-self.w), (self.screen.y-self.h)
    self.font = exports.assets:getFont('in-bold',10)
    self.fonttext = exports.assets:getFont('in-regular',11)
    self.font2 = exports.assets:getFont('in-bold',9)
    self.fontB = exports.assets:getFont('in-regular',10)
    self.fontBB = exports.assets:getFont('in-medium',10)
    self.fontBB2 = exports.assets:getFont('in-bold',15)
    self.loadfont = exports.fonts:getFont('RobotoB',13)
    self.loadfont2 = exports.fonts:getFont('Roboto',11)
    self.awe = exports.assets:getFont('FontAwesome',11)
    self.inbold = exports.assets:getFont('sf-bold',8)
	--/////////////////////////////////////////////////////////
	self:_get(self)
end

function auth.prototype._render(self)   
    if self.alpha < 200 then
        self.alpha = self.alpha + 1
    end

    if self.setalpha == true and self.bcalpha < 200 then
        self.bcalpha = self.bcalpha + 1
    elseif self.bcalpha == 200 and self.setalpha == true then
        self.setalpha = false
    elseif self.bcalpha > 90 and self.setalpha == false then
        self.bcalpha = self.bcalpha - 1
    else
        self.setalpha = true
    end

    
    dxDrawImage(0, 5, self.screen.x, self.screen.y, 'assets/bc.png', 0, 0, 0, tocolor(155, 155, 155, self.bcalpha))
    dxDrawImage(0, 0, self.screen.x, self.screen.y, 'assets/bc.png', 180, 0, 0, tocolor(155, 155, 155, self.bcalpha))
    

    if self.page == 1 then



        roundedDraw("bm", self.screen.x/2-300, self.screen.y-100, 620, 60, 10, tocolor(15,15,15,250))

        if mouse(self.screen.x/2-290, self.screen.y-90, 200, 400, "text") then
            roundedDraw("B3", self.screen.x/2-290, self.screen.y-90, 200, 40, 7, tocolor(20,20, 20,180))
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                self.selected = 'username'
                if self.username == 'kullanıcı adı' then
                    self.username = ''
                end
            end
        else
            roundedDraw("B3", self.screen.x/2-290, self.screen.y-90, 200, 40, 7, tocolor(25,25, 25,180))
        end
        dxDrawText(self.username, self.screen.x/2-247, self.screen.y-80, 250, 40, tocolor(175,175,175,175), 1, self.fonttext)
        dxDrawText("", self.screen.x/2-280, self.screen.y-79, 250, 40, tocolor(175,175,175,175), 1, self.awe)
        
        if self.selected == 'username' then
            self.textSize = dxGetTextWidth(self.username,1,self.fonttext)
            dxDrawText('l', self.screen.x/2-247+(1*self.textSize), self.screen.y-80, nil, nil, tocolor(175, 175, 175, self.textAlpha), 1, self.fontBB)
        end

        if mouse(self.screen.x/2-80, self.screen.y-90, 200, 40, "text") then
            roundedDraw("B5", self.screen.x/2-80, self.screen.y-90, 200, 40, 7, tocolor(20,20,20,180))
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                self.selected = 'password'
                if self.password == 'şifre' then
                    self.password = ''
                end
            end
        else
            roundedDraw("B5", self.screen.x/2-80, self.screen.y-90, 200, 40, 7, tocolor(25,25,25,180))
        end
        dxDrawText("",self.screen.x/2-70, self.screen.y-79, 200, 40, tocolor(175,175,175,175), 1, self.awe)
        dxDrawText(string.gsub(self.password, '.', '*'), self.screen.x/2-45, self.screen.y-76, 200, 40, tocolor(175,175,175,175), 1, self.fonttext)
        if self.selected == 'password' then
            self.textSize = dxGetTextWidth(string.gsub(self.password, '.', '*'),1,self.fonttext)
            dxDrawText('l', self.screen.x/2-45+(1*self.textSize), self.screen.y-78, nil, nil, tocolor(175, 175, 175, self.textAlpha), 1, self.fontBB)
        end

        if mouse(self.screen.x/2+130, self.screen.y-90, 120, 40,"hand") then
            roundedDraw("B21", self.screen.x/2+130, self.screen.y-90, 120, 40, 8, tocolor(20,20, 20,180))
            dxDrawText('giriş yap', self.screen.x/2+163, self.screen.y-80, nil, nil, tocolor(175,175,175,175), 1, self.fontBB)
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                triggerServerEvent('auth.login', localPlayer, self.username, self.password)
            end
        else
            roundedDraw("B21", self.screen.x/2+130, self.screen.y-90, 120, 40, 8, tocolor(25,25,25,180))
            dxDrawText('giriş yap', self.screen.x/2+163, self.screen.y-80, nil, nil, tocolor(175,175,175,175), 1, self.fontBB)
        end

        if mouse(self.screen.x/2+260, self.screen.y-90, 40, 40,"hand") then
            roundedDraw("B21", self.screen.x/2+260, self.screen.y-90, 40, 40, 8, tocolor(20,20,20,180))
            dxDrawText('', self.screen.x/2+270, self.screen.y-80, nil, nil, tocolor(175,175,175,175), 1, self.awe)
            if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                self.click = getTickCount()
                self.page = 2
            end
        else
            roundedDraw("B21", self.screen.x/2+260, self.screen.y-90, 40, 40, 8, tocolor(25,25,25,180))
            dxDrawText('', self.screen.x/2+270, self.screen.y-80, nil, nil, tocolor(175,175,175,175), 1, self.awe)
        end
    else

      --  dxDrawRectangle(0, 0, self.screen.x, self.screen.y, tocolor(0,0,0,200))

        if self.currentRegister < 4 then
            roundedDraw("bm", self.screen.x/2-150, self.screen.y-100, 300, 60, 10, tocolor(15,15,15,250))
            
            roundedDraw("bm", self.screen.x/2+160, self.screen.y-100, 60, 60, 10, tocolor(15,15,15,250))
            roundedDraw("bm", self.screen.x/2+230, self.screen.y-100, 60, 60, 10, tocolor(15,15,15,250))

            if mouse(self.screen.x/2+167.5, self.screen.y-92, 45, 45, 'hand') then
                if getKeyState('mouse1') and self.click+600 <= getTickCount() then
                    self.click = getTickCount()
                    if self.currentRegister < 4 then
                        self.currentRegister = self.currentRegister + 1
                    end
                end
                roundedDraw("bm", self.screen.x/2+167.5, self.screen.y-92, 45, 45, 7, tocolor(20, 20, 20,180))
            else
                roundedDraw("bm", self.screen.x/2+167.5, self.screen.y-92, 45, 45, 7, tocolor(25,25,25,180))
            end
            dxDrawText('>', self.screen.x/2+183, self.screen.y-85, nil, nil, tocolor(180, 180, 180, 180), 1, self.fontBB2)


            if mouse(self.screen.x/2+237.5, self.screen.y-92, 45, 45, 'hand') then
                if getKeyState('mouse1') and self.click +600 <= getTickCount() then
                    self.click = getTickCount()
                    self.page = 1
                end
                roundedDraw("bm", self.screen.x/2+237.5, self.screen.y-92, 45, 45, 7, tocolor(20,20,20,180))
            else
                roundedDraw("bm", self.screen.x/2+237.5, self.screen.y-92, 45, 45, 7, tocolor(25,25,25,180))
            end

            dxDrawText('x', self.screen.x/2+253, self.screen.y-85, nil, nil, tocolor(180, 180, 180, 180), 1, self.fontBB2)
        end

        if self.currentRegister == 1 then
            if mouse(self.screen.x/2-140, self.screen.y-90, 280, 40,"text") then
                roundedDraw("B8", self.screen.x/2-140, self.screen.y-90, 280, 40, 7, tocolor(20,20, 20,180))
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.selected = 'username'
                    if self.username == 'kullanıcı adı' then
                        self.username = ''
                    end
                end
            else
                roundedDraw("B8", self.screen.x/2-140, self.screen.y-90, 280, 40, 7, tocolor(25,25,25,180))
            end

            dxDrawText(self.username, self.screen.x/2-90, self.screen.y-80, nil, nil, tocolor(175,175,175,175), 1, self.fonttext)
            dxDrawText("",self.screen.x/2-125, self.screen.y-80, 280, 40, tocolor(175,175,175,175), 1, self.awe)
            dxDrawText("bir kullanıcı adı belirle", 0, 0, self.screen.x, self.screen.y-120, tocolor(180,180,180, self.alpha), 1, self.fontBB2, 'center', 'bottom')
        elseif self.currentRegister == 2 then

            if mouse(self.screen.x/2-140, self.screen.y-90, 280, 40,"text") then
                roundedDraw("B9", self.screen.x/2-140, self.screen.y-90, 280, 40, 7, tocolor(20,20, 20,180))
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.selected = 'password'
                    if self.password == 'şifre' then
                        self.password = ''
                    end
                end
            else
                roundedDraw("B10", self.screen.x/2-140, self.screen.y-90, 280, 40, 7, tocolor(25,25,25,180))
            end
            dxDrawText(string.gsub(self.password, '.', '*'), self.screen.x/2-95, self.screen.y-77, nil, nil, tocolor(175,175,175,175), 1, self.fonttext)
            dxDrawText("şifreni oluştur", 0, 0, self.screen.x, self.screen.y-120, tocolor(180,180,180, self.alpha), 1, self.fontBB2, 'center', 'bottom')
            dxDrawText("",self.screen.x/2-125, self.screen.y-80, 280, 40, tocolor(175,175,175,175), 1, self.awe)

        elseif self.currentRegister == 3 then 
            if mouse(self.screen.x/2-140, self.screen.y-90, 280, 40,"text") then
                roundedDraw("B9", self.screen.x/2-140, self.screen.y-90, 280, 40, 7, tocolor(20,20, 20,180))
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.selected = 'email'
                    if self.email == 'packagev2@gmail.com' then
                        self.email = ''
                    end
                end
            else
                roundedDraw("B10", self.screen.x/2-140, self.screen.y-90, 280, 40, 7, tocolor(25,25,25,180))            end
            dxDrawText("e-posta adresini gir", 0, 0, self.screen.x, self.screen.y-120, tocolor(180,180,180, self.alpha), 1, self.fontBB2, 'center', 'bottom')
            dxDrawText(self.email, self.screen.x/2-90, self.screen.y-80, nil, nil, tocolor(175,175,175,175), 1, self.fonttext)
            dxDrawText("",self.screen.x/2-125, self.screen.y-80, nil, nil, tocolor(175,175,175,175), 1, self.awe)


        elseif self.currentRegister == 4 then
            roundedDraw('BT265', self.screen.x/2-300, self.screen.y/2-350, 600, 700, 12, tocolor(15, 15, 15, 245))
            dxDrawText('Hizmet Şartları', self.screen.x/2-270, self.screen.y/2-320, nil, nil, tocolor(200, 200, 200, 220), 1, self.fontBB2)

            dxDrawText('Sunucu içi uyulması gereken kurallar;\n\nMaske Takma: Toplu alanlarda, kalabalık ortamlarda ve sosyal mesafeyi korumak\nolduğunda maske takmak zorunludur.Sosyal Mesafe: En az 1-2 metrelik bir zor\nmesafeyle başkalarıyla temas etmekten kaçının.\nElleri Sık Sık Yıkama: Elleri sık sık en az 20 saniye boyunca sabun ve suyla yıkamak\nvirüsün yayılmasını engeller.\nDezenfektan Kullanımı: Ellerin yıkanmasının mümkün olmadığı durumlarda, alkol bazlı\nel dezenfektanı kullanmak önemlidir.\nKalabalıklardan Kaçınma: Mümkün olduğunca kalabalık yerlerden kaçının ve sosyal\netkinliklere katılmaktan kaçının.\nEvde Kalma: Mümkün olduğunca evde kalın ve dışarıya sadece zorunlu durumlar için\nçıkın.Hapşırma ve Öksürme Etiketi: El, kol veya mendil ile ağzınızı ve burnunuzu\nkapatarak hapşırın veya öksürün.Hastalık Belirtileri Var İse Evde Kalma: COVID-19\nbelirtileri (ateş, öksürük, nefes darlığı) varsa evde kalın ve sağlık hizmeti sağlayıcınızı\narayın.Dışarıdayken Yüz Dokunmadan Kaçınma: Ellerle yüzünüze dokunmaktan\nkaçının, özellikle de dışarıdayken.İzolasyon Kurallarına\nUyma: COVID-19 teşhisi konmuş veya semptomlarınız varsa, sağlık kurallarına ve\nizolasyon talimatlarına uyun.\n\nSunucu dışı kurallar (OOC)\n\nİş Yeri Güvenliği: İş yerlerinde uygun temizlik ve hijyen önlemlerini uygulamak\nçalışanların güvenliğini sağlar.\n\nDışarıdan Paket Alırken Dikkat: Dışarıdan alınan paketleri teslim alırken\neldiven kullanmak veya paketleri dezenfekte etmek önemlidir.\n\nToplu Taşıma Kuralları: Toplu taşıma kullanırken maske takmak ve sosyal\nmesafeyi korumak önemlidir.\n\nAçık Alanlarda Aktiviteler: Egzersiz ve dinlenme ihtiyacınızı karşılamak için dışarıda\nkalabalıklardan uzak, açık alanlarda zaman geçirin.', self.screen.x/2-270, self.screen.y/2-280, nil, nil, tocolor(200, 200, 200, 180), 1, self.fontBB)
            
            if mouse(self.screen.x/2-270, self.screen.y/2+300, 540, 28, "hand") then
                roundedDraw("B30", self.screen.x/2-270, self.screen.y/2+300, 540, 28, 7, tocolor(20,20,20,180))
                dxDrawText("Hizmet Şartları ve Gizlilik Politikası'nı okudum ve kabul ediyorum kayıt ol.", self.screen.x/2-240, self.screen.y/2+305, nil, nil, tocolor(175,175,175,175), 1, self.fontBB)
                if getKeyState('mouse1') and self.click+400 <= getTickCount() then
                    self.click = getTickCount()
                    self.currentRegister = 1
                    self.page = 1
                    triggerServerEvent('auth.register', localPlayer, self.username, self.password,self.email)
                end
            else
                roundedDraw("B30", self.screen.x/2-270, self.screen.y/2+300, 540, 28, 7, tocolor(25,25,25,180))
                dxDrawText("Hizmet Şartları ve Gizlilik Politikası'nı okudum ve kabul ediyorum kayıt ol.", self.screen.x/2-240, self.screen.y/2+305, nil, nil, tocolor(175,175,175,175), 1, self.fontBB)
            end

        end



    end
    if getKeyState('backspace') and self.click+50 <= getTickCount() then
        self.click = getTickCount()
        if self.selected == 'username' then
            self.fistPart = self.username:sub(0, self.charUsername-1)
            self.lastPart = self.username:sub(self.charUsername+1, #self.username)
            self.username = self.fistPart..self.lastPart
            self.charUsername = string.len(self.username)
        elseif self.selected == 'password' then
            self.fistPart = self.password:sub(0, self.charPassword-1)
            self.lastPart = self.password:sub(self.charPassword+1, #self.password)
            self.password = self.fistPart..self.lastPart
            self.charPassword = string.len(self.password)
        elseif self.selected == 'email' then
            self.fistPart = self.email:sub(0, self.charEmail-1)
            self.lastPart = self.email:sub(self.charEmail+1, #self.email)
            self.email = self.fistPart..self.lastPart
            self.charEmail = string.len(self.email)
        end
    end
end

function auth.prototype._login(self)
    self.selected = ''
    --exports.blur:destroyBlurBox(self.blur)
    --self.blur = nil
    if isTimer(self.timer) then
        killTimer(self.timer)
    end
    removeEventHandler('onClientRender', root, self._function.render)
    triggerServerEvent('auth.character', localPlayer)
end

function auth.prototype:_success(self, state)
    if state == 'login' then
        self:_login(self)
    elseif state == 'register' then
        self.page = 1
    end
end

function auth.prototype:_remember(self, username, password)
    if username and password then
        self.username = ''..username..''
        self.password = ''..password..''
        self.charUsername = string.len(self.username)+1
        self.charPassword = string.len(self.password)+1
    else
        self.username = 'kullanıcı adı'
        self.password = 'şifre'
        self.charUsername = string.len(self.username)+1
        self.charPassword = string.len(self.password)+1
    end
end

function auth.prototype:_write(self, char)
    --if self.selected then
        if self.selected == 'username' then
            if self.click+1 <= getTickCount() then
                self.click = getTickCount()
                if string.len(self.username) <= 15 then
                    self.username = ''..self.username..''..char
                    self.charUsername = string.len(self.username)+1
                    Sound("assets/key.mp3")
                end
            end
        elseif self.selected == 'password' then
            if self.click+1 <= getTickCount() then
                self.click = getTickCount()
                if string.len(self.password) <= 15 then
                    self.password = ''..self.password..''..char
                    self.charPassword = string.len(self.password)+1
                    Sound("assets/key.mp3")
                end
            end
        elseif self.selected == 'email' then
            if self.click+1 <= getTickCount() then
                self.click = getTickCount()
                if string.len(self.email) <= 25 then
                    self.email = ''..self.email..''..char
                    self.charEmail = string.len(self.email)+1
                    Sound("assets/key.mp3")
                end
            end
        end
   -- end
end

function auth.prototype._stop(self)
    self.alpha = 75
    self.page = 1
    self.loadstate = false
    self.timer = Timer(function()
        if self.textAlpha == 0 then
            self.textAlpha = 175
        else
            self.textAlpha = 0
        end
    end, 700, 0)
    self.click = 0
    self.selected = nil
    self.username = 'kullanıcı adı'
    self.password = 'şifre'
    self.email = 'packagev2@gmail.com'
    triggerServerEvent('auth.remember', localPlayer)
    addEventHandler('onClientRender', root, self._function.render, true, 'low-10')
    removeEventHandler('onClientRender', root, self._function.load)
end

function auth.prototype._load(self)
    if self.rot < 1000 then 
        self.rot = self.rot + 50
    end 

    if self.alpha < 200 then
	self.alpha = self.alpha + 0.15
    end
    --dxDrawImage(0, 0, self.screen.x, self.screen.y, 'assets/bg.png', 0, 0, 0, tocolor(255,255,255,255))     
    dxDrawRectangle(0, 0, self.screen.x, self.screen.y, tocolor(7,7,7,255-self.alpha))
	--dxDrawImage(self.screen.x/2-35, self.screen.y/2-140, 100, 100, 'assets/logo.png', 0, 0, 0, tocolor(200, 200, 200))
    if self.rot < 200 then 
        dxDrawText("Vintage Roleplay'e hoş geldin!", 0, 0, self.screen.x, self.screen.y, tocolor(175, 175, 175, 200), 1, self.loadfont, "center", "center", false, false, false, true, false)
    else
        dxDrawText("Bilgilerini doldur ve sunucuya katıl.", 0, 0, self.screen.x, self.screen.y, tocolor(175, 175, 175, 200), 1, self.loadfont, "center", "center", false, false, false, true, false)
    end

    if self.rot >= 400 then
        if self.loadstate then else
            self:_stop(self)
            self.loadstate = true
        end
    end
end

function auth.prototype._display(self)
    Camera.fade(true)
    song = Sound('assets/music.mp3')
    showChat(false)
    showCursor(true)
    self.click = 0
    self.loadstate = false
	self.rot = 0
    self.alpha = 0
    self.currentRegister = 1
    self.setalpha = true
    self.bcalpha = 100
    --self.blur = exports.blur:createBlurBox(0,0,self.screen.x,self.screen.y,175,175,175,255,false)
    localPlayer.dimension = math.random(1, 9999)
    localPlayer.interior = 0
    Camera.setMatrix(1512.884765625,-858.70703125,74.490432739258,1422.3406982422,-817.61083984375,85.114837646484)
	addEventHandler('onClientRender', root, self._function.load, true, 'low-10')
end

function auth.prototype._get(self)
	Engine.setAsynchronousLoading(true, true)
    setFarClipDistance(5000)
    setFogDistance(5000)
    for i = 1, 10000 do 
        engineSetModelLODDistance(i, 1000) 
    end 
    isWorldSpecialPropertyEnabled('extraairresistance', false)
    setAmbientSoundEnabled( 'gunfire', false )
    setDevelopmentMode(false)
    setPedTargetingMarkerEnabled(false)
    toggleControl("radar", false)
    guiSetInputMode('no_binds_when_editing')
    local components = { 'weapon', 'ammo', 'health', 'vehicle_name', 'area_name', 'radar', 'clock', 'money', 'breath', 'armour', 'wanted'}
    for index, value in ipairs(components) do
        setPlayerHudComponentVisible(value, false)
    end
    addEvent('auth.success', true)
    addEventHandler('auth.success', root, self._function.success)
    addEvent('auth.remember.client', true)
    addEventHandler('auth.remember.client', root, self._function.remember)
    addEventHandler('onClientCharacter', root, self._function.write)
    if localPlayer:getData('loggedin') == 1 then else self:_display() end
end

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

auth = load(auth)