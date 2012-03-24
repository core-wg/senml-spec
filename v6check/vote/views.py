import logging
import sys
import os


from django.http import HttpResponse
from django.http import HttpResponseNotFound
from django.http import HttpResponseForbidden
from django.http import HttpResponseRedirect
from django.shortcuts import render_to_response
from google.appengine.ext.db import djangoforms
#from django import newforms as forms
#from django.newforms import form_for_model,form_for_instance
from django import forms
from django import VERSION


from google.appengine.ext import db
from google.appengine.runtime import apiproxy_errors

from google.appengine.api import mail

from google.appengine.api import urlfetch

from vote.models import *



def about(request):
    ver = os.environ['SERVER_SOFTWARE']
    devel = ver.startswith("Development")
   
    return render_to_response('about.html' , { 
        'djangoVersion': "%s.%s.%s"%( VERSION[0],  VERSION[1], VERSION[2] ) ,
        'pythonVersion': "%s"%( sys.version ) ,
        'osVersion': "%s"%( ver ) ,
        'host':request.META["HTTP_HOST"] } )






