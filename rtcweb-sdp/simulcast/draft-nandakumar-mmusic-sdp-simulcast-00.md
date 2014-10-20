---
title: MultiSource Multistream Simulcast Negotiation in SDP
abbrev: simulcast
docname: draft-nandakumar-mmusic-sdp-simulcast-00
date: 2014-10-10
category: std
ipr: trust200902
pi: [toc, sortrefs, symrefs]

author:
 -
    ins: S. Nandakumar
    name: Suhas Nandakumar
    organization: Cisco Systems
    email: snandaku@cisco.com

normative:

  RFC2119:

  RFC4566:

informative:


--- abstract

Simulcast, in the context of Real-time communcation applications
involves being able to send multiple differently encoded streams
of a given media source in independent RTP Streams. 

This document provides mechanism to describe and negotiate Simulcast
using Session Description Protocol based Offer/Answer negotiation
framework in a RTP Session. This document also provides a modest set of
extensions to SDP to describe relationship between a media source,
SDP media descriptions and RTP streams in order to better
handle aribitrary numbers of flows while still retaining  a large
degree of backward compatability. 

--- middle

# Introduction

Most of today's multiparty video conference solutions make use of
centralized servers to reduce the bandwidth and CPU consumption in
the endpoints.  Those servers receive RTP streams from each
participant and send some suitable set of possibly modified RTP
streams to the rest of the participants, which usually have
heterogeneous capabilities (screen size, CPU, bandwidth, codec, etc).
One of the biggest issues is how to perform RTP stream adaptation to
different participants' constraints with the minimum possible impact
on both video quality and server performance.

Simulcast is defined in this memo as the act of simultaneously
sending multiple different encoded streams of the same media source,
e.g. the same video source encoded with different video encoder types
or image resolutions.  This can be done in several ways and for
different purposes.  This document focuses on the case where it is
desirable to provide a media source as multiple encoded streams over
RTP  towards an intermediary so that the intermediary can
selectively choose the approporiate RTP Stream to be forwarded
to other participants in the session. This document also provides
mechanism for identicaition and grouping of the involved RTP Streams
used for Simulcasting purposes.

From an RTP perspective, simulcast is a specific application
of the aspects discussed in RTP Multiplexing Guidelines




## Terminology

This document makes use of the terminology defined in RTP Taxonomy
[I-D.ietf-avtext-rtp-grouping-taxonomy], RTP Topology [RFC5117] and
RTP Topologies Update [I-D.ietf-avtcore-rtp-topologies-update].  In
addition, the following terms are used:

RTP Mixer:  An RTP middle node, defined in [RFC5117] (Section 3.4:
Topo-Mixer), further elaborated and extended with other topologies
in [I-D.ietf-avtcore-rtp-topologies-update] (Section 3.6 to 3.9).

RTP Switch:  A common short term for the terms "switching RTP mixer",
"source projecting middlebox", and "video switching MCU" as
discussed in [I-D.ietf-avtcore-rtp-topologies-update].

Simulcast version:  One encoded stream from the set of encoded
streams that constitutes the simulcast for a single media source.

Simulcast version alternative:  One encoded stream being encoded in
one of possibly multiple alternative ways to create a simulcast
version.


## Notational Conventions

In this document, the key words "MUST", "MUST NOT", "REQUIRED",
"SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY",
and "OPTIONAL" are to be interpreted as described in BCP 14, RFC 2119
{{RFC2119}}.


# Use Case
Many use cases of simulcast as described in this document relate to a
multi-party communication session where one or more central nodes are
used to adapt the view of the communication session towards
individual participants, and facilitate the media transport between
participants.  Thus, these cases targets the RTP Selective Forwarding
Middlebox Topology. The middleboxes in such a topology are usually
termed as Selective and Forwarding Unit (SFU).

A typical SFU switches a subset of all received RTP streams or sub-streams 
to each receiving participant, where the used subset is typically
specific to each receiving participant.  The main advantages of
this approach are that it is computationally cheap to the RTP
Mixer and it has very limited impact on media QoE.  The main
disadvantage is that it can be difficult to combine a subset of
received RTP streams into a perfect fit to the resource situation
of a receiving participant.

