#!/bin/csh

while (1)
    sleep 1
    curl http://ietfvote.appspot.com/rate/alice/1/
    echo -n "*"
end
