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

Modern audio / video conferencing systems often "switch" video streams, and sometimes audio streams, instead
of mixing them. Assuming 10 participants on a conference call, all participants send
video from their camera to the a centralized switch. The switch
picks the active speaker and sends that video to all other endpoints. If
the endpoints also wish to display a thumbnail sized video of all the
participants, that is also sent as sperate video streams that are rendered
separately by each endpoint.

Systems such as this are typically decomposed into a controller that deals with
the signaling and keeps track of who is in the conference and one or
more media switches that receive and transmit the audio and video to
all the partipants using SRTP. It does not matter where the controller
is located but it is desirable to use a media switch that is as close
to the participants as possible to reduce latency of the media as well
as located in a location with sufficient bandwidth. This results in
situations where it is nice to be able to locate the media switch in a
data center that is nor particularly trusted, or to be able to pay for
use of media switches operated by other parties.

This draft outlines the requirements for enabling media switches to preform the functions they need without having to acquire or use the  media keys needed to decrypt the
media they are switching. This enables deployments where the privacy of the media is guaranteed even when a different service is being used for the actual media switching.



Terminology
===========

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in {{RFC2119}}.


Switched Media Architecture
============================

TODO - explain what audio and video come from the participants to the
switch, what the switch does, and what goes out to clients

In traditional conferencing systems, the conferencing media infrastructure fully decrypts, decodes and processes RTP media streams received from one or more participants prior to forwarding the newly encoded and encrypted RTP media streams to the rest of participants. The conferencing media infrastructure consists of various conference servers acting as RTP mixers [RTP reference] and maintaining independent and persistent SRTP sessions with each endpoint. Each SRTP session has its persistent SSRCs, SRTP keys and SRTP contexts. Each endpoint exchanges media with one of the media servers shielding the endpoints from knowledge of other RTP transmitters and receivers in the conference (include Figure 1). 


~~~~~~~~~~
 User A <-----< Encrypt     Decrypt <------ User C
                   ^          v               
                 Media/RTP Process
                   v          v                  
 User B <-----< Encrypt     Encrypt >-----> User D
~~~~~~~~~~
{: #figmcu title="Classic MCU"}


On the other hand conferencing systems that aim at reducing the cost and complexity of their media infrastructure tend to switch media among participants rather than process media for each participant. The switching infrastructure receives RTP media streams from participants, selects which streams to be forwarded to which participants then manipulates the necessary parts of the RTP headers prior to forwarding the streams. The main distinction here is the fact that the media switches forward the RTP payload part of the media streams received from endpoints without any processing or changes.  The media switches typically act as RTP translators maintaining the SSRCs of the transmitting endpoints rather than generating their own persistent SSRCs towards every receiving endpoint (include figure 2). Though this is not the only viable embodiment of a media switching architecture, this is the most relevant for the security requirements discussed in this document.


~~~~~~~~~~
 User A <----------\           /------< User C
                    ^         v               
                  RTP Forwarding
                    v         v                  
 User B  <---------/           \------> User D
~~~~~~~~~~
{: #figstfu title="Scalable Translator Forwarding Unit"}


In such media switching architectures, endpoints can receive media from different transmitters at different times e.g. when receiving the video associated with the most active speaker. In this case endpoints receive different RTP video streams that are generated by different transmitters each with its own SSRC, SRTP key and SRTP context. All these streams are rendered to the end user as a single video source representing the most active speaker. Moreover endpoints do not receive the same RTP streams all the times. For example in the figure below endpoint 1,2 and 3 can be receiving video streams from endpoint 4 who is currently the active speaker while endpoint 4 is receiving video from endpoint 1 who is the previous active speaker. Once endpoint 2 become the active speaker then endpoint 1,3 and 4 will start to receive video from endpoint 2 while endpoint 2 continue to receive video from endpoint 4. (include figure 3) 


~~~~~~~~~~
Time 1
(Prev Seaker)      ______________           (Active Speaker)
 User A >a>a>a>a>a>|            |>a>a>a>a>a> User C
        <c<c<c<c<c<|            |<c<c<c<c<c<
                   | RTP        |
                   | Forwarding |
 User B <c<c<c<c<c<|            |>c>c>c>c>c> User D
                   |____________|
~~~~~~~~~~

~~~~~~~~~~
Time 2             ______________           (Prev Seaker)  
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
(Prev Seaker)      | Forwarding |
 User B <a<a<a<a<a<|            |>a>a>a>a>a> User D
        >b>b>b>b>b>|____________|
~~~~~~~~~~
{: #figmedia title="Media Flow"}


As stated before one of the objectives of media switching architecture is the scalability and simplicity of the media switches. This objective starts with minimizing/eliminating the media processing performed by the switch but can also to be extended to cryptography where crypto processing performed by the switch as well as crypto state maintained by the switch are minimized. More importantly and with the advent of cloud-based computing, it is essential to enable the media switching infrastructure to run in a cloud deployment while restricting such infrastructure from accessing and manipulation of media content. This enables for example enterprises to use cloud-based conferencing services while ensuring the privacy of their media as it gets switched via the cloud infrastructure. In other words the ability to eliminate the need of media switches to decrypt and re-encrypt packets is not merely a scalability and simplicity requirement but is also a core security requirement.


RTP header manipulation
=======================

TODO - dig into the next level of detail of what parts of the header
get changed by the switch and why - make sure to be clear there are
other RTP mixer architectures - reference Magnus draft - but this is a
common one used by moder systems due to reduced cost

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

TODO

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
C Context Out of Sync(TODO CHECK)       B Context Out of Sync   
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

