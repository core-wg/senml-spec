---
title: "WebRTC Dependencies"
abbrev: WebRTC Dependencies
docname: draft-jennings-rtcweb-deps-03
date: 2014-10-08
category: info
ipr: trust200902

coding: us-ascii

pi:
  toc: no
  sortrefs: yes
  symrefs: yes

author:
 -
    ins: C. Jennings
    name: Cullen Jennings
    email: fluffy@iii.ca
    org: Cisco 


normative:
  I-D.grange-vp9-bitstream:
  I-D.hutton-httpbis-connect-protocol:
  I-D.ietf-avtcore-6222bis:
  I-D.ietf-avtcore-multi-media-rtp-session:
  I-D.ietf-avtcore-rtp-circuit-breakers:
  I-D.ietf-avtcore-rtp-multi-stream-optimisation:
  I-D.ietf-avtcore-rtp-multi-stream:
  I-D.ietf-httpbis-header-compression:
  I-D.ietf-httpbis-http2:
  I-D.ietf-mmusic-msid:
  I-D.ietf-mmusic-sctp-sdp:
  I-D.ietf-mmusic-sdp-bundle-negotiation:
  I-D.ietf-mmusic-sdp-mux-attributes:
  I-D.ietf-payload-rtp-h265:
  I-D.ietf-payload-rtp-opus:
  I-D.ietf-payload-vp8:
  I-D.ietf-rtcweb-alpn:
  I-D.ietf-rtcweb-audio:
  I-D.ietf-rtcweb-constraints-registry:
  I-D.ietf-rtcweb-data-channel:
  I-D.ietf-rtcweb-data-protocol:
  I-D.ietf-rtcweb-data-protocol:
  I-D.ietf-rtcweb-jsep:
  I-D.ietf-rtcweb-overview :
  I-D.ietf-rtcweb-overview:
  I-D.ietf-rtcweb-rtp-usage:
  I-D.ietf-rtcweb-security-arch:
  I-D.ietf-rtcweb-security:
  I-D.ietf-rtcweb-security:
  I-D.ietf-rtcweb-stun-consent-freshness:
  I-D.ietf-rtcweb-transports:
  I-D.ietf-rtcweb-video:
  I-D.ietf-tls-applayerprotoneg:
  I-D.ietf-tsvwg-rtcweb-qos:
  I-D.ietf-tsvwg-sctp-dtls-encaps:
  I-D.ietf-tsvwg-sctp-ndata:
  I-D.ietf-tsvwg-sctp-prpolicies:
  I-D.ietf-tram-alpn:
  I-D.petithuguenin-tram-turn-dtls:
  I-D.reddy-mmusic-ice-happy-eyeballs:
  I-D.ietf-tram-stun-dtls:
  RFC2119:
  RFC3264:
  RFC3388:
  RFC5245:
  RFC7022:
  RFC7064:
  RFC7065:
  RFC7301:
  I-D.nandakumar-rtcweb-stun-uri:
  I-D.petithuguenin-behave-turn-uris:
  I-D.ietf-avtcore-avp-codecs:
  I-D.ietf-avtcore-srtp-encrypted-header-ext:
  I-D.ietf-avtext-multiple-clock-rates:
  RFC7064:
  RFC7065:
  RFC7007:
  RFC6904:
  RFC7160:
  RFC7350:

