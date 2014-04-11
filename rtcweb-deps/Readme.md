
curl http://datatracker.ietf.org/wg/rtcweb/deps/dot/ > rtcweb.dot

dot -Tpdf rtcweb.dot -o rtcweb.pdf


Might want to look at code at 

http://wiki.tools.ietf.org/tools/ietfdb/browser/trunk/ietf/wginfo/views.py#L297

http://wiki.tools.ietf.org/tools/ietfdb/browser/trunk/ietf/templates/wginfo/dot.txt

