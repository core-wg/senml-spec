#!/bin/csh

while (1)
    #sleep 1
    curl http://ietfvote.appspot.com/recent/ > /dev/null
    echo  -n "."
end