A typical example of such a topology showing 3 participants
showing varying sending and receiving capabilties is shown below.

~~~

    A               +---------+             C
+-------+           |         |         +--------+
|       |---------> |         |<======= |        |
|       |=========> |         |         |        |
|       |<========= |         |         |        |
|       |<--------- |         |=======> |        |
|       |<+++++++++ |         |         |        |
+-------+           |    S    |         +--------+
                    |         |
                    |    F    |
    B               |         |
+-------+           |    U    |
|       |---------> |         |
|       |=========> |         |
|       |           |         |
|       |           |         |
|       |<----------|         |
+-------+           |         |         
                    +---------+
~~~


In the above picure, ====> represent HD quality video, ------> SD Quality
video and +++++> capture medium qulaity video streams.


# Solution Requirements
This section lists the requirements that needs to be satified
for successfuly negotiating Simucalst session in a multi-party
video conferences based on SDP Offer/Answer protocol.

REQ-1:  Media Source Encodings Identification.  
        It must be possible to identify a set of simulcasted RTP streams as 
originating from the same media source:

REQ-1.1:  In SDP signaling.

REQ-1.2:  On RTP/RTCP level.
The solution must provide mechanisms to identify Media Capture Sources
in a end-to-end fashion.

REQ-2:  Transport usage.  The solution must work when using:

REQ-2.1:  Legacy SDP with separate media transports per SDP media
description.

REQ-2.2:  Bundled SDP media descriptions.

REQ-3:  Expressing Simulcast Capability.  It must be possible that:

REQ-3.1:  Sender can express capability of sending simulcast.

REQ-3.2:  Receiver can express capability of receiving simulcast.

REQ-3.3:  Sender can express maximum number of simulcast versions
that can be provided.

REQ-3.4:  Receiver can express maximum number of simulcast
versions that can be received.

REQ-3.5:  Sender can detail the characteristics of the simulcast
versions that can be provided.

REQ-3.6:  Receiver can detail the characteristics of the simulcast
versions that it prefers to receive.

REQ-4:  Compatibility.  It must be possible to use simulcast in
combination with other RTP mechanisms that generate additional RTP
streams:

REQ-4.1:  RTP Retransmission [RFC4588].

REQ-4.2:  RTP Forward Error Correction [RFC5109].

REQ-4.3:  Related payload types such as audio Comfort Noise and/or
DTMF.

REQ-5:  Interoperability.  The solution must be possible to use in:

REQ-5.1:  Interworking with non-simulcast legacy clients using a
single media source per media type.

REQ-5.2:  WebRTC "Unified Plan" environment with a single media
source per SDP media description.


# Proposed Solution
In order to support above set of requirements, the following sub-sections
captures various aspects of the whole solution

## Media Capture Source Identification
Media Capture Source ID is used to uniquley identify a physical media capture
source such as microphone or camera within an RTP Session. It is required that
such an identifier be preserved by the SFU middlebox in order to appropriate
mapping betweent the received RTP Streams and their Sources at the receivers.

TODO: What needs to be in SDP vs What needs to be in RTP or RTCP ???
Do we just use MSID draft, but we do need something in RTP or RTCP though ?

## Media Source Encoding Identification
 A given end-point MAY have multiple sources of the same type along with
multiple simulcast encodings per source. The codec configuration for each 
simulcast encoding is expressed in terms of existing SDP formats 
(and typically RTP payload types). Some codecs may rely on codec configuration 
based on general attributes that apply for all formats within a media description,
and which could thus not be used to separate different simulcast
versions.  This memo makes no attempt to address such
shortcomings, but if needed instead encourages that a separate,
general mechanism is defined for that purpose.


## Grouping Media Source Encodings
In order to express set of encodings that can be sent per media source,
this document proposes a extension to SDP that is defined as a media level
SDP attribute called "a=simulcast".  The meaning of the attribute on SDP
session level is undefined and MUST NOT be used.  There MUST be at
most one "a=simulcast" attribute per media description.  The ABNF
[RFC5234] for this attribute is:

