--[[
Copyright (c) 2010 MTA: Paradise

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
]]

local connection = nil
local connection = nil
local null = nil
local results = { }
local max_results = 128

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

local function disconnect( )
	if connection then
		destroyElement( connection )
	end
end

local function checkConnection( )
	if not connection then
		return connect( )
	end
	return true
end

addEventHandler( "onResourceStart", resourceRoot,
	function( )
		if not dbConnect then
			if hasObjectPermissionTo( resource, "function.shutdown" ) then
				shutdown( "MySQL module missing." )
			end
			cancelEvent( true, "MySQL module missing." )
		elseif not hasObjectPermissionTo( resource, "function.dbConnect" ) then
			if hasObjectPermissionTo( resource, "function.shutdown" ) then
				shutdown( "Insufficient ACL rights for mysql resource." )
			end
			cancelEvent( true, "Insufficient ACL rights for mysql resource." )
		elseif not connect( ) then
			if connection then
				outputDebugString( mysql_error( connection ), 1 )
			end

			if hasObjectPermissionTo( resource, "function.shutdown" ) then
				shutdown( "MySQL failed to connect." )
			end
			cancelEvent( true, "MySQL failed to connect." )
		end
	end
)

addEventHandler( "onResourceStop", resourceRoot,
	function( )
		for key, value in pairs( results ) do
			dbFree( value.r )
			outputDebugString( "Query not free()'d: " .. value.q, 2 )
		end

		disconnect( )
	end
)

--

function escape_string( str )
	if type( str ) == "string" then
		return dbPrepareString( connection, str )
	elseif type( str ) == "number" then
		return tostring( str )
	end
end

local function query( str, ... )

	checkConnection( )

	if ( ... ) then
		local t = { ... }
		for k, v in ipairs( t ) do
			t[ k ] = escape_string( tostring( v ) ) or ""
		end
		str = str:format( unpack( t ) )
	end

	local query = dbQuery( connection, str )
	if query then
		local result, nar, liid = dbPoll( query, -1 )
		if result == nil then
			dbFree( query )
		elseif result == false then
			local ec, em = nar, liid
			outputServerLog( "dbPoll failed with Error code" .. tostring( ec ) .. " Error Message: " .. tostring( em ) )
			dbFree( query )
			return false, em
		else
			dbFree( query )
			return result, nar, liid
		end
	else
		outputServerLog( "No MySQL connection." )
	end
end

function query_free( str, ... )

	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end

	checkConnection( )

	if ( ... ) then
		local t = { ... }
		for k, v in ipairs( t ) do
			t[ k ] = escape_string( tostring( v ) ) or ""
		end
		str = str:format( unpack( t ) )
	end

	local result, nar, liid = query( str )
	if result then
		return true
	end
	return false, nar
end

function query_assoc( str, ... )

	if sourceResource == getResourceFromName( "runcode" ) then
		return false
	end

	local t = { }
	local result, nar, liid = query( str, ... )
	if result then
		for result, row in ipairs( result ) do
			local num = #t + 1
			t[ num ] = { }
			for key, value in pairs( row ) do
				if value ~= null then
					t[ num ][ key ] = tonumber( value ) or value
				end
			end
		end
		return t
	end
	return false, nar
end
