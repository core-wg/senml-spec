import logging
from datetime import timedelta
from datetime import datetime
import time
from sets import Set

from google.appengine.api import memcache
from google.appengine.ext import db
from google.appengine.ext.db import Key

class Sensor(db.Model):
    sensorID = db.IntegerProperty(required=True) # unique interger ID for this sensor

    
