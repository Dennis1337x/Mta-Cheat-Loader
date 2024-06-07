local mysql = exports.mysql

addEventHandler('onPlayerJoin', getRootElement(), function()
    setWaveHeight(0)
    setGameType('update roleplay pack')
    setMapName('MAP')
    setRuleValue('Sürüm', 'v1')
    setRuleValue('Geliştiriciler', 'clarosep')
    if source:getData('loggedin') ~= 1 then 
        source:setData('loggedin', 0)
        source:setData('account:loggedin', false)
        source:setData('account:username', '')
        source:setData('account:id', '')
        source:setData('dbid', false)
        source:setData('admin_level', 0)
        source:setData('hiddenadmin', 0)
        source:setData('globalooc', 1)
        source:setData('muted', 0)
        source:setData('loginattempts', 0)
        source:setData('timeinserver', 0)
        source:setData('chatbubbles', 0)
    end
    exports.global:updateNametagColor(source)
end)

addEventHandler('onPlayerChangeNick', root, function(oldNick, newNick)
    if source:getData('legitnamechange') == 0 then
        cancelEvent()
        source.name = tostring(oldNick)
    end
end)

addEventHandler("onPlayerCommand", root, function(command)
    if source:getData('loggedin') == 1 then else return false end
end)

addEvent('auth.remember', true)
addEventHandler('auth.remember', root, function()
    dbQuery(
            function(qh, player)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        triggerClientEvent(player, 'auth.remember.client', player, row['username'], row['password'])
                    end
                end
            end,
    {source}, mysql:getConn(), "SELECT * FROM accounts WHERE mtaserial = ?", source.serial)
end)

addEvent('auth.login', true)
addEventHandler('auth.login', root, function(username, password)
    if source and username and password then
        if username == 'kullanıcı adı' then triggerClientEvent(source, 'auth.info', source, 'Lütfen geçerli bir kullanıcı adı girin!') return false end
        if password == 'şifre' then triggerClientEvent(source, 'auth.info', source, 'Lütfen geçerli bir şifre girin!') return false end
        dbQuery(
            function(qh, source)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        if row['password'] == password and row['mtaserial'] == getPlayerSerial(source) then
                            for index, value in ipairs(Element.getAllByType('player')) do
                                if value:getData('account:id') == tonumber(row["id"]) then
                                    triggerClientEvent(source, 'auth.info', source, 'Bu hesap şuanda zaten oyunda.')
                                    return false
                                end
                            end
                            source:setData("account:loggedin", true)
                            source:setData("account:id", tonumber(row["id"]))
                            source:setData("account:username", row["username"])
                            source:setData("account:charLimit", tonumber(row["characterlimit"]))
                            source:setData("electionsvoted", row["electionsvoted"])
                            source:setData("account:email", row["email"])
                            source:setData("account:creationdate", row["registerdate"])
                            source:setData("account:email", row["email"])
                            source:setData("credits", tonumber(row["credits"]))
                            source:setData("admin_level", tonumber(row['admin']))
                            source:setData("supporter_level", tonumber(row['supporter']))
                            source:setData("vct_level", tonumber(row['vct']))
                            source:setData("mapper_level", tonumber(row['mapper']))
                            source:setData("scripter_level", tonumber(row['scripter']))
                            source:setData("adminreports", tonumber(row["adminreports"]))
                            source:setData("adminreports_saved", tonumber(row["adminreports_saved"]))
                            if tonumber(row['referrer']) and tonumber(row['referrer']) > 0 then
                                source:setData("referrer", tonumber(row['referrer']))
                            end
                            if exports.integration:isPlayerLeadAdmin(source) then
                                source:setData("hiddenadmin", row["hiddenadmin"])
                            else
                                source:setData("hiddenadmin", 0)
                            end
                            local vehicleConsultationTeam = exports.integration:isPlayerVehicleConsultant(source)
                            source:setData("vehicleConsultationTeam", vehicleConsultationTeam)
                            if tonumber(row["adminjail"]) == 1 then
                                source:setData("adminjailed", true)
                            else
                                source:setData("adminjailed", false)
                            end
                            source:setData("jailtime", tonumber(row["adminjail_time"]))
                            source:setData("jailadmin", row["adminjail_by"])
                            source:setData("jailreason", row["adminjail_reason"])
                            source:setData("balance", row["balance"])
                            source:setData("uyk", tonumber(row["uyk"]))
                            local tables = row["custom_animations"]
                            --if type(fromJSON(tables)) ~= "table" then tables = toJSON ( { } ) end
                            local anims = fromJSON(tables or toJSON ( { } ))
                            table.insert(anims, block)
                            source:setData('custom_animations', anims)
                            if row["monitored"] ~= "" then
                                source:setData("admin:monitor", row["monitored"])
                            end
                            dbExec(mysql:getConn(), "UPDATE `accounts` SET `ip`='" .. source.ip .. "', `mtaserial`='" .. source.serial .. "' WHERE `id`='".. tostring(row["id"]) .."'")
                            source:setData("jailreason", row["adminjail_reason"])
                            source:setData("forum_name", row["forum_name"])
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
                            {source}, mysql:getConn(), "SELECT * FROM characters WHERE account = ?", tonumber(row["id"]))
                            triggerClientEvent(source, 'auth.success', source, 'login')
                        else
                            triggerClientEvent(source, 'auth.info', source, ''..username..' isimli hesabın şifresi yanlış veya serial uyuşmuyor.')
                        end
                    end
                else
                    triggerClientEvent(source, 'auth.info', source, ''..username..' ismiyle bir hesap bulunamadı.')
                end
            end,
        {source}, mysql:getConn(), "SELECT * FROM accounts WHERE username = ?", username)
    end
end)

addEvent('auth.register', true)
addEventHandler('auth.register', root, function(username, password, mail)
    if username and password and mail then
        if username == 'kullanıcı adı' then triggerClientEvent(source, 'auth.info', source, 'Lütfen geçerli bir kullanıcı adı girin!') return false end
        if password == 'şifre' then triggerClientEvent(source, 'auth.info', source, 'Lütfen geçerli bir şifre girin!') return false end
        if mail == 'blabla@icloud.com' then triggerClientEvent(source, 'auth.info', source, 'Lütfen geçerli bir mail adresi girin.') return false end
        dbQuery(
            function(qh, source)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        triggerClientEvent(source, 'auth.info', source, 'Zaten bir hesabınız var ('..row['username']..')')
                    end
                else
                    local encryptionRule = tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))
                    dbExec(mysql:getConn(), "INSERT INTO `accounts` SET `username`='"..username.."', `password`='"..(password).."', `email`='"..mail.."', `registerdate`=NOW(), `ip`='"..source.ip.."', `salt`='"..encryptionRule.."', `mtaserial`='"..source.serial.."', `activated`='1' ")
                    triggerClientEvent(source, 'auth.info', source, 'Başarıyla yeni bir hesap oluşturdunuz.')
                    triggerClientEvent(source, 'auth.success', source, 'register')
                end
            end,
        {source}, mysql:getConn(), "SELECT * FROM accounts WHERE mtaserial = ?", source.serial)
    end
end)