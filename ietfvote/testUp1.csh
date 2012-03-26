#!/bin/csh

while (1)
    sleep 1
    curl http://ietfvote.appspot.com/rate/Bob/3/
    echo -n "."
end
