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
        local auth, error = mysql:query_free( "SELECT username, password FROM accounts WHERE username='%s' AND password='%s'", username, hash( "md5", key + password ) ) -- See if that user is in the database and hash the password and see if it matches.
        if auth then -- If authorized
          -- What happens if we succesfully login.
        elseif error then
          -- What happens if we get an error in the query.
        else
          -- What happens when either is wrong.
          loginAttempts[ source ] = loginAttempts[ source ] + 1 -- Count login attempts as protection
        end
      end
    end
  end
)

addCommandHandler( "registerme",
  function( playerSource, commandName, username, password )
    if username and password and #username > 0 and #password > 0 then
      triggerEvent( getResourceName( resource ) .. ":register", root, username, password )
    end
  end
)

addEvent( getResourceName( resource ) .. ":register", true )
addEventHandler( getResourceName( resource ) .. ":register", root,
  function( username, password )
    if username ~= nil and username ~= "" and password ~= nil and password ~= "" then
      local result, error = mysql:query_assoc( "SELECT COUNT(id) AS usercount FROM accounts WHERE username='%s'", username )
      if result[ 1 ][ "usercount" ] == 0 then
        local registration = mysql:query_assoc( "INSERT INTO accounts ( username, password ) VALUES ( '%s', '%s' )", username, hash( "md5", key .. password ) )
        if registration then
          -- What happens if the account was registered.
        end
      elseif error then
        -- If we get an error message.
      else
        -- What happens if the username is taken.
      end
    end
  end
)
