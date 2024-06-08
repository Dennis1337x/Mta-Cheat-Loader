local mysql = exports.mysql

local kod = "telafi"
local verilcekbakiye = 15
local mesaj = "Tebrikler! Özel Kuponu girdiğin için hediye bakiye 3 Milyon Para kazandınız."


local timers = {}
function kuponKullanmaFonksiyonu(plr, komut, kuponkod)
	 if not kuponkod then
        outputChatBox("[FRP]:#FFFFFF Kupon kodunu yanlış girdin, tekrar dene!",plr,80,80,80,true)
		return 
	end
	if kuponkod ~= kod then
        outputChatBox("[FRP]:#FFFFFF Kupon kodunu yanlış girdin, tekrar dene!",plr,80,80,80,true)
		return 
	end 
	if isTimer(timers[plr]) then 
		outputChatBox("[FRP]:#FFFFFF Bu komutu 1 dakikada bir yazabilirsin!",plr,80,80,80,true)
		return
	end
	timers[plr] = setTimer(function() end,60000,1)
	dbQuery(function(qh,oyuncu)
		local result = dbPoll(qh, 0)[1]
		if  tonumber(result["kupon"] or 0) == 1 then
			outputChatBox("[FRP]:#FFFFFF Bu kuponu sadece bir defa kullanabilirsin!",oyuncu,80,80,80,true)
			return 
		end
		if kuponkod == kod then
			--setElementData(oyuncu, "bakiyeMiktari", tonumber(getElementData(oyuncu, "bakiyeMiktari") or 0) + verilcekbakiye)
			outputChatBox("[FRP]:#FFFFFF "..mesaj,oyuncu,80,80,80,true)
			dbExec(mysql:getConnection(), "UPDATE accounts SET bakiye = bakiye + '"..verilcekbakiye.."' WHERE id = " .. (getElementData(oyuncu, "account:id")))
			exports.global:giveMoney(oyuncu, 3000000)
			dbExec(mysql:getConnection(), "UPDATE characters SET hoursplayed = hoursplayed+5 WHERE id = " .. (getElementData(localPlayer, "dbid")))
			dbExec(mysql:getConnection(), "UPDATE accounts SET kupon = 1 WHERE id = " .. (getElementData(oyuncu, "account:id")))
		end	
		
	end,{plr},mysql:getConnection(),"SELECT `kupon` FROM `accounts` WHERE `id`="..getElementData(plr, "account:id"))	
end
addCommandHandler("kupon", kuponKullanmaFonksiyonu)

addEventHandler("onPlayerQuit",root,function()
	if timers[source] then
		killTimer(timers[source])
		timers[source] = nil
	end
end)

	--local dbid = getElementData(localPlayer, "account:id")
	--exports.orp_global:giveMoney(localPlayer, 31)
	--dbExec(mysql:getConnection(), "UPDATE characters SET hoursplayed = hoursplayed+15 WHERE id = " .. (getElementData(localPlayer, "dbid")))
	--setElementData(localPlayer, "hoursplayed", tonumber(getElementData(localPlayer, "hoursplayed"))+15)