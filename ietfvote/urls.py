# Copyright (c) 2010, Cullen Jennings. All rights reserved.


from django.conf.urls.defaults import *
from django.views.generic.simple import redirect_to

#from pachube.views import *
from vote.views import *

urlpatterns = patterns('',
    (r'^$', about ), 
    (r'^speaker/(?P<speakerName>\w{1,50})/$', speaker ), 
    (r'^rate/(?P<judge>\w{1,50})/(?P<rating>\d{1})/$', rate ), 
    (r'^recent/$', recent ), 
)
