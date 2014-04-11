---
title: "WebRTC Dependencies"
abbrev: WebRTC Dependencies
docname: draft-jennings-rtcweb-deps-00
date: 2014-04-11
category: info
ipr: trust200902

coding: us-ascii

pi:
  toc: yes
  sortrefs: yes
  symrefs: yes

author:
 -
    ins: C. Jennings
    name: Cullen Jennings
    email: fluffy@iii.ca
    org: Cisco 


normative:
  I-D.burnett-rtcweb-constraints-registry:

  RFC5245: 
  RFC2119: 
  RFC3388:
  RFC7064:
  RFC7065:
  I-D.ietf-rtcweb-audio:
  I-D.ietf-rtcweb-data-channel:
  I-D.ietf-rtcweb-data-protocol:
  I-D.ietf-rtcweb-jsep:
  I-D.ietf-rtcweb-rtp-usage:
  I-D.ietf-rtcweb-security-arch:
  I-D.ietf-rtcweb-transports:
  #I-D.ietf-rtcweb-video:
  RFC3264:



informative:
  I-D.ietf-rtcweb-security:
  I-D.ietf-rtcweb-overview:


--- abstract

This draft will never be published as an RFC and is meant purely to help track the
IETF dependencies from the W3C WebRTC documents.

--- middle

Dependencies
============

The W3C GetUserMedia specification normatively depends on 
{{I-D.burnett-rtcweb-constraints-registry}}.


The W3C WebRTC specification normatively depended on 
{{RFC5245}} 
{{RFC2119}} 
{{RFC3388}}
{{RFC7064}}
{{RFC7065}}
{{I-D.ietf-rtcweb-audio}}
{{I-D.ietf-rtcweb-data-channel}}
{{I-D.ietf-rtcweb-data-protocol}}
{{I-D.ietf-rtcweb-jsep}}
{{I-D.ietf-rtcweb-rtp-usage}}
{{I-D.ietf-rtcweb-security-arch}}
{{I-D.ietf-rtcweb-transports}}
TODO I-D.ietf-rtcweb-video 
{{RFC3264}}
and
informatively depends 
on 
{{I-D.ietf-rtcweb-overview}}
{{I-D.ietf-rtcweb-security}}. 

