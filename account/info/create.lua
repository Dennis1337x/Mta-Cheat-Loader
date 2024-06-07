local info = new('INFO')

function info.prototype.____constructor(self)
	--/////////////////////////////////////////////////////////
	self._function = {}
	self._function.display = function(...) self:_display(self, ...) end
	self._function.stop = function(...) self:_stop(self) end
	self._function.render = function(...) self:_render(self) end
	--/////////////////////////////////////////////////////////
	self.screen = Vector2(guiGetScreenSize())
    self.w, self.h = 250, 25
    self.x, self.y = (self.screen.x-self.w), (self.screen.y-self.h)
    self.font = exports.fonts:getFont('RobotoB',11)
	--/////////////////////////////////////////////////////////
	self:_get(self)
end

function info.prototype._render(self)
	if self.addY <= 30 then
		self.addY = self.addY + 5
	end
	self.textsize = dxGetTextWidth(self.text,1,self.font)
	dxDrawText(self.text, self.x/2+50+1-self.textsize/3, 0+self.addY, nil, nil, tocolor(0,0,0,200), 1, self.font)
	dxDrawText(self.text, self.x/2+50+1-self.textsize/3, 0+self.addY+1, nil, nil, tocolor(0,0,0,200), 1, self.font)
	dxDrawText(self.text, self.x/2+50-1-self.textsize/3, 0+self.addY, nil, nil, tocolor(0,0,0,200), 1, self.font)
	dxDrawText(self.text, self.x/2+50+1-self.textsize/3, 0+self.addY-1, nil, nil, tocolor(0,0,0,200), 1, self.font)
	dxDrawText(self.text, self.x/2+50-self.textsize/3, 0+self.addY, nil, nil, tocolor(175,175,175,200), 1, self.font)
end

function info.prototype:_display(self, text)
	self.addY = 0
	self.text = text
	if isTimer(self.timer) then
		killTimer(self.timer)
	end
	self.timer = Timer(self._function.stop, 2500, 1)
	addEventHandler('onClientRender', root, self._function.render, true, 'low-10')
end

function info.prototype._stop(self)
	self.text = ''
	self.addY = 0
	removeEventHandler('onClientRender', root, self._function.render)
end

function info.prototype._get(self)
	addEvent('auth.info', true)
	addEventHandler('auth.info', root, self._function.display)
end

info = load(info)