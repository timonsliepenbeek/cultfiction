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

addEventHandler( "onResourceStart", resourceRoot,
  function( )
    setGameType( "Roleplay" )
    setRuleValue( "author", "Shahanshah" )
    setRuleValue( "license", "GPL Version 3" )
    setRuleValue( "source", "https://github.com/timonsliepenbeek/cultfiction" )
    setRuleValue( "git-url", "https://github.com/timonsliepenbeek/cultfiction" )
    setRuleValue( "version", "getVersion( )" )
    setMapName( "Limitmess" )
  end
)

addEventHandler( "onResourceStop", resourceRoot,
	function( )
		removeRuleValue( "author" )
		removeRuleValue( "license" )
		removeRuleValue( "source" )
		removeRuleValue( "git-url" )
		removeRuleValue( "version" )
	end
)

-- When a player connects.
  -- Load the login screen for the connected player.
