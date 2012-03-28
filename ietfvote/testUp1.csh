#!/bin/csh

while (1)
    sleep 1
    curl http://ietfvote.appspot.com/rate/Bob/5/
    echo -n "."
end
