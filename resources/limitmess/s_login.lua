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

local mysql = exports.sql
local chat = exports.chat
local key = "shah"
local loginAttempts = { }
local loggedPlayers = { }

-- Handle registration attempt.
function register( playerSource, username, password )
  if loggedPlayers[ playerSource ] == false then
    if username and password then -- Was a username or password specified?
      local result = mysql:queryFree( "SELECT * FROM `accounts` WHERE `username` = '" .. username .. "'" ) -- Check if the username exists in our database.
      if not result then -- If the username does not yet exist we can create an account.
        createAccount( playerSource, username, password )
      else -- If the username exists it is already taken. Notify player.
        chat:displayWarningMsg( playerSource, "This username already exists." )
      end
    else -- If the player did not give a username and password than we cannot register an account.
      chat:displayInstructionMsg( playerSource, "/" .. commandName .. " [username] [password]" )
    end
  end
end

-- event:attemptRegistration

-- Create a new account.
function createAccount( playerSource, username, password )
  local result = mysql:queryFree( "INSERT INTO accounts ( username, password ) VALUES ( '" .. username .. "', '" .. hash( "md5", key .. password ) .. "' )" ) -- Create a new row in the database.
  if result == true then
    chat:displayInstructionMsg( playerSource, "Succesfully created your account. You can log in now using username : " .. username )
  else
    chat:displayErrorMsg( playerSource, "Something went wrong trying to create your account." )
  end
end

-- Handle login attempts.
function login( playerSource, username, password )
  if loggedPlayers[ playerSource ] == false or not loggedPlayers[ playerSource ] then
    if username and password then
      outputChatBox( "1A", playerSource )
      if not loginAttempts[ playerSource ] or loginAttempts[ playerSource ] < 4 then -- Check if the player has 3 or less login attempts.
        outputChatBox( "2A", playerSource )
        local result = mysql:queryFree( "SELECT * FROM `accounts` WHERE `username` = '" .. username .. "'" ) -- Does the specified account at all exist?
        if result then
          outputChatBox( "3", playerSource )
          local data = mysql:querySingle( "SELECT `password` FROM `accounts` WHERE `username` = '" .. username .. "'" ) -- Get the hashed password for the account from the database.
          if hash( "md5", key .. password ) == data[ 1 ][ "password" ] then -- Is the password entered correct?
            outputChatBox( "4A", playerSource )
            chat:displayInstructionMsg( playerSource, "Succesfully logged you into account : " .. username )
            createSession( playerSource, username )
          else
            chat:displayErrorMsg( playerSource, "That is the wrong password." )
            outputChatBox( "4B", playerSource )
            loginAttempts[ playerSource ] = loginAttempts[ playerSource ] + 1
          end
        else -- There is no such account. Notify player.
          outputChatBox( "2B", playerSource )
          chat:displayErrorMsg( playerSource, "That username does not exist." )
        end
      else -- Security check. Kick the player and let them try again.
        outputChatBox( "1B", playerSource )
        chat:displayErrorMsg( playerSource, "You have too many login attempts." )
        kickPlayer( playerSource, "Too many login attempts." )
      end
    else -- The player didn't enter anything.
      chat:displayInstructionMsg( playerSource, "/" .. commandName .. " [username] [password]" )
    end
  end
end

-- event:attemptLogin

-- Log a player out.
function logout( player )
  loggedPlayers[ playerSource ] = false
  -- despawn the player's ped
  -- End the session in analytics.
end

-- Create a new session so a player may log in to their account.
function createSession( playerSource, username )
  outputChatBox( "logged you in", playerSource )
  loggedPlayers[ playerSource ] = true
  -- Update last login information and whatnot.
end

-- A function to check if a player has logged in.
function isLoggedIn( player )
  if loggedPlayers[ player ] then
    return true
  else
    return false
  end
end