informative:
  I-D.alvestrand-rtcweb-gateways:
  I-D.hutton-rtcweb-nat-firewall-considerations:
  I-D.ietf-avtcore-multiplex-guidelines:
  I-D.ietf-avtcore-rtp-topologies-update:
  I-D.ietf-avtcore-srtp-ekt:
  I-D.ietf-avtext-rtp-grouping-taxonomy:
  I-D.ietf-dart-dscp-rtp:
  I-D.ietf-mmusic-trickle-ice:
  I-D.ietf-rmcat-cc-requirements:
  I-D.ietf-rtcweb-audio-codecs-for-interop:
  I-D.ietf-rtcweb-use-cases-and-requirements:
  I-D.kaufman-rtcweb-security-ui:
  I-D.lennox-payload-ulp-ssrc-mux:
  I-D.nandakumar-rtcweb-sdp:
  I-D.roach-mmusic-unified-plan:
  I-D.westerlund-avtcore-multiplex-architecture:


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
{{I-D.ietf-payload-rtp-opus}}, 
{{I-D.ietf-tsvwg-sctp-ndata}}, 
{{I-D.ietf-rtcweb-data-protocol}}, 
{{I-D.ietf-tsvwg-sctp-dtls-encaps}}, 
{{I-D.ietf-rtcweb-security}}, 
{{I-D.ietf-tsvwg-sctp-prpolicies}}, 
{{I-D.ietf-mmusic-sctp-sdp}}, 
{{I-D.ietf-mmusic-msid}}, 
{{I-D.ietf-mmusic-sctp-sdp}}, 
{{I-D.ietf-mmusic-sdp-bundle-negotiation}}, 
{{I-D.ietf-mmusic-sdp-mux-attributes}}, 
{{I-D.ietf-avtcore-multi-media-rtp-session}}, 
{{I-D.ietf-avtcore-rtp-circuit-breakers}}, 
{{I-D.ietf-avtcore-rtp-multi-stream-optimisation}}, 
{{I-D.ietf-avtcore-rtp-multi-stream}}, 
{{I-D.ietf-avtcore-6222bis}} (now {{RFC7022}}),
{{I-D.ietf-rtcweb-stun-consent-freshness}}, 
{{I-D.hutton-httpbis-connect-protocol}}, 
{{I-D.ietf-tram-alpn}}, 
{{I-D.ietf-tls-applayerprotoneg}} (now {{RFC7301}}),
{{I-D.ietf-httpbis-http2}}, 
{{I-D.ietf-httpbis-header-compression}}, 
{{I-D.petithuguenin-tram-turn-dtls}}, 
{{I-D.ietf-tsvwg-rtcweb-qos}}, 
{{I-D.reddy-mmusic-ice-happy-eyeballs}}, 
{{I-D.ietf-rtcweb-alpn}}, 
{{I-D.ietf-payload-vp8}}.

Right now security normatively depends on
{{I-D.ietf-rtcweb-overview }}.

Right now video normatively depends on
{{I-D.grange-vp9-bitstream}}, 
{{I-D.ietf-payload-rtp-h265}}.

The drafts webrtc currently normatively depends on that are not WG drafts are:
{{I-D.grange-vp9-bitstream}}, 
{{I-D.hutton-httpbis-connect-protocol}}, 
{{I-D.reddy-mmusic-ice-happy-eyeballs}}.

A few key drafts that the work informatively depends on:
{{I-D.ietf-mmusic-trickle-ice}}, 
{{I-D.nandakumar-rtcweb-sdp}}, 
{{I-D.ietf-avtcore-multiplex-guidelines}}, 
{{I-D.ietf-avtcore-rtp-topologies-update}}, 
{{I-D.ietf-avtext-rtp-grouping-taxonomy}}, 
{{I-D.ietf-rmcat-cc-requirements}}, 
{{I-D.ietf-rtcweb-use-cases-and-requirements}}, 
{{I-D.kaufman-rtcweb-security-ui}}, 
{{I-D.alvestrand-rtcweb-gateways}}, 
{{I-D.hutton-rtcweb-nat-firewall-considerations}}, 
{{I-D.ietf-dart-dscp-rtp}}, 
{{I-D.roach-mmusic-unified-plan}}, 
{{I-D.westerlund-avtcore-multiplex-architecture}}, 
{{I-D.lennox-payload-ulp-ssrc-mux}}, 
{{I-D.ietf-avtcore-multiplex-guidelines}}, 
{{I-D.ietf-avtcore-srtp-ekt}}, 
{{I-D.ietf-rtcweb-use-cases-and-requirements}}.

