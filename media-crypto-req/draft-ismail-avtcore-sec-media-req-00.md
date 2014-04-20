---
title: "Requirments for Secure RTP Media Switch"
abbrev: Secure Media Switch Requirements
docname: draft-ietf-rtcweb-video-00
date: 2014-04-19
category: info
ipr: trust200902

coding: us-ascii

pi:
  toc: yes
  sortrefs: yes
  symrefs: yes

author:
 -
    ins: N. Ismail
    name: Nermeen Ismail
    email: nermeen@cisco.com
    org: Cisco 
    street: 170 W Tasman Dr.
    city: San Jose
    country: US

normative:
  RFC2119:

informative:
  I-D.ietf-rtcweb-security:
  I-D.ietf-rtcweb-security-arch:


--- abstract

This draft outlines the requirements to allow media switch to be able
to form a multimeida mult user conference with needing to have the
keys used to encrypt the media in the conference.

--- middle



Introduction
============

Modern audio / video conferncing systems often "switch" video insteald
of mixing. If there are 10 participants on a confenrce call, all send
the vidoe from their camera to the a centralized siwtch. The switch
picks the active speaker and sends that video to all the endpoints. If
the endpoints also wish to display a thumbnail sized video of all the
users, that is sent as a sperate video stream and the endpoing render
it seperattly.

Systems such as this are decomposed into a controller that deals with
the singalling and keeps track of who is in the conferce and one or
more media switches that receive and transmit the audio and video to
all the partipants using SRTP. It does not matter where the controller
is located but it is desirable to use a media switch that is as close
to the particpants as possible to reduce latency of the media as well
as locted in a location with suffeicent bandwidth. This results in
situtaitons where it is nice to be able to locat the media switch in a
data cetner that is nor particularly trusted, or to be able to pay for
use of media switches operatored by other parties.

This draft outlines the requirements  to allow media swtich to be able
to preform the  fucitons it needs with having the  keys to decrypt the
media it is switching.



Terminology
===========

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.


Switched Media Archatecture
============================

TODO - explain what audio and video come from the particpants to the
switch, what the switch does, and what goes out to clients

TODO - dig into the next level of detail of what parts of the header
get changed by the switch and why - make sure to be clear there are
other RTP mixer archtectures - refernce magnus draft - but this is a
common one used by moder systems due to rduced cost


Requirments
===========

TODO


Security Considerations
=======================

This specification is all about new requirements for a system for
securing RTP headers seperatley from the RTP body.



IANA Considerations
===================

This document requires no actions from IANA.



Acknowledgements
================

The authors would like to thank <GET YOUR NAME HERE - PLEASE SEND
COMMENTS>. 

