--[[
    Copyright (C) 2018  Timon Sliepenbeek

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    ]]

local connection = nil

-- connect
-- disconnect
-- ping
-- query
	-- return result
	-- free if fail
	-- handle error
-- query_single

-- connection functions
local function connect( )
	-- retrieve the settings
	local server = get( "server" ) or "localhost"
	local user = get( "user" ) or "root"
	local password = get( "password" ) or ""
	local db = get( "database" ) or "mta"
	local port = get( "port" ) or 3306
	local socket = get( "socket" ) or nil

	-- connect
	connection = dbConnect( "mysql", "dbname=" .. db .. ";host=" .. server .. ";port=" .. port, user, password )
	if connection then
		if user == "root" then
			setTimer( outputDebugString, 100, 1, "Connecting to your MySQL as 'root' is strongly discouraged.", 2 )
		end
		return true
	else
		outputDebugString ( "Connection to MySQL Failed.", 1 )
		return false
	end
end
addEventHandler( "onResourceStart", getResourceRootElement( getThisResource( ) ), connect )

function queryFree( str )
	if str then
		local h = dbQuery( connection, dbPrepareString( connection, str ) )
		local result, numAffectedRows, lastInsertId = dbPoll( h, -1 )
		if result == nil then
			return nil
		elseif result == false then
			local error, message = numAffectedRows, lastInsertId
			outputServerLog( "dbPoll failed. Error code: " .. tostring( error ) .. " Error message: " .. tostring( message ) )
			return false
		else
			if numAffectedRows == 0 then
				return false
			else
				return true
			end
		end
	end
end

function querySingle( str )
	if str then
		local h = dbQuery( connection, dbPrepareString( connection, str ) )
		local result, numAffectedRows, lastInsertId = dbPoll ( h, -1 )
		if result == nil then
			outputConsole( "dbPoll result not ready yet." )
			return nil
		elseif result == false then
			local error, message = numAffectedRows, lastInsertId
			outputConsole( "dbPoll failed. Error code: " .. tostring( error ) .. " Error message: " .. tostring( message ) )
		else
			return result
		end
	end
end
