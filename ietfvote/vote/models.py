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
   

def addRating( rating , judge ):
    speaker = getSpeaker()

    now = long( time.time() )

    rating = Rating( time=now , speaker=speaker, rating=rating, judge=judge )
    rating.put()


globalRatingTime = 0
globalRatingValue = " "

def getRecentRatings( startTime ):
    global globalRatingTime
    global globalRatingValue

    now = long( time.time() )
    if globalRatingTime+5 > now: # use cached data for 5 seconds
        #logging.debug( "getRecentRatings using cached value" )
        return globalRatingValue
    
    json = ''
    json += "{ data: [ \n"

    query = Rating.all();
    query.order("-time") #TODO - should have time based limits 
    ratings = query.fetch(2000) #TODO need to deal with more than 900 meassurements

    ratings.reverse()

    for rating in ratings:
        if rating.time >= startTime:
            json += "{ time:%d, speaker:'%s', judge:'%s', rating:%d },\n"%(
                rating.time, rating.speaker, rating.judge, rating.rating )

    json += " ] }"

    globalRatingValue = json
    globalRatingTime = now
    
    return json
