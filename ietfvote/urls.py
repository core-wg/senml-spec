# Copyright (c) 2010, Cullen Jennings. All rights reserved.


from django.conf.urls.defaults import *
from django.views.generic.simple import redirect_to

#from pachube.views import *
from vote.views import *

urlpatterns = patterns('',
   # (r'^pachube/(?P<feed>\d{1,8})/(?P<stream>\d{1,3})/view/$', view1 ), 
   # (r'^pachube/(?P<feed>\d{1,8})/(?P<stream>\d{1,3})/json/$', json ), 
   # (r'^pachube/(?P<feed>\d{1,8})/(?P<stream>\d{1,3})/table/$', view3 ), 
   # (r'^pachube/(?P<feed>\d{1,8})/(?P<stream>\d{1,3})/chart/$', view4 ), 

    (r'^$', about ), 

)
