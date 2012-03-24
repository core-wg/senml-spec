#!/bin/csh

while (1)
    sleep 1

    @ c = 0
    while ( $c < 5 )
	echo "Try $c "
        curl -s http://ietfvote.appspot.com/recent/ > /dev/null &
	@ c = $c + 1
    end

    wait

    echo  -n "."
end
