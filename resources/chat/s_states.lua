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

local errorColorRed, errorColorGreen, errorColorBlue = 255, 0, 0
local warningColorRed, warningColorGreen, warningColorBlue = 255, 255, 0
local instructionColorRed, instructionColorGreen, instructionColorBlue = 255, 255, 255

function displayErrorMsg( player, msg )
  if msg then
    outputChatBox( msg, player, errorColorRed, errorColorGreen, errorColorBlue )
  end
end

function displayWarningMsg( player, msg )
  if msg then
    outputChatBox( msg, player, warningColorRed, warningColorGreen, warningColorBlue )
  end
end

function displayInstructionMsg( player, msg )
  if msg then
    outputChatBox( msg, player, instructionColorRed, instructionColorGreen, instructionColorBlue )
  end
end
