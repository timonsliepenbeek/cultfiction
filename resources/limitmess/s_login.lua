local mysql = exports.sql
local key = "shah"
local loginAttempts = { }


addCommandHandler( "logmein",
  function( playerSource, commandName, username, password )
    outputChatBox( "1" )
    if username and password and #username > 0 and #password > 0 then
      outputChatBox( "2" )
      triggerEvent( getResourceName( resource ) .. ":login", root, username, password )
    end
  end
 )

addEvent( getResourceName( resource ) .. ":login", true )
addEventHandler( getResourceName( resource ) .. ":login", root,
  function( username, password ) -- Specify username and password and parse as paramters
    if loginAttempts[ source ] > 5 then
      outputChatBox( "Too many login attempts. Check back later." )
      if username and password and #username > 0 and #password > 0 then -- If there is something in the parameters
        local auth = mysql:query_free( "SELECT username, password FROM accounts WHERE username='%s' AND password='%s'", username, hash( "md5", key + password ) ) -- See if that user is in the database and hash the password and see if it matches.
        if auth then -- If authorized
          outputChatBox( )
        else
          outputChatBox( "Wrong username or password!" ) -- Output message
          loginAttempts[ source ] = loginAttempts[ source ] + 1 -- Count login attempts as protection
        end
      end
    end
  end
)

addCommandHandler( "registerme",
  function( playerSource, commandName, username, password )
    outputChatBox( "1" )
    if username and password and #username > 0 and #password > 0 then
      outputChatBox( "2" )
      triggerEvent( getResourceName( resource ) .. ":register", root, username, password )
    end
  end
)

addEvent( getResourceName( resource ) .. ":register", true )
addEventHandler( getResourceName( resource ) .. ":register", root,
  function( username, password )
    outputChatBox( username )
    if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
      outputChatBox( "5" )
      local result = mysql:query_free( "SELECT COUNT(id) AS usercount FROM accounts WHERE username='%s'", username )
      if not result then
        outputChatBox( "6" )
        local registration = mysql:query_free( "INSERT INTO accounts VALUES username='%s', password='%s'", username, hash( "md5", key + password ) )
        if registration then
          outputChatBox( "succesfully registered" )
        end
      else
        outputChatBox( "account already exists" )
      end
    end
  end
)
