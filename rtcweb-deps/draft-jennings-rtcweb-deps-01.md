---
title: "WebRTC Dependencies"
abbrev: WebRTC Dependencies
docname: draft-jennings-rtcweb-deps-01
date: 2014-10-07
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
  I-D.ietf-rtcweb-constraints-registry:
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
  I-D.ietf-rtcweb-video:
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

The key IETF specifications that the W3C GetUserMedia specification normatively depends on is:
{{I-D.ietf-rtcweb-constraints-registry}},
{{RFC2119}}.


The key IETF specifications that the W3C WebRTC specification normatively depended on are:
{{RFC5245}},
{{RFC2119}},
{{RFC3388}},
{{RFC7064}},
{{RFC7065}},
{{I-D.ietf-rtcweb-audio}},
{{I-D.ietf-rtcweb-data-channel}},
{{I-D.ietf-rtcweb-data-protocol}},
{{I-D.ietf-rtcweb-jsep}},
{{I-D.ietf-rtcweb-rtp-usage}},
{{I-D.ietf-rtcweb-security-arch}},
{{I-D.ietf-rtcweb-transports}},
{{I-D.ietf-rtcweb-video}},
{{RFC3264}}
and
informatively depends 
on 
{{I-D.ietf-rtcweb-overview}}, 
{{I-D.ietf-rtcweb-security}}.

These IETF drafts in turn normatively depend on the following drafts:
{{draft-ietf-payload-rtp-opus


ietf-tsvwg-sctp-ndata
ietf-rtcweb-data-protocol
ietf-tsvwg-sctp-dtls-encaps
ietf-rtcweb-security
ietf-rtcweb-security-arch
ietf-rtcweb-jsep
ietf-tsvwg-sctp-prpolicies
ietf-mmusic-sctp-sdp
ietf-tsvwg-sctp-dtls-encaps

ietf-mmusic-msid
ietf-mmusic-sctp-sdp
ietf-mmusic-sdp-bundle-negotiation
ietf-mmusic-sdp-mux-attributes
ietf-rtcweb-audio
ietf-rtcweb-data-protocol
ietf-rtcweb-rtp-usage]
ietf-rtcweb-security
ietf-rtcweb-security-arch

ietf-avtcore-multi-media-rtp-session
ietf-avtcore-rtp-circuit-breakers
ietf-avtcore-rtp-multi-stream-optimisation
ietf-avtcore-rtp-multi-stream

ietf-rtcweb-security
ietf-avtcore-6222bis
ietf-rtcweb-rtp-usage
ietf-rtcweb-stun-consent-freshness

hutton-httpbis-connect-protocol
ietf-tsvwg-rtcweb-qos
reddy-mmusic-ice-happy-eyeballs
draft-ietf-rtcweb-alpn

grange-vp9-bitstream
ietf-payload-rtp-h265
ietf-payload-vp8


Right now security normatively depends on
{{ietf-rtcweb-overview 




A few key drafts that the informatively depends on:
ietf-mmusic-trickle-ice
nandakumar-rtcweb-sdp
ietf-avtcore-multiplex-guidelines
ietf-avtcore-rtp-topologies-update
ietf-avtext-rtp-grouping-taxonomy
ietf-rmcat-cc-requirements
ietf-rtcweb-use-cases-and-requirements
ietf-tsvwg-rtcweb-qos
ietf-avtcore-6222bis 
kaufman-rtcweb-security-ui
alvestrand-rtcweb-gateways
hutton-rtcweb-nat-firewall-considerations
ietf-dart-dscp-rtp 


Missing:

draft-ietf-rtcweb-audio-codecs-for-interop-00.txt
draft-ietf-rtcweb-overview-11.txt
draft-ietf-rtcweb-stun-consent-freshness-07.txt
draft-ietf-rtcweb-use-cases-and-requirements-14.txt

