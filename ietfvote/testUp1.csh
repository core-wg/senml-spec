#!/bin/csh

while (1)
    sleep 1
    curl http://ietfvote.appspot.com/rate/foo/3/
    echo -n "."
end
