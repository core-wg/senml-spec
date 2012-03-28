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

    now = long( 1000.0 * time.time() )

    rating = Rating( time=now , speaker=speaker, rating=rating, judge=judge )
    rating.put()


globalRatingTime = 0
globalRatingValue = " "

def getRecentRatings( startTime ):
    global globalRatingTime
    global globalRatingValue

    now = long( 1000.0 * time.time() )

    if startTime < now - 30*60*1000: # limit to 30 minutes old 
        startTime = now - 30*60*1000
        
    #if globalRatingTime+5000 > now and startTime == 0: # use cached data for 5 seconds
    #    #logging.debug( "getRecentRatings using cached value" )
    #    return globalRatingValue
    
    json = ''
    json += '{ "now":%d, "data" : [ \n'%now

    query = Rating.all();
    query.filter( 'time >', startTime )
    query.order("-time") #TODO - should have time based limits 
    ratings = query.fetch(500) #TODO need to deal with more than 900 meassurements

    ratings.reverse()

    empty = True
    for rating in ratings:
        if rating.time >= startTime:
            if not empty:
                json += ",\n"
            empty = False
            json += '{ "time":%d, "speaker":"%s", "judge":"%s", "rating":%d }'%(
                rating.time, rating.speaker, rating.judge, rating.rating )

    json += " ] }"

    if startTime == 0:
        globalRatingValue = json
        globalRatingTime = now
    
    return json
