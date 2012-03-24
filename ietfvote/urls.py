# Copyright (c) 2010, Cullen Jennings. All rights reserved.


from django.conf.urls.defaults import *
from django.views.generic.simple import redirect_to

#from pachube.views import *
from vote.views import *

urlpatterns = patterns('',
    (r'^$', about ), 
    (r'^speaker/(?P<speakerName>[ \%a-zA-Z0-9]{1,50})/$', speaker ), 
    (r'^rate/(?P<judge>[ \%a-zA-Z0-9]{1,50})/(?P<rating>\d{1,15})/$', rate ), 
    (r'^recent/$', recent ), 
    (r'^since/(?P<startTime>[\d]{1,15})/$', since ), 
)