~~~
simulcast-attribute = "a=simulcast" 1*3( WSP sc-dir-list )
sc-dir-list         = sc-dir WSP sc-fmt-list *( ";" sc-fmt-list )
sc-dir              = "send" / "recv" / "sendrecv"
sc-fmt-list         = sc-fmt *( "," sc-fmt )
sc-fmt              = fmt
; WSP defined in [RFC5234]
; fmt defined in [RFC4566]

~~~


## Dealing with Sender and Receiver Asymmetry  

Simulcasting exposes the asymmtery that exists between sending
and receiving capabilties for a given participant. For example, even though
a participant is capable of sending a single high-quality video stream,
it might be capable of receiving multiple video streams. In order 
to support this inherent asymmetry, the proposal provides coarse and
granular controls both at the media source level as well as at the level
of media encodings respectively.


## Dealing with Multiplexed RTP Streams
  BUNDLE provides a mechanism for signaling multiplexing several RTP media streams
over a single underlying transport in SDP. BUNDLE machanism proposal repetition
of RTP payload types across all the multiplexed media streams. To enable
de-mulitplexing of received RTP Streams to approporiate SDP media description
this document requires the end-points to signal MIDs in RTP/RTCP as defined
in Section 13 of BUNDLE mechanism.


## Representing Protected Streams
    This document proposes an extension to RFC5583 Media Decoding dependency
attribute to associate a given Simulcast encoding with a FEC stream that protects
it. 

For this purpose, a new depedency-type called "fec" is added to RFC5583 ABNF as shown
below

~~~
depend-attribute =
"a=depend:" dependent-fmt SP dependency-tag
*(";" SP dependent-fmt SP dependency-tag) CRLF

dependency-tag   =
dependency-type *1( SP identification-tag ":"
fmt-dependency *("," fmt-dependency ))

dependency-type  = "lay"
/ "mdc"
/ "fec"
/ token

dependent-fmt = fmt

fmt-dependency = fmt
~~~


# SDP Examples

All the SDP examples given below assume one media capture source per media 
description.


## Multi-Source Client without BUNDLE support
In the SDP example below, Alice is a multi-source client with
two cameras each capable of sending two Simulcast streams per
source. Alice has 3 display system.

The first two simulcast versions for the first media source use
different codecs, H264 [RFC6190] and VP8.

The second media source is offered with two different simulcast
versions with VP8 as the codec.

~~~
v=0
o=fred 238947129 823479223 IN IP4 192.0.2.125
s=Offer from Simulcast Enabled Multi-Source Client
t=0 0
c=IN IP4 192.0.2.125
b=AS:825
a=group:BUNDLE foo bar zen
m=video 49600 RTP/AVP 102 103
b=AS:3500
a=mid:bar
a=rtpmap:102 H264/90000
a=fmtp:102 profile-level-id=42c00d; max-fs=900; max-mbps=27000
a=imageattr:102 send [x=640,y=360] recv [x=640,y=360]
a=rtpmap:103 VP8/90000
a=fmtp:103 max-fs=900; max-fr=30
a=imageattr:103 send [x=640,y=360] recv [x=640,y=360]
a=simulcast sendrecv 102;103
m=video 49602 RTP/AVP 96 97
b=AS:3500
a=mid:zen
a=rtpmap:96 VP8/90000
a=fmtp:96 max-fs=3600; max-fr=30
a=rtpmap:97 VP8/90000
a=fmtp:97 max-fs=240; max-fr=15
a=rtcp-mid
a=simulcast send 97;96 recv 87
~~~

## Multi-Source Client with BUNDLE support and RTX.
Fred is calling in to the  conference with a two-camera, two-display system, 
thus capable of handling two separate media sources in each direction, 
where each media source is simulcast-enabled in the send direction.  
Fred's client is a Unified Plan client, restricted to a single media source 
per media description.

The first two simulcast versions for the first media source use
different codecs, H264-SVC [RFC6190] and H264 [RFC6184].  These two
simulcast versions also have a temporal dependency.  Two different
video codecs, VP8 [I-D.ietf-payload-vp8] and H264, are offered fr
the next of couple of simulcast versions.