Something audio should ref but does not yet:
{{I-D.ietf-rtcweb-audio-codecs-for-interop}}

Time Estimates
-

The following table has some very rough estimates of when the draft will become an
RFC. Historically these dates have often taken much longer than the estimates
so take this with a large dose of salt.

| Draft Name  | ETA |
|  {{I-D.hutton-httpbis-connect-protocol}}  |       |
|  {{I-D.reddy-mmusic-ice-happy-eyeballs}}  |       |
|  {{I-D.ietf-avtcore-multi-media-rtp-session}}  |       |
|  {{I-D.ietf-avtcore-rtp-circuit-breakers}}  |       |
|  {{I-D.ietf-avtcore-rtp-multi-stream-optimisation}}  |      |
|  {{I-D.ietf-avtcore-rtp-multi-stream}}  |       |
|  {{I-D.ietf-httpbis-header-compression}}  |       |
|  {{I-D.ietf-httpbis-http2}}  |       |
|  {{I-D.ietf-mmusic-msid}}  |       |
|  {{I-D.ietf-mmusic-sctp-sdp}}  |       |
|  {{I-D.ietf-mmusic-sdp-bundle-negotiation}}  |       |
|  {{I-D.ietf-mmusic-sdp-mux-attributes}}  |       |
|  {{I-D.ietf-payload-rtp-h265}}  |       |
|  {{I-D.ietf-payload-rtp-opus}}  |       |
|  {{I-D.ietf-payload-vp8}}  |       |
|  {{I-D.ietf-rtcweb-alpn}}  |       |
|  {{I-D.ietf-rtcweb-audio}}  |       |
|  {{I-D.ietf-rtcweb-constraints-registry}}  |       |
|  {{I-D.ietf-rtcweb-data-channel}}  |       |
|  {{I-D.ietf-rtcweb-data-protocol}}  |       |
|  {{I-D.ietf-rtcweb-data-protocol}}  |       |
|  {{I-D.ietf-rtcweb-jsep}}  |   2015 Oct    |
|  {{I-D.ietf-rtcweb-overview }}  |       |
|  {{I-D.ietf-rtcweb-overview}}  |       |
|  {{I-D.ietf-rtcweb-rtp-usage}}  |       |
|  {{I-D.ietf-rtcweb-security-arch}}  |       |
|  {{I-D.ietf-rtcweb-security}}  |       |
|  {{I-D.ietf-rtcweb-security}}  |       |
|  {{I-D.ietf-rtcweb-stun-consent-freshness}}  |       |
|  {{I-D.ietf-rtcweb-transports}}  |       |
|  {{I-D.ietf-rtcweb-video}}  |       |
|  {{I-D.ietf-tsvwg-rtcweb-qos}}  |       |
|  {{I-D.ietf-tsvwg-sctp-dtls-encaps}}  |       |
|  {{I-D.ietf-tsvwg-sctp-ndata}}  |       |
|  {{I-D.ietf-tsvwg-sctp-prpolicies}}  |       |
|  {{I-D.grange-vp9-bitstream}}  |       |
|  {{I-D.ietf-tram-alpn}}  |   2014 Nov   |
|  {{I-D.ietf-tram-stun-dtls}}  |    {{RFC7350}}   |
|  {{I-D.ietf-tls-applayerprotoneg}}  |   {{RFC7301}}    |
|  {{I-D.ietf-avtcore-6222bis}}  |   {{RFC7022}}    |
|  {{I-D.nandakumar-rtcweb-stun-uri}}  |   {{RFC7064}}    |
|  {{I-D.petithuguenin-behave-turn-uris}}  |   {{RFC7065}}    |
|  {{I-D.ietf-avtcore-avp-codecs}}  |   {{RFC7007}}    |
|  {{I-D.ietf-avtcore-srtp-encrypted-header-ext}}  |   {{RFC6904}}    |
|  {{I-D.ietf-avtext-multiple-clock-rates}}  |   {{RFC7160}}    |













