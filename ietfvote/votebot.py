#!/usr/bin/env python
# coding: utf-8

# Copyright (C) 2010 Arthur Furlan <afurlan@afurlan.org>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
# 
# On Debian systems, you can find the full text of the license in
# /usr/share/common-licenses/GPL-3


from jabberbot import JabberBot, botcmd
from datetime import datetime
import re
import urllib2
import logging

def isNonAscii(str):
    return not all(ord(c) < 128 for c in str)

def stringHash(str):
    hash = 0
    for c in str: 
        hash = (hash + ord(c)) % (1<<13)
    return hash

class MUCJabberBot(JabberBot):

    ''' Add features in JabberBot to allow it to handle specific
    caractheristics of multiple users chatroom (MUC). '''

    def __init__(self, *args, **kwargs):
        ''' Initialize variables. '''

        # answer only direct messages or not?
        self.only_direct = kwargs.get('only_direct', False)
        try:
            del kwargs['only_direct']
        except KeyError:
            pass

        # initialize jabberbot
        super(MUCJabberBot, self).__init__(*args, **kwargs)

        # create a regex to check if a message is a direct message
        user, domain = self.jid.getStripped().split('@')
        self.direct_message_re = re.compile('^%s(@%s)?[^\w]? ' \
                % (user, domain))

    def callback_message(self, conn, mess):
        ''' Changes the behaviour of the JabberBot in order to allow
        it to answer direct messages. This is used often when it is
        connected in MUCs (multiple users chatroom). '''

        message = mess.getBody()
        if not message:
            return

        if self.direct_message_re.match(message):
            mess.setBody(' '.join(message.split(' ', 1)[1:]))
            return super(MUCJabberBot, self).callback_message(conn, mess)
        elif not self.only_direct:
            return super(MUCJabberBot, self).callback_message(conn, mess)


class VoteBot(MUCJabberBot):

    @botcmd
    def date(self, mess, args):
        reply = datetime.now().strftime('%Y-%m-%d')
        self.send_simple_reply(mess, reply)

    @botcmd
    def vote(self, mess, args):
        # Extract judge
        judge = mess.getFrom().getResource()
        # Extract rating
        m = re.search("([0-9.]+)", mess.getBody())
        if (not m): 
            return judge +": Dude, you have to give me a number"
        value = int(float(m.group(0)));
        # Un-unicode-ize the judge 
        if (isNonAscii(judge)):
            judge = "unicode_monkey_"+str(stringHash(judge))
        # Load relevant URL
        strval = str(value)
        url = "http://ietfvote.appspot.com/rate/"+ judge +"/"+ strval +"/"
        try:
            req = urllib2.Request(url)
            res = urllib2.urlopen(req)
        except urllib2.HTTPError:
            pass

    @botcmd
    def speaker(self, mess, args):
        # Check to see if sender is authorized
        if (mess.getFrom().getResource() != "master"):
            return "Sorry, unauthorized"
        # Read message to extract speaker
        speaker = re.sub("^speaker[ ]+", "", mess.getBody())
        # Validate the name and URL-encode
        if (isNonAscii(speaker)):
            return "This is the IETF, please use ASCII only"
        speaker = urllib2.quote(speaker)
        # Load relevant URL
        url = "http://ietfvote.appspot.com/speaker/"+ speaker +"/"
        try:
            req = urllib2.Request(url)
            res = urllib2.urlopen(req)
        except urllib2.HTTPError:
            pass


if __name__ == '__main__':

    logging.basicConfig()

    username = 'ietf.bot@gmail.com'
    password = 'postelhousley'
    nickname = 'diebold_superAccuVote_9000'
    chatroom = 'bad-attitude@conference.psg.com'

    mucbot = VoteBot(username, password, only_direct=False)
    mucbot.muc_join_room(chatroom, nickname)
    mucbot.serve_forever()
