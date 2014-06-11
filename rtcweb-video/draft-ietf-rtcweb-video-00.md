---
title: "WebRTC Video Processing and Codec Requirements"
abbrev: WebRTC Video
docname: draft-ietf-rtcweb-video-00
date: 2014-04-11
category: std
ipr: trust200902

coding: us-ascii

pi:
  toc: yes
  sortrefs: yes
  symrefs: yes

author:
 -
    ins: A. B. Roach
    name: Adam Roach
    email: adam@nostrum.com
    phone: +1 650 903 0800 x863
    org: Mozilla
    street: \
    city: Dallas
    country: US

normative:
  RFC2119:
  RFC6562:

  RFC4175:
  RFC4421:

  H264:
    title: "Advanced video coding for generic audiovisual services"
    date: April 2013
    author:
      org: ITU-T Recommendation H.264
    #target: http://www.itu.int/rec/T-REC-H.264-201304-I
  RFC6184:

  RFC6386:
  I-D.ietf-payload-vp8:

  H265:
    title: "High efficiency video coding"
    date: April 2013
    author:
      org: ITU-T Recommendation H.265
    #target: http://www.itu.int/rec/T-REC-H.265-201304-I
  I-D.ietf-payload-rtp-h265:

  I-D.grange-vp9-bitstream:


informative:
  I-D.ietf-rtcweb-security:
  I-D.ietf-rtcweb-security-arch:


--- abstract

This specification provides the requirements and consideration for WebRTC
applications to send and receive video across a network. It specifies the
video processing that is required, codecs and their parameters, and types of
RTP packetization that need to be supported.

--- middle



Introduction
============

One of the major functions of WebRTC endpoints is the ability to send and
receive interactive video. The video might come from a camera, a screen
recording, a stored file, or some other source. This specification defines how
the video is used and discusses special considerations for processing the video.
It also covers the video-related algorithms WebRTC devices need to support.



Terminology
===========

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in {{RFC2119}}.



Pre and Post Processing
=======================

This section provides guidance on pre- or post-processing of video streams.

Unless specified otherwise by the SDP or Codec, the color space SHOULD be TBD.

TODO: What color space is our default?

Camera Source Video
-------------------

To support a quality experience with no application level adjustment from the
Javascript running in the browsers, WebRTC endpoints are REQUIRED to support:

* Automatic focus, if applicable for the camera in use

* Automatic white balance

* Automatic light level control


TODO: What other processing should be specified here?


Screen Source Video
-------------------

If the video source is some portion of a computer screen (e.g., desktop or
application sharing), then the considerations in this section also apply.

TODO: What do we need to specify here?



Codec Considerations
====================

WebRTC endpoints are not required to support all the codecs in this section.

However, to foster interoperability between endpoints that have codecs in
common, if they do support one of the listed codecs, then they need to meet
the requirements specified in the subsection for that codec.

All codecs MUST support at least 10 frames per second (fps) and SHOULD support
30 fps. All codecs MUST support a minimum resolution of 320X240.

TODO: These are strawman values. Are they adequate?


VP8
-------------------------

If VP8, defined in {{RFC6386}}, is supported, then the endpoint MUST support
the payload formats defined in {{I-D.ietf-payload-vp8}}. In addition it MUST
support the 'bilinear' and 'none' reconstruction filters.


H.264
-------------------------

If {{H264}} is supported, then the device MUST support the payload formats
defined in {{RFC6184}}. In addition, they MUST support Constrained Baseline
Profile Level 1.2, and they SHOULD support H.264 Constrained High Profile
Level 1.3.

TODO: What packetization modes MUST be supported?


VP9
-------------------------

If VP9, as defined in {{I-D.grange-vp9-bitstream}}, is supported, then the
device MUST support the payload formats defined in TODO. 

TODO: The grange-vp9-bitstream draft does not really specify VP9 at all, is
there a better reference?



H.265
-------------------------

If {{H265}} is supported, then the device MUST support the payload formats
defined in {{I-D.ietf-payload-rtp-h265}}.


{::comment}
Uncompressed Video
-------------------------

A typical data rate for uncompressed HD video may be around 1.5 Gbps but this is
still useful for applications that are not running across the internet or
applications using small frame or low frame rates. For example, uncompressed
video may be passed to a local codec that does the compression or may be passed
to a local machine visions system which typically work better with uncompressed
video.

Devices which support uncompressed video MUST support the payload formats
defined in {{RFC4175}} and the color sampling modes described in {{RFC4421}}.
{:/comment}


Dealing with Packet Loss
========================

This section provides recommendations on how to encode video to be robust to
packet loss.

TODO: What do we want to require in terms of FEC, RTX, interleaving, etc?


Mandatory to Implement Video Codec
==================================

Note: This section is here purely as a placeholder and there is not yet WG
Consensus on Mandatory to Implement video codecs. The WG has agreed not to
discuss this topic until September 29, 2014 so that the WG can focus on getting
other work done. Please, save your comments on this topic until that time.

The currently recorded working group consensus is that all implementations
MUST support a single, specified mandatory-to-implement codec. The remaining
decision point is a selection of this single codec.

{::comment}
There is a need for some minimum set of mandatory to implement (MTI) video
codecs or there will be interoperability failures when one WebRTC compliant
endpoint trying to communicate with another WebRTC compliant end point that does
not have any codec in common. The working group discussed this extensively and
deeply considered many issues including patents, availability of implementation,
quality and efficiency of codecs, hardware and software implementations, power
consumption, and many other issues. A wide range of codecs were considered and
the WG does feel that at least one MTI codec is required.

The current status of the WG is the four options that might be able to achieve
consensus are:

1. All entities MUST support H. 264

2. All entities MUST support VP8

3. All entities MUST support both H.264 and VP8

4. Browsers MUST support both H.264 and VP8, other entities MUST support at
least one of H.264 and VP8
{:/comment}


Security Considerations
=======================

This specification does not introduce any new mechanisms or security concerns
beyond what the other documents it references. In WebRTC, video is protected
using DTLS/SRTP. A complete discussion of the security can be found in
{{I-D.ietf-rtcweb-security}} and {{I-D.ietf-rtcweb-security-arch}}. Implementers
should consider whether the use of variable bit rate video codecs are
appropriate for their application based on {{RFC6562}}.



IANA Considerations
===================

This document requires no actions from IANA.



Acknowledgements
================

The authors would like to thank <GET YOUR NAME HERE - PLEASE SEND
COMMENTS>. Thanks to Cullen Jennings for providing text and review. This draft
includes text from draft-cbran-rtcweb-codec.
