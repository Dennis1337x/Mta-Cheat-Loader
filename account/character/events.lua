local mysql = exports.mysql

addEvent('auth.save', true)
addEventHandler('auth.save', root, function()
    if source then
        local x, y, z = source.position.x, source.position.y, source.position.z
		local int, dim = source.interior, source.dimension
		local hunger = source:getData('hunger') or 100
		local thirst = source:getData('thirst') or 100
		dbExec(mysql:getConn(), "UPDATE `characters` SET `hunger`='" .. hunger .. "', `thirst`='" .. thirst .. "' WHERE `id`='".. source:getData('dbid') .."'")
		dbExec(mysql:getConn(), "UPDATE `characters` SET `x`='" .. x .. "', `y`='" .. y .. "', `z`='" .. z .. "' WHERE `id`='".. source:getData('dbid') .."'")
		dbExec(mysql:getConn(), "UPDATE `characters` SET `interior_id`='" .. int .. "', `dimension_id`='" .. dim .. "' WHERE `id`='".. source:getData('dbid') .."'")
		source.interior = 0
	    source.dimension = 0
	    source.cameraInterior = 0
    end
end)

addEvent('auth.character', true)
addEventHandler('auth.character', root, function()
    if source then
    	triggerClientEvent(source, 'auth.character.screen', source)
    end
end)

