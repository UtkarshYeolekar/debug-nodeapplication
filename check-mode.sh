#!/bin/sh
echo "
     check-mode.sh script checks whether debugging is ON or not, while initiating a container.
     It accepts two environment variables :
         a. DEBUG_MODE  (mandatory for debugging)
         b. DEBUG_FILE (optional file path for debugging)
     Example :   docker run -it -e DEBUG_MODE=debug -e DEBUG_FILE=app.js 'imagename/id' /bin/ash"

if [ -z "$DEBUG_MODE" ]
then     
    echo "DEBUG_MODE is not defined, initiating without debugging.." 
    node app.js
else 
    echo 
    echo "---- 1. Environemt Variable DEBUG_MODE is Defined -----"
    echo "---- 2. Checking Environment Variable DEBUG_FILE is defined or not, 
          and also does the file exist at that path ?  ----"

        if [ ! -z "$DEBUG_FILE" ] && [ -f "$DEBUG_FILE" ] 
        then
                echo "---- 3. Environment Variable DEBUG_FILE is defined and also File Exist ----"
                echo
                node --debug-brk --inspect  $DEBUG_FILE   
        else
                echo "----- 3. DEBUG_FILE or File Path doesn't exist ----"
                echo "----- 4. Debugging the default entry point app.js ----"
                echo 
                    node --debug-brk --inspect app.js
        fi
fi