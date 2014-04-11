---
title: "WebRTC Video Processing and Codec Requirements"
abbrev: WebRTC Video
docname: draft-ietf-rtcweb-video-00
date: 2014-04-11
category: std
ipr: trust200902
toc: yes
sortrefs: yes
symrefs: yes

author:
 -
    ins: A. Roach
    name: Adam Roach
    email: adam@nostrum.com
    phone: +1 650 903 0800 x863
    org: Mozilla 
    city: Dallas
    country: US


normative:
  RFC2119:
  RFC6562:

informative:
  I-D.ietf-rtcweb-audio:
  I-D.ietf-rtcweb-security:
  I-D.ietf-rtcweb-security-arch:
  RFC4175:
  RFC4421:


--- abstract

This specification provides the requirements and consideration for WebRTC
applications to process video. It specifies the video processing that is
required, the codecs, and types of RTP packtization that need to be supported.

--- middle



# Introduction

WebRTC endpoints can use interactive video.The video might come from a camera,
screen recording, stored file, or other source. This specification defines how
the video is used and special considerations for processing the video as well as
algorithms WebRTC devices need to support.



# Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in {{RFC2119}}.



# Pre and Post Processing 

The section provides guidance on pre or post processing recommendations for
handling video.

To support a quality experience with no application level adjustment from the
 Javascript running in the browsers, WebRTC endpoints are REQUIRED to support:

* auto focus or a camera that does not require focus adjustment for use

* auto white balance 

* auto light level control 
 
Unless specified otherwise by the SDP or Codec, the color space SHOULD be TBD.



# Screen Source Video

If the video source is some portion of a computer screen for desktop or
application sharing, then some additional consideration are needed as described
in this section.



# Codec Specific Considerations

WebRTC endpoint are not required to support all the codecs in this section, but
if they do support one of these codecs, then they need to meet the requirements
specified in the subsection for that codec.

## VP8 

## H.264 

## VP9

## H.265 

## Uncompressed Video 

A typical data rate for uncompressed HD video may be around 1.5 Gbps but this is
still useful for applications that are not running across the internet or
applications using small frame or low frame rates. For example, uncompressed
video may be passed to a local codec that does the compression or may be passed
to a local machine visions system which typically work better with uncompressed
video.

Devices which support uncompressed video MUST support the payload formats
defined in {{RFC4421}} and {{RFC4175}}. 



# Dealing with Packet Loss 

This section provides recommendations on how to encode video to be robust to
packet loss.



# Mandatory to Implement Video Codecs

Note: This section is here purely as a placeholder and there is not yet WG
Consensus on Mandatory to Implement video codecs. The WG has agree not to
discuss this topic until September 29, 2014 so that the WG can focus on getting
other work done. Please, save your comment on this section until that time.

There is a strong need for some minimim set of mandatory to implement (MTI)
video codecs or there will be interoperability failures when one WebRTC
compliant endpoint trying to communicate with another WebRTC compliant end point
that does nto have any codec in common. The working group discussed this
extensively and deeply considered many issues including patents, availability of
implementation, quality and efficiency of codecs, hardware and software
implementations, power consumption, and many other issues. A wide range of
codecs were considered and the WG does feel that at least one MTI codec is
required.

The current status of the WG is the four options that might
be able to achieve consensus are:

1. All entities MUST support H. 264

2. All entities MUST support VP8

3. All entities MUST support both H.264 and VP8

4. Browsers MUST support both H.264 and VP8, other entities MUST support at
least one of H.264 and VP8



# Security Considerations

This specification does not introduce any new mechanisms or security concerns
beyond what the other documents it references. In WebRTC, video is protected
using DTLS/SRTP. A complete discussion of the security can be found in
{{I-D.ietf-rtcweb-security}} and {{I-D.ietf-rtcweb-security-arch}}. Implementers
should consider whether the use of variable bit rate video codecs are
appropriate for their application based on {{RFC6562}}.



# IANA Considerations

This document requires no actions from IANA.



# Acknowledgements

The authors would like to thank <GET YOUR NAME HERE - PLEASE SEND
COMMENTS>. Thanks to Cullen Jennings for providing text and review.