addEvent('auth.spawn', true)
addEventHandler('auth.spawn', root, function(sqlID)
    if source and tonumber(sqlID) then
        dbQuery(
			function(qh, player)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						local characterID = row['id']
						if row['description'] then
							player:setData('look', fromJSON(row['description'])  or {'', '', '', '', row['description'], ''})
						end
						player:setData('weight', row['weight'])
						player:setData('height', row['height'])
						player:setData('race', tonumber(row['skincolor']))
						player:setData('maxvehicles', tonumber(row['maxvehicles']))
						player:setData('maxinteriors', tonumber(row['maxinteriors']))
						player:setData('age', tonumber(row['age']))
						player:setData('month', tonumber(row['month']))
						player:setData('day', tonumber(row['day']))
						local lang1 = tonumber(row['lang1'])
						local lang1skill = tonumber(row['lang1skill'])
						local lang2 = tonumber(row['lang2'])
						local lang2skill = tonumber(row['lang2skill'])
						local lang3 = tonumber(row['lang3'])
						local lang3skill = tonumber(row['lang3skill'])
						local currentLanguage = tonumber(row['currlang']) or 1
						player:setData('languages.current', currentLanguage, false)
						if lang1 == 0 then
							lang1skill = 0
						end
						if lang2 == 0 then
							lang2skill = 0
						end
						if lang3 == 0 then
							lang3skill = 0
						end
						player:setData('languages.lang1', lang1, false)
						player:setData('languages.lang1skill', lang1skill, false)

						player:setData('languages.lang2', lang2, false)
						player:setData('languages.lang2skill', lang2skill, false)

						player:setData('languages.lang3', lang3, false)
						player:setData('languages.lang3skill', lang3skill, false)

						player:setData('timeinserver', tonumber(row['timeinserver']), false)
						player:setData('account:character:id', tonumber(row['id']), false)
						player:setData('dbid', tonumber(row['id']), false)
						exports['items']:loadItems(player, true)
						player:setData('loggedin', 1, true)
						player:setData('bleeding', 0, false)
						player:setData('legitnamechange', 1)
						player.name = tostring(row['charactername'])
						player.alpha = 255
						player:setData('legitnamechange', 0)

						player:spawn(row['x'], row['y'], row['z'], row['rotation'], tonumber(row['skin']), row['interior_id'], row['dimension_id'])
						player.interior = row['interior_id']
						player.dimension = row['dimension_id']
                    	player.cameraInterior = row['interior_id']
                    	player.cameraTarget = player
                    	player.nametagShowing = false
                    	player.gravity = 0.008
						exports['items']:loadItems(player)
                    	player.health = tonumber(row['health'])
                    	player.armor = tonumber(row['armor'])
	                    local teamElement = nil
	                    if (tonumber(row["faction_id"])~=-1) then
	                        teamElement = exports.pool:getElement('team', tonumber(row["faction_id"]))
	                        if not (teamElement) then
	                            row["faction_id"] = -1
	                            dbExec(mysql:getConn(), "UPDATE characters SET faction_id='-1', faction_rank='1' WHERE id='"..tostring(characterID).."' LIMIT 1")
	                        end
	                    end
	                    if teamElement then
	                        player:setTeam(teamElement)
	                    else
	                        player:setTeam(getTeamFromName("Citizen"))
	                    end
	                    player:setData("faction", tonumber(row["faction_id"]))
	                    factionPerks = type(row["faction_perks"]) == "string" and fromJSON(row["faction_perks"]) or { }
	                    player:setData("factionPackages", factionPerks)
	                    player:setData("factionrank", tonumber(row["faction_rank"]))
	                    player:setData("factionphone", tonumber(row["faction_phone"]))
	                    player:setData("factionleader", tonumber(row["faction_leader"]))
	                    player:setData("businessprofit", 0)
	                    player:setData("legitnamechange", 0)
	                    player:setData("muted", tonumber(muted))
	                    player:setData("minutesPlayed",  tonumber(row["minutesPlayed"]))
	                    player:setData("hoursplayed",  tonumber(row["hoursplayed"]))
	                    player:setData("alcohollevel", tonumber(row["alcohollevel"]) or 0)
	                    player:setData("restrain", tonumber(row["cuffed"]))
	                    player:setData("tazed", false)
	                    player:setData("realinvehicle", 0)
	                    player:setData("duty", row["duty"])
	                    duty = row["duty"]
	                    if duty > 0 then
	                        local foundPackage = false
	                        for key, value in ipairs(factionPerks) do
	                            if tonumber(value) == tonumber(duty) then
	                                foundPackage = true
	                                break
	                            end
	                        end
	                        
	                        if not foundPackage then
	                            triggerEvent("duty:offduty", client)
	                            outputChatBox("", client, 255, 0, 0)
	                        end
	                    end
	                    triggerEvent("social:character", player)
						player:setData('job', tonumber(row['job']) or 0, true)
	                    player:setData("license.car", tonumber(row["car_license"]))
	                    player:setData("license.bike", tonumber(row["bike_license"]))
	                    player:setData("license.boat", tonumber(row["boat_license"]))
	                    player:setData("license.pilot", tonumber(row["pilot_license"]))
	                    player:setData("license.fish", tonumber(row["fish_license"]))
	                    player:setData("license.gun", tonumber(row["gun_license"]))
	                    player:setData("license.gun2", tonumber(row["gun2_license"]))
	                    player:setData("bankmoney", tonumber(row["bankmoney"]))
	                    player:setData("fingerprint", tostring(row["fingerprint"]))
	                    player:setData("tag", tonumber(row["tag"]))
	                    player:setData("tag2", tonumber(row["tag2"]) or 0)
	                    player:setData("blindfold", tonumber(row["blindfold"]))
	                    player:setData("gender", tonumber(row["gender"]))
	                    player:setData("deaglemode", 1)
						player:setData("vintageclass", true)
						player:setData("modern", true)
						player:setData("barli", true)
	                    player:setData("shotgunmode", 1)
	                    player:setData("firemode", 0)
	                    player:setData("hunger", 100)
	                    player:setData("thirst", 100)
	                    player:setData("level", tonumber(row["level"]))
	                    player:setData('hoursaim', tonumber(row['hoursaim']), true)
	                    player:setData("youtuber", tonumber(row["youtuber"]), true)
	                    player:setData("rplus", tonumber(row["rplus"]), true)
	                    player:setData("tag", tonumber(row["tag"]), true)
	                    player:setData("donator", tonumber(row["donator"]), true)
	                    player:setData("country", tonumber(row["country"]), true)
	                    player:setData("jail_time", tonumber(row["jail_time"]), true)
	                    player:setData("jail_reason", row["jail_reason"], true)
	                    player:setData("mechanic", tonumber(row["mechanic"]))
	                    player:setData('vipver', 0)
	                    local resource = getResourceFromName('vip')
	                    if resource then
	                    local state = getResourceState(resource)
	                        if state == 'running' then
	                            player:setData('vipver', 0)
	                            exports['vip']:loadVIP(characterID)
	                        end
	                    end
	                    player:setData("clothing:id", tonumber(row["clothingid"]) or nil)
	                    takeAllWeapons(player)
	                    if (getElementType(player) == 'player') then
	                        triggerEvent("updateLocalGuns", player)
	                    end
	                    if (tonumber(row["cuffed"])==1) then
	                        toggleControl(player, "sprint", false)
	                        toggleControl(player, "fire", false)
	                        toggleControl(player, "jump", false)
	                        toggleControl(player, "next_weapon", false)
	                        toggleControl(player, "previous_weapon", false)
	                        toggleControl(player, "accelerate", false)
	                        toggleControl(player, "brake_reverse", false)
	                        toggleControl(player, "aim_weapon", false)
	                    end
	                    if (tonumber(row['blindfold'])==1) then
							player:setData('blindfold', 1)
							fadeCamera(player, false)
						else
							fadeCamera(player, true, 4)
						end
	                    setPedFightingStyle(player, tonumber(row["fightstyle"]))     
	                    triggerEvent("onCharacterLogin", player, charname, tonumber(row["faction_id"]))
	                    triggerEvent("realism:applyWalkingStyle", player, row["walkingstyle"] or 128, true)
						setPedStat(player, 70, 999)
						setPedStat(player, 71, 999)
						setPedStat(player, 72, 999)
						setPedStat(player, 74, 999)
						setPedStat(player, 76, 999)
						setPedStat(player, 77, 999)
						setPedStat(player, 78, 999)
						setPedStat(player, 77, 999)
						setPedStat(player, 78, 999)
						setPedStat(player, 79, 999)
	                    toggleAllControls(player, true, true, true)
	                    triggerClientEvent(player, "onClientPlayerWeaponCheck", player)
	                    player.frozen = false
	                    local jailed = player:getData("adminjailed")
	                    local jailed_time = player:getData("jailtime")
	                    local jailed_by = player:getData("jailadmin")
	                    local jailed_reason = player:getData("jailreason")
	                    if jailed then
	                        local incVal = player:getData("playerid")
	                        player.dimension = 55000+incVal
	                        player.interior = 6
	                        player.cameraInterior = 6
	                        player.position = 263.821807, 77.848365, 1001.0390625
	                        player.rotation = 0, 0, 267.438446
	                                                
	                        player:setData("jailserved", 0)
	                        player:setData("adminjailed", true)
	                        player:setData("jailreason", jailed_reason)
	                        player:setData("jailadmin", jailed_by)
	                        
	                    	if jailed_time ~= 999 then
	                            if not player:getData("jailtimer") then
	                                player:setData("jailtime", jailed_time+1)
	                                triggerEvent("admin:timerUnjailPlayer", player, player)
	                            end
	                        else
	                            player:setData("jailtime", "Unlimited")
	                            player:setData("jailtimer", true)
	                        end

	                        player.interior = 6
	                        player.cameraInterior = 6
	                    elseif tonumber(row["pdjail"]) == 1 then
	                        player:setData("jailed", 1)
	                        exports["prison"]:checkForRelease(player)
	                    end
	                    exports.global:updateNametagColor(player)
	                    triggerClientEvent(player, "drawAllMyInteriorBlips", player)
	                    triggerEvent("accounts:character:select", player)
	                    exports.global:setMoney(player, tonumber(row["money"]), true)
	                    exports.global:checkMoneyHacks(player)
	                    exports['items']:loadItems(player, true)
	                    exports.global:updateNametagColor(player)
						outputChatBox("★ #d0d0d0Tekrardan hoş geldin, seni burada görmek harika.", player,  147, 67, 156, true)
	                    setElementAlpha(player, 255)
	                    Timer(function(thePlayer,cash)
	                    	local getIts = exports['items']:getItems(thePlayer)
							for index, value in ipairs(getIts) do
								if value[1] == 134 then
									exports.global:takeItem(thePlayer, 134)
								end
							end
							exports.global:giveItem(thePlayer, 134, tonumber(cash))
	                    end, 2000, 1, player, tonumber(row['money']), true)
					end
				end
			end,
        {source}, mysql:getConn(), "SELECT * FROM characters WHERE id = ?", sqlID)
    end
end)

