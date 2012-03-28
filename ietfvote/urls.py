# Copyright (c) 2010, Cullen Jennings. All rights reserved.


from django.conf.urls.defaults import *
from django.views.generic.simple import redirect_to

#from pachube.views import *
from vote.views import *

urlpatterns = patterns('',
    (r'^$', main ), 
    (r'^about/$', about ), 
    (r'^speaker/(?P<speakerName>[ \%a-zA-Z0-9_]{1,140})/$', speaker ), 
    (r'^rate/(?P<judge>[ \%a-zA-Z0-9_-]{1,140})/(?P<rating>[0-9]{1,8}\.?[0-9]{0,20})$', rate ), 
    (r'^recent/$', recent ), 
    (r'^since/(?P<startTime>\d{1,15})/$', since ), 
)
