import logging
from datetime import timedelta
from datetime import datetime
import time
from sets import Set

from google.appengine.api import memcache
from google.appengine.ext import db
from google.appengine.ext.db import Key

def initDataBase():
    getSpeaker()

               
class CurrentSpeaker( db.Model ):
    speaker = db.StringProperty(required=True)


def getSpeaker():
    query = CurrentSpeaker.all();
    speaker = query.get();
    if speaker is None:
        speaker = CurrentSpeaker( speaker = "unknown" )
        speaker.put()
    return speaker.speaker


def setSpeaker( name ):
    query = CurrentSpeaker.all();
    speaker = query.get();
    
    if speaker.speaker != name:
        speaker.speaker = name
        speaker.put()

    return speaker.speaker
    
    

class Rating( db.Model ):
    time    = db.IntegerProperty(required=True) # time this messarement was made (seconds since unix epoch)
    speaker = db.StringProperty(required=True) #
    judge   = db.StringProperty(required=True) #
    rating  = db.IntegerProperty(required=True) # unique interger ID for this sensor 
   

def addRating( rating , judge = "unknown" ):
    speaker = getSpeaker()

    now = long( time.time() )
  
    rating = Rating( time=now , speaker=speaker, rating=rating, judge=judge )
    rating.put()

