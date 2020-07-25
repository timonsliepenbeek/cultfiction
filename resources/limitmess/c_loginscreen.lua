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

--[[

  windowState

  0 = Disabled.
  1 = loginScreen
  2 = characterScreen
  3 = characterCreationScreen

]]

function showLoginScreen( player )
  outputChatBox( "showing Login Screen" )
  setCameraMatrix( 1468.8785400391, -919.25317382813, 100.153465271, 1468.388671875, -918.42474365234, 99.881813049316 )
  fadeCamera( true )
end

addEvent( "showLoginScreen", true )
addEventHandler( "showLoginScreen", localPlayer, showLoginScreen )

-- create login screen
  -- Let's just make sure the player is not logged in by logging him out.
  -- Set windowState to 1
  -- Create a username inputbox.
  -- Create a password inputbox.
  -- Create a 'Login' button.
  -- Create a 'Register' button.
  -- Enable cursor.
  -- Set the camera.

-- Hide login screen
  -- Hide the login screen.
  -- Set the windowState to 0.

-- Function to handle what happens when 'login' button is clicked.
  -- Is windowState 1 and is the player not logged in?
    -- Did the player click the 'Login' button?
      -- Hide the login window.
      -- loadLoadingScreen.
      -- Hide the cursor.
      -- Attempt to log in the player.
        -- If it works load the Character Screen.
        -- If it works also empty up all the inputfields.
        -- If it does not work then create the loginScreen again.
        -- If it does not work then hide the loadingScreen.

-- Click event.

-- Function to handle what happens when 'Register' button is clicked.
  -- Is windowState 1 and is the player not logged in?
    -- Did the player click the 'register' button?
      -- Hide the login window.
      -- loadLoadingScreen.
      -- Hide the cursor.
      -- Attempt to register an account for the player.
        -- If this works then enable the buttons again and empty the password inputfield.
        -- If it does not work then create the loginScreen again.
        -- If it does not work then hide the loadingScreen.

-- Click event.

-- renderLoginScreen
  -- is loadingScreen true and is player not logged in then render.

-- loadLoginScreen
  -- loadingScreen = true

-- hideLoginScreen
  -- loadingScreen = false

-- renderLoadingScreen
  -- is loadingScreen true and is player not logged in then render.

-- Create character selection screen
  -- Let's log the player out in case.
  -- Set windowState to 2.
  -- Load all the prerequisites.
  -- Enable the cursor.
  -- Set the camera.

-- hide character selection screen
  -- let's log the player out in case.
  -- Set windowState to 0.
  -- Hide all prerequisites.
  -- Disable the cursor.

-- renderCharacterScreen
  -- is windowState 2 and is the player not logged in then render.

-- On create a character button clicked.
  -- Is windowState 2 and is the player not logged in?
    -- Did the player click this button at all?
      -- Hide the character selection screen.
      -- Disable the cursor.
      -- Load the loading screen.
      -- Load the character creation screen.

-- Click event.

-- Select a character.
  -- Is windowState 2 and is the player not logged in?
    -- Did the player click this button at all?
      -- Hide the character selection screen.
      -- Load the loading screen.
      -- Attempt to spawn the player.
        -- If it's not succesfull then we must reload the character selection screen. Stop loading screen.
        -- If succesful then hide the loading screen.

-- Create character creation screen
  -- Let's log the player out just in case.
  -- Set windowState to 3.
  -- Load all prerequisites.
  -- Enable the cursor.
  -- Set the camera.

-- Hide character creation screen
  -- Log the player out just in case.
  -- Set windowState to 0.
  -- Hide all prerequisites.
  -- Disable the cursor.

-- attemptCharacterCreation
  -- Is windowState 3 and is the player not logged in?
    -- Did the player click this one button at all?
      -- Hide the character creation screen.
      -- Load the loading screen.
        -- If not succesfull then show the character creation screen again. Stop loading screen.
        -- If succesfull then stop the loading screen.