addEvent('auth.char.create', true)
addEventHandler('auth.char.create', root, function(name, age, weight, height, country, model, gender)
	if source and name and tonumber(age) and tonumber(weight) and tonumber(height) and tonumber(country) and tonumber(model) and tonumber(gender) then
		if name == 'ad_soyad' then triggerClientEvent(source, 'auth.info', source, 'Lütfen geçerli bir isim girin!') return false end
		if tonumber(age) < 18 then triggerClientEvent(source, 'auth.info', source, 'yaşınız 18 ve üzeri olmalı.') return false end
		if tonumber(weight) > 100 or tonumber(weight) < 30 then triggerClientEvent(source, 'auth.info', source, 'karakteriniz bu kadar kilolu olamaz.') return false end
		if tonumber(height) > 200 or tonumber(height) < 150 then triggerClientEvent(source, 'auth.info', source, 'karakteriniz bu kadar uzun olamaz.') return false end
		
		if not (#source:getData('account:characters') >= source:getData('account:charLimit')) then
			local charname = string.gsub(tostring(name), " ", "_")
			source:setData('legitnamechange', 1)
			local successName = source:setName(charname)
        	if (successName) then
        		source:setData('legitnamechange', 0)
        		dbQuery(
                    function(qh, source)
                        local res, rows, err = dbPoll(qh, 0)
                        if rows > 0 then
                            triggerClientEvent(source, 'auth.info', source, 'seçtiğiniz karakter ismi kullanıldığı için işlem iptal edildi.')
                        else
                            local walkingstyle = 128
                            if gender == 0 then
                                walkingstyle = 128
                            elseif gender == 1 then
                                walkingstyle = 131
                            end
                            local height = ''..height..''
                            local accountID = source:getData('account:id')
                            local fingerprint = md5((name) .. accountID .. gender .. age)
                            local x, y, z = 1307.1611328125, -862.7451171875, 39.578125
                            dbExec(mysql:getConn(), "INSERT INTO `characters` SET `charactername`='" .. (charname).. "', `x`='"..x.."', `y`='"..y.."', `z`='"..z.."', `rotation`='0', `interior_id`='0', `dimension_id`='0', `gender`='" .. (gender) .. "', `weight`='" .. (weight) .. "', `height`='" .. (height) .. "', `description`='', `account`='" .. (accountID) .. "', `skin`='" .. (model) .. "', `age`='" .. (age) .. "', `country`='" .. (tonumber(country)) .. "', `fingerprint`='" .. (fingerprint) .. "', `lang1`='1', `lang1skill`='100', `currLang`='1' , `month`='" .. (month or "1") .. "', `day`='" .. (day or "1").."', `walkingstyle`='" .. (walkingstyle).."'")
                            dbQuery(
                                function(qh, source)
                                    local res, rows, err = dbPoll(qh, 0)
                                    if rows > 0 then 
                                        for index, row in ipairs(res) do
                                            dbExec(mysql:getConn(), "INSERT INTO `items` SET `type`='1', `owner`='"..row["id"].."', `itemID`='160', `itemValue`='1', `protected`='0'")
                                            dbExec(mysql:getConn(), "INSERT INTO `items` SET `type`='1', `owner`='"..row["id"].."', `itemID`='16', `itemValue`='"..model.."', `protected`='0'")
                                            dbExec(mysql:getConn(), "INSERT INTO `items` SET `type`='1', `owner`='"..row["id"].."', `itemID`='152', `itemValue`='"..charname..";"..gender..":"..age..":fingerprint', `protected`='0'")
                                        end
                                    end
                                end,
                            {source}, mysql:getConn(), "SELECT * FROM characters WHERE charactername = ?", charname)
                            local characters = {}
                            dbQuery(
                                function(qh, player)
                                    local res, rows, err = dbPoll(qh, 0)
                                    if rows > 0 then
                                        for index, value in ipairs(res) do
                                            local i = #characters + 1
                                            if not characters[i] then
                                                characters[i] = {}
                                            end
                                            characters[i][1] = value.id
                                            characters[i][2] = value.charactername
                                            characters[i][3] = tonumber(value.cked)
                                            characters[i][4] = tonumber(value.money)
                                            characters[i][5] = tonumber(value.hoursplayed)
                                            characters[i][6] = tonumber(value.skin)
                                            characters[i][7] = tonumber(value.x)
                                            characters[i][8] = tonumber(value.y)
                                            characters[i][9] = tonumber(value.z)
                                            characters[i][10] = tonumber(value.gender)
                                        end
                                    end
                                    player:setData('account:characters', characters)
                                end,
                            {source}, mysql:getConn(), "SELECT * FROM characters WHERE account = ?", accountID)
                            triggerClientEvent(source, 'auth.char.success', source)
                        end
                    end,
                {source}, mysql:getConn(), "SELECT * FROM characters WHERE charactername = ?", charname)
        	else
        		source:setData('legitnamechange', 0)
        		triggerClientEvent(source, 'auth.info', source, 'isminizde özel karakter tespit edildi.')
        	end
		else
			triggerClientEvent(source, 'auth.info', source, 'yeterli karakter limitiniz bulunmamaktadır.')
		end
	end
end)