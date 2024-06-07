local mysql = exports.mysql

function updateTables()
	imported_accounts, imported_characters = {}, {}
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					row_info = {}
					for count, data in pairs(value) do
						row_info[count] = data
					end
					imported_accounts[#imported_accounts + 1] = row_info
				end
			end
		end,
	mysql:getConn(), "SELECT * FROM `accounts`")
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					row_info = {}
					for count, data in pairs(value) do
						row_info[count] = data
					end
					imported_characters[#imported_characters + 1] = row_info
				end
			end
		end,
	mysql:getConn(), "SELECT * FROM `characters`")
end

function getTableInformations()
	updateTables()
	return imported_accounts, imported_characters
end
