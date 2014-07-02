---
title: "Requirements for Secure RTP Media Switch"
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

This draft outlines the requirements for enabling media switches to form a multimedia multi-user conferences without needing to have the
keys used to encrypt the media in the conference.

--- middle



Introduction
============

Modern audio and video conferencing systems include RTP middleboxes that can often "switch" video and audio streams without mixing them.   When receivers have homogenous coding capabilities and can receive multiple streams each, such Media Switching mixers avoid the need to decode and re-encode media for the purpose of compositing video or mixing audio [RTP-TOP].  Instead they can forward encoded media as it was sent by the transmitter.  

Such Media Switching mixers may selectively forward only certain transmitted stream(s) at any given time, such as the video and audio stream from the currently active speaker. When a Media Switching Mixer provides the receiver with only the latest speaker(s), it selects the source from the different transmitter’s RTP sessions and must rewrite the RTP header when forwarding them into the receiver’s session [RTP-TOP].  Thus, Media Switching mixers have had to be trusted to decrypt and re-encrypt all of the present SRTP context to perform these header rewrites.

Modern audio and video conferencing systems have decomposed media switching mixer devices into a) a controller that deals with the signaling and keeps track of who is in the conference and b) one or more Media Switches that receive, rewrite headers and transmit streams to receivers.  In scalable systems, media switches may be deployed in many distributed locations to optimize bandwidth or latency and may be rented on demand from third-parties to meet peak loading needs. Therefore, there is a need to locate Media Switches in data centers and/or be operated by third-parties not otherwise trusted with decryption or encryption of audio and video media.  

This draft outlines the requirements for enabling Media Switches to perform the functions they need to – including header rewites and authenticating transmitters and receivers – without having to acquire or use the keys needed to decrypt the audio and video media in SRTP. This enables deployments where the privacy of the media can be assured even when a third-party service is used for media switching.


Terminology
===========

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.


Switched Media Architecture
============================

In traditional conferencing systems, the conferencing media infrastructure fully decrypts, decodes and processes RTP media streams received from one or more transmitters prior to forwarding the newly encoded (transcoded, composited and/or mixed) and encrypted RTP media streams to the rest of receivers.  Media Switching Mixers, which may or may not need to transcode, composite or mix the media, maintain independent and persistent SRTP sessions with each endpoint [RTP-TOP]. More specifically, each endpoint establishes a point-to-point SRTP session with conferencing media infrastructure, which has its own persistent SSRCs, SRTP keys and SRTP contexts (Figure 1).

~~~~~~~~~~
   +---+      +--------------------+      +---+
   | A |<---- | Encrypt    Decrypt |<---- | C |
   +---+      |   ^          v     |      +---+
              |  Traditional MCU   |
              |     or  Mixer      |
   +---+      |   v          v     |      +---+
   | B |<---- | Encrypt    Encrypt | ---->| D |
   +---+      +--------------------+      +---+
