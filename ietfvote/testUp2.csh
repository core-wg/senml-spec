#!/bin/csh

while (1)
    sleep 1
    curl http://ietfvote.appspot.com/rate/bar/1/
    echo -n "*"
end