The second media source is offered with three different simulcast
versions.  All video streams of this second media source are loss
protected by RTP retransmission [RFC4588].

~~~
v=0
o=fred 238947129 823479223 IN IP4 192.0.2.125
s=Offer from Simulcast Enabled Multi-Source Client
t=0 0
c=IN IP4 192.0.2.125
b=AS:825
a=group:BUNDLE foo bar zen
m=video 49600 RTP/AVP 100 101 102 103
b=AS:3500
a=mid:bar
a=rtpmap:100 H264-SVC/90000
a=fmtp:100 profile-level-id=42400d; max-fs=3600; max-mbps=108000; \
mst-mode=NI-TC
a=imageattr:100 send [x=1280,y=720] [x=640,y=360] \
recv [x=1280,y=720] [x=640,y=360]
a=rtpmap:101 H264/90000
a=fmtp:101 profile-level-id=42c00d; max-fs=3600; max-mbps=54000
a=depend:100 lay bar:101
a=imageattr:101 send [x=1280,y=720] [x=640,y=360] \
recv [x=1280,y=720] [x=640,y=360]
a=rtpmap:102 H264/90000
a=fmtp:102 profile-level-id=42c00d; max-fs=900; max-mbps=27000
a=imageattr:102 send [x=640,y=360] recv [x=640,y=360]
a=rtpmap:103 VP8/90000
a=fmtp:103 max-fs=900; max-fr=30
a=imageattr:103 send [x=640,y=360] recv [x=640,y=360]
a=rtcp-mid
a=extmap:1 urn:ietf:params:rtp-hdrext:mid
a=simulcast sendrecv 100;101 send 103;102
m=video 49602 RTP/AVP 96 103 97 104 105 106
b=AS:3500
a=mid:zen
a=rtpmap:96 VP8/90000
a=fmtp:96 max-fs=3600; max-fr=30
a=rtpmap:104 rtx/90000
a=fmtp:104 apt=96;rtx-time=200
a=rtpmap:103 VP8/90000
a=fmtp:103 max-fs=900; max-fr=30
a=rtpmap:105 rtx/90000
a=fmtp:105 apt=103;rtx-time=200
a=rtpmap:97 VP8/90000
a=fmtp:97 max-fs=240; max-fr=15
a=rtpmap:106 rtx/90000
a=fmtp:106 apt=97;rtx-time=200
a=rtcp-mid
a=extmap:1 urn:ietf:params:rtp-hdrext:mid
a=simulcast send 97;96;103

~~~

## Multi-Source Client without BUNDLE support and FEC
In the SDP example below, Alice is a single-source client with
one camera  capable of sending two Simulcast streams along
with protected FEC streams.

~~~
v=0
o=fred 238947129 823479223 IN IP4 192.0.2.125
s=Offer from Simulcast Enabled Multi-Source Client
t=0 0
c=IN IP4 192.0.2.125
b=AS:825
a=group:BUNDLE foo bar zen
m=video 49602 RTP/AVP 96 97 116 117
b=AS:3500
a=mid:zen
a=rtpmap:96 VP8/90000
a=fmtp:96 max-fs=3600; max-fr=30
a=fmtp:97 max-fs=240; max-fr=15
a=rtpmap:97 VP8/90000
a=fmtp:97 max-fs=240; max-fr=15
a=rtpmap:116 red/90000
a=rtpmap:117 ulpfec/90000
a=depend:96 fec zen:116
a=depend:97 fec zen:116,117
a=simulcast send 96;97 
~~~


# Security Considerations
he simulcast capability and configuration attributes and parameters
are vulnerable to attacks in signaling.

A false inclusion of the "a=simulcast" attribute may result in
simultaneous transmission of multiple RTP streams that would
otherwise not be generated.  The impact is limited by the media
description joint bandwidth, shared by all simulcast versions
irrespective of their number.  There may however be a large number of
unwanted RTP streams that will impact the share of the bandwidth
allocated for the originally wanted RTP stream.

A hostile removal of the "a=simulcast" attribute will result in
simulcast not being used.
Neither of the above will likely have any major consequences and can
be mitigated by signaling that is at least integrity and source
authenticated to prevent an attacker to change it.