~~~~~~~~~~
{: #figmcu title="Traditional MCU or Mixer"}


When receivers have homogenous coding capabilities and can receive multiple streams each, a media switcher can avoid processing media and (selectively) forward streams while manipulating only the necessary parts of the RTP headers prior to forwarding to receivers.  The RTP payload part of streams from transmitters is forwarded without any processing or changes.  

In this case, a media switcher can act like a Scalable RTP Translator Forwarding Unit, maintaining the SSRCs of the transmitting endpoints rather than generating their own persistent SSRCs towards every receiving endpoint (figure 2). Though this is not the only viable embodiment of a media switching architecture, this is the most relevant for the requirements discussed in this document.

~~~~~~~~~~
   +---+      +--------------------+      +---+
   | A |<---- |                    |<---- | C |
   +---+      |                    |      +---+
              |   RTP Translator   |
              |  Forwarding Unit   |
   +---+      |                    |      +---+
   | B |<---- |                    | ---->| D |
   +---+      +--------------------+      +---+
~~~~~~~~~~
{: #figstfu title="Scalable Translator Forwarding Unit"}


In such media switching architectures, endpoints can receive media from different transmitters at different times e.g. when receiving the video associated with the most active speaker. In this case endpoints receive different RTP video streams that are generated by different transmitters each with its own SSRC, SRTP key and SRTP context. All these streams are rendered to the end user as a single video source representing the most active speaker. Moreover endpoints do not receive the same RTP streams all the times. For example in the figure below endpoint 1,2 and 3 can be receiving video streams from endpoint 4 who is currently the active speaker while endpoint 4 is receiving video from endpoint 1 who is the previous active speaker. Once endpoint 2 become the active speaker then endpoint 1,3 and 4 will start to receive video from endpoint 2 while endpoint 2 continue to receive video from endpoint 4. (include figure 3) 


~~~~~~~~~~
Time 1
(Prev Speaker)     ______________           (Active Speaker)
 User A >a>a>a>a>a>|            |>a>a>a>a>a> User C
        <c<c<c<c<c<|            |<c<c<c<c<c<
                   | RTP        |
                   | Forwarding |
 User B <c<c<c<c<c<|            |>c>c>c>c>c> User D
                   |____________|
~~~~~~~~~~

~~~~~~~~~~
Time 2             ______________           (Prev Speaker)  
 User A <b<b<b<b<b<|            |>b>b>b>b>b> User C
                   |            |<c<c<c<c<c<
                   | RTP        |
(Active Speaker)   | Forwarding |
 User B <c<c<c<c<c<|            |>b>b>b>b>b> User D
        >b>b>b>b>b>|____________|
~~~~~~~~~~

~~~~~~~~~~
Time 3
(Active Speaker)   ______________           
 User A >a>a>a>a>a>|            |>a>a>a>a>a> User C
        <b<b<b<b<b<|            |
                   | RTP        |
(Prev Speaker)     | Forwarding |
 User B <a<a<a<a<a<|            |>a>a>a>a>a> User D
        >b>b>b>b>b>|____________|
~~~~~~~~~~
{: #figmedia title="Media Flow"}


As stated before one of the objectives of media switching architecture is the scalability and simplicity of the media switches. This objective starts with minimizing/eliminating the media processing performed by the switch but can also to be extended to cryptography where crypto processing performed by the switch as well as crypto state maintained by the switch are minimized. More importantly and with the advent of cloud-based computing, it is essential to enable the media switching infrastructure to run in a cloud deployment while restricting such infrastructure from accessing and manipulation of media content. This enables for example enterprises to use cloud-based conferencing services while ensuring the privacy of their media as it gets switched via the cloud infrastructure. In other words the ability to eliminate the need of media switches to decrypt and re-encrypt packets is not merely a scalability and simplicity requirement but is also a core security requirement.


RTP header manipulation
=======================

A conferencing switch might need to modify some of the RTP header fields to map between different values picked by different endpoints prior to switching. An example is the RTP payload type values which for SIP endpoints calling into the conference are picked by the endpoints. Different endpoints are likely to pick different values for the same media format. The conferencing switch is responsible for mapping between such different values. In the case of RTP payload types, the conference infrastructure might be able to send a SIP reinvite to renegotiate the RTP payload type value down to a shared value hence avoiding the remapping. This mechanism does not always work as endpoints can choose to use asymmetric payload types. Renegotiation also adds complexity and delays to the conferencing infrastructure. Other RTP header fields such as RTP extension headers can also be modified, deleted or added as they are negotiated separately with each participants. 

On the other hand two of the RTP fields must not be modified by media switches that do not have access to the media encryption keys. These two fields are the SSRC and the RTP sequence number. Both fields are used in the calculation of the SRTP cipher's IV thus requiring a total re-encryption upon modification.

Below is the set of RTP header fields along with whether a conferencing switch might modify them, unlikely to modify them or must not modify them.

- Version (V): This field is unlikely to be modified by the media switch
- Padding marker (P): This field is unlikely to be modified by the media switch
- Extension (X): The media switch might modify this field when it needs to add RTP extension headers where none existed or if it needs to delete existing RTP extension headers
- Contributing sources count (CC): The media switch is unlikely to modify this field
- Marker bit (M): This field is unlikely to be modified by the media switch
- Payload Type (PT): The media switch might modify this field to map between different RTP type values picked by different endpoints
- Sequence Number (SEQ): The media switch must not modify this field
- Timestamp (TS): This field is unlikely to be modified by the media switch
- Synchronization Source (SSRC): This field must not be modified by the media switch
- Extension Header (ExtHDR): The media switch is likely modify this field either to change its value or to delete it completely
        

Requirements
===========

The following are the security solution requirements for media switches that enable media privacy to be maintained across participants. 

1. Solution needs to maintain all current SRTP security properties.

2.  Solution need to extend replay attacks protection to cover cross-participants replay prevention. Packets sent between the media switch and participant A cannot be retransmitted to participant B undetected.


3.  Keys used for encryption and authentication of RTP payloads and other information deemed unsuitable for accessibility by the media switching infrastructure must not be generated by or accessible to the switching infrastructure. 

4.  The media switching infrastructure must be capable, if authorized, of changing any part of an RTP header except for the RTP sequence number and SSRC. This in turn mandates that the switching infrastructure must have access to the keys used for the authentication of RTP header fields other than SSRC and RTP sequence number when a proper authorization is in place. 

5.  The above two requirements mandate a split key and split authentication model for SRTP. Instead of the current single SRTP master key, this document requires two independent SRTP master keys. The first is an end to end key that is used for the encryption of the RTP payload and other information requiring end to end encryption. The end to end key is also used for the authentication of the RTP payload, the RTP sequence number and SSRC as well as any other information requiring end to end authentication . The second key is hop by hop key used for the authentication of RTP header fields that might be modified by the switch as well as any other information requiring hop by hop authentication (e.g. RTCP packet authentication). The hop by hop key can also be used for encryption of information that the switch is authorized to access and modify such as encrypted RTCP packets. {include a split key-authentication model utilization diagram)

~~~~~~~~~~
RTP Packet 
-----------------------   ^
| CC M | PT | Seq Num |   |  
|     Time Stamp      |   |  Auth( RTP Packet + RoC ) 
|        SSRC         |   |
|        CSRCs        |   |
-----------------------   |   ^
|                     |   |   |  Enc( Payload, End2endKey )
|       Pay Load      |   |   |  
|                     |   |   |  Auth( Payload + SSRC + SeqNum + RoC,
-----------------------   V   V        End2endKey )
~~~~~~~~~~
{: #figsrtp title="SRTP Split key-authentication model"}


6. The SRTP master keys must not be generated by the switching infrastructure

7. The switching infrastructure must not be involved in the distribution of the SRTP master keys to participants nor in the authentication of the participants identities for the purpose of key distribution

8. The media switching infrastructure must be able to switch an already active SRTP stream to a new receiver while guaranteeing the timely synchronization between the SRTP transmitter and its old and new receivers. Of special interest is the RoC part pf the SRTP context due to its dynamic nature. It is important to note that the media switching infrastructure can not change RTP sequence numbers as that would require packet re-encryption.  (include diagram showing the synchronization requirement)


~~~~~~~~~~
>x>x>x>x> is media from user X flowing in direction of arrows

Time 1
    (Prev Speaker)                              (Active Speaker)
C Context Instantiated ______________  A Context Instantiated
     User A >a>a>a>a>a>|            |>a>a>a>a>a> User C
            <c<c<c<c<c<|            |<c<c<c<c<c<
                       | RTP        |
                       | Forwarding |
     User B <c<c<c<c<c<|            |>c>c>c>c>c> User D
C Context Instantiated |____________|  C Context Instantiated
~~~~~~~~~~

~~~~~~~~~~
Time 2                                          (Prev Speaker)  
C Context Out of Sync                  A Context Out of Sync 
B Context Instantiated ______________  B Context Instantiated 
     User A <b<b<b<b<b<|            |>b>b>b>b>b> User C
                       |            |<c<c<c<c<c<
                       | RTP        |
    (Active Speaker)   | Forwarding |
     User B <c<c<c<c<c<|            |>b>b>b>b>b> User D
            >b>b>b>b>b>|____________|  C Context Out of Sync 
C Context Up to Date                   B Context Instantiated 
~~~~~~~~~~

~~~~~~~~~~
Time 3
    (Active Speaker)   
C Context Out of Sync                   A Context Synchronized
B Context Up to Date   ______________   B Context Out of Sync         
     User A >a>a>a>a>a>|            |>a>a>a>a>a> User C
            <b<b<b<b<b<|            |
                       | RTP        |
    (Prev Speaker)     | Forwarding |
     User B <a<a<a<a<a<|            |>a>a>a>a>a> User D
            >b>b>b>b>b>|____________|   C Context Out of Sync   
C Context Out of Sync                   B Context Out of Sync   
A Context Instantiated                  A Context Instantiated  
~~~~~~~~~~
{: #figcontext title="SRTP context synchronization"}




Security Considerations
=======================

This specification is all about new requirements for a system for
securing RTP headers separately from the RTP body.



IANA Considerations
===================

This document requires no actions from IANA.



Acknowledgements
================

The authors would like to thank <GET YOUR NAME HERE - PLEASE SEND
COMMENTS>. 


Informative References
======================

[RTP-TOP]   Westerlund, M., and Wenger, S., "RTP Topologies", Work in Progress, May 2014.

[RFC7201]   Westerlund, M., and Perkins, C., "Options for Securing RTP Sessions", RFC 7201, April 2014.


