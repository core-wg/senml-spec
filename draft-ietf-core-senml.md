---
stand_alone: true
ipr: trust200902
docname: draft-ietf-core-senml-09
cat: std

date: June 29, 2017

pi:
  toc: 'yes'
  symrefs: 'yes'
  iprnotified: 'yes'
  strict: 'yes'
  compact: 'yes'
  sortrefs: 'yes'
  colonspace: 'yes'
  rfcedstyle: 'no'
  tocdepth: '4'
  
title: Media Types for Sensor Measurement Lists (SenML)
abbrev: SenML
area: ART

author:
- ins: C. Jennings
  name: Cullen Jennings
  org: Cisco
  street: 400 3rd Avenue SW
  city: Calgary
  region: AB
  code: 'T2P 4H2'
  country: Canada
  email: fluffy@iii.ca
- ins: Z. Shelby
  name: Zach Shelby
  org: ARM
  street: 150 Rose Orchard
  city: San Jose
  code: '95134'
  country: USA
  phone: "+1-408-203-9434"
  email: zach.shelby@arm.com
- ins: J. Arkko
  name: Jari Arkko
  org: Ericsson
  street: ''
  city: Jorvas
  code: '02420'
  country: Finland
  email: jari.arkko@piuha.net
- ins: A. Keranen
  name: Ari Keranen
  org: Ericsson
  street: ''
  city: Jorvas
  code: '02420'
  country: Finland
  email: ari.keranen@ericsson.com
-
  ins: C. Bormann
  name: Carsten Bormann
  org: Universitaet Bremen TZI
  street: Postfach 330440
  city: Bremen
  code: D-28359
  country: Germany
  phone: +49-421-218-63921
  email: cabo@tzi.org

normative:
  IEEE.754.1985: 
  RFC2119: 
  RFC3688:
  RFC4648:
  RFC5226: 
  RFC6838: 
  RFC7049: 
  RFC7159:
  RFC7252: 
  RFC7303: 
  W3C.REC-exi-20140211:
  W3C.REC-xml-20081126:
  BIPM:
    title: The International System of Units (SI)
    author:
    - org: Bureau International des Poids et Mesures
    date: 2006
    seriesinfo:
      "8th": edition
  NIST811:
    title: Guide for the Use of the International System of Units (SI)
    author:
    - ins: A. Thompson
    - ins: B. Taylor
    date: 2008
    seriesinfo:
      NIST: Special Publication 811

informative:
  RFC2141: 
  RFC3986: 
  RFC4122: 
  RFC5952: 
  RFC6690:
  RFC7111: csvfrag
  RFC7721:
  I-D.arkko-core-dev-urn:
  I-D.greevenbosch-appsawg-cbor-cddl: 
  I-D.ietf-core-links-json:
  UCUM:
    title: The Unified Code for Units of Measure (UCUM) 
    author:
    - ins: G. Schadow 
    - ins: C. McDonald 
    date: 2013 
    target: http://unitsofmeasure.org/ucum.html 
    seriesinfo:
      Regenstrief Institute and Indiana University School of: Informatics 

--- abstract

This specification defines media types for representing simple sensor
measurements and device parameters in the Sensor Measurement Lists
(SenML). Representations are defined in JavaScript Object Notation
(JSON), Concise Binary Object Representation (CBOR), eXtensible Markup
Language (XML), and Efficient XML Interchange (EXI), which share the
common SenML data model. A simple sensor, such as a temperature
sensor, could use this media type in protocols such as HTTP or CoAP to
transport the measurements of the sensor or to be configured.

--- middle

# Overview

Connecting sensors to the Internet is not new, and there have been
many protocols designed to facilitate it. This specification defines
new media types for carrying simple sensor information in a protocol
such as HTTP or CoAP.  This format was designed so that processors
with very limited capabilities could easily encode a sensor
measurement into the media type, while at the same time a server
parsing the data could relatively efficiently collect a large number
of sensor measurements. SenML can be used for a variety
of data flow models, most notably data feeds pushed from a sensor to a
collector, and the web resource model where the sensor is requested as
a resource representation (e.g., "GET /sensor/temperature").

There are many types of more complex measurements and measurements
that this media type would not be suitable for.  SenML strikes a
balance between having some information about the sensor carried with
the sensor data so that the data is self describing but it also tries
to make that a fairly minimal set of auxiliary information for
efficiency reason. Other information about the sensor can be
discovered by other methods such as using the CoRE Link Format
{{RFC6690}}.

SenML is defined by a data model for measurements and simple meta-data
about measurements and devices. The data is structured as a single
array that contains a series of SenML Records which can each contain
attributes such as an unique identifier for the sensor, the time the
measurement was made, the unit the measurement is in, and the current
value of the sensor.  Serializations for this data model are defined
for JSON {{RFC7159}}, CBOR {{RFC7049}}, XML, and Efficient XML
Interchange (EXI) {{W3C.REC-exi-20140211}}.

For example, the following shows a measurement from a temperature
gauge encoded in the JSON syntax.

~~~~
{::include ex1.gen.json}
~~~~

In the example above, the array has a single SenML Record with a
measurement for a sensor named "urn:dev:ow:10e2073a01080063" with a
current value of 23.1 degrees Celsius.


# Requirements and Design Goals

The design goal is to be able to send simple sensor measurements in
small packets on mesh networks from large numbers of constrained
devices. Keeping the total size of payload under 80 bytes makes this
easy to use on a wireless mesh network. It is always difficult to
define what small code is, but there is a desire to be able to
implement this in roughly 1 KB of flash on a 8 bit
microprocessor. Experience with power meters and other large scale
deployments has indicated that the solution needs to support allowing
multiple measurements to be batched into a single HTTP or CoAP
request. This "batch" upload capability allows the server side to
efficiently support a large number of devices. It also conveniently
supports batch transfers from proxies and storage devices, even in
situations where the sensor itself sends just a single data item at a
time. The multiple measurements could be from multiple related sensors
or from the same sensor but at different times.

The basic design is an array with a series of measurements. The
following example shows two measurements made at different times. The
value of a measurement is given by the "v" attribute, the time of a
measurement is in the "t" attribute, the "n" attribute has a unique
sensor name, and the unit of the measurement is carried in the "u"
attribute.

~~~~
{::include ex10.gen.wrap.json}
~~~~

To keep the messages small, it does not make sense to repeat the "n"
attribute in each SenML Record so there is a concept of a Base Name which is
simply a string that is prepended to the Name field of all elements in
that record and any records that follow it. So a more compact form of
the example above is the following.

~~~~
{::include ex11.gen.wrap.json}
~~~~

In the above example the Base Name is in the "bn" attribute and the "n" attributes
in each Record are the empty string so they are omitted.

Some devices have accurate time while others do not so SenML supports
absolute and relative times. Time is represented in floating point as
seconds and values greater than zero represent an absolute time
relative to the Unix epoch while values of 0 or less represent a
relative time in the past from the current time. A simple sensor with
no absolute wall clock time might take a measurement every second, 
batch up 60 of them, and then send the batch to a server. It would include the
relative time each measurement was made compared to the time the batch was sent
in each SenML Record. The server might have accurate NTP time and use the
time it received the data, and the relative offset, to replace the
times in the SenML with absolute times before saving the SenML Pack in
a document database.

# Terminology

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in
{{RFC2119}}.

This document also uses the following terms:

SenML Record: 
: One measurement or configuration instance in time presented
using the SenML data model.

SenML Pack: 
: One or more SenML Records in an array structure.

SenML Label:
: A short name used in SenML Records to denote different attributes
(e.g., "v" for "value").

# SenML Structure and Semantics {#senml-structure}

Each SenML Pack carries a single array that represents a set of
measurements and/or parameters. This array contains a series of SenML
Records with several attributes described below. There are two kind of
attributes: base and regular.
The base attributes can  be included
in any SenML Record and they apply to the entries in the Record.
Each base attribute also applies to all Records after it up to, but not
including, the next Record that has that same base attribute. 
All base attributes are optional. Regular attributes can be
included in any SenML Record and apply only to that Record.

## Base attributes {#senml-base}

Base Name:
: This is a string that is prepended to the names found in the entries. 

Base Time:
: A base time that is added to the time found in an entry. 

Base Unit:
: A base unit that is assumed for all entries, unless otherwise
  indicated.  If a record does not contain a Unit value, then the Base
  Unit is used. Otherwise the value found in the Unit (if any) is
  used.
    
Base Value:
: A base value is added to the value found in an entry, similar to
Base Time.
 
Base Sum:
: A base sum is added to the sum found in an entry, similar to Base
Time.
 
Version:
: Version number of media type format. This attribute is an optional
  positive integer and defaults to 5 if not
  present. \[RFC Editor: change the default value to 10 when this
  specification is published as an RFC and remove this note\]

## Regular attributes

Name:
: Name of the sensor or parameter. When appended to the Base Name
  attribute, this must result in a globally unique identifier for the
  resource. The name is optional, if the Base Name is present. If the
  name is missing, Base Name must uniquely identify the resource. This
  can be used to represent a large array of measurements from the same
  sensor without having to repeat its identifier on every measurement.

Unit:
: Units for a measurement value. Optional.

Value:
: Value of the entry.  Optional if a Sum value is present, otherwise
  required. Values are represented using basic data types. This
  specification defines floating point numbers ("v" field for
  "Value"), booleans ("vb" for "Boolean Value"), strings ("vs" for
  "String Value") and binary data ("vd" for "Data Value"). Exactly one
  value field MUST appear unless there is Sum field in which case it
  is allowed to have no Value field.

Sum:
: Integrated sum of the values over time. Optional. This attribute is
  in the units specified in the Unit value multiplied by seconds.

Time:
: Time when value was recorded. Optional.

Update Time:
: An optional time in seconds that represents the maximum time before
  this sensor will provide an updated reading for a measurement. This
  can be used to detect the failure of sensors or communications path
  from the sensor.

## Considerations

The SenML format can be extended with further custom attributes. Both
new base and regular attributes are allowed. See
{{iana-senml-label-registry}} for details.  Implementations MUST
ignore attributes they don't recognize unless that attribute has a label
name that ends with the '_' character in which case an error MUST be
generated. 

Systems reading one of the objects MUST check for the Version
attribute. If this value is a version number larger than the version
which the system understands, the system SHOULD NOT use this object.
This allows the version number to indicate that the object contains
mandatory to understand attributes. New version numbers can only be
defined in an RFC that updates this specification or it successors.

The Name value is concatenated to the Base Name value to get the name
of the sensor. The resulting name needs to uniquely identify and
differentiate the sensor from all others.
It is RECOMMENDED that the full names are
represented as URIs {{RFC3986}} or URNs {{RFC2141}}. One way to create a unique
name is to include some bit string that has guaranteed uniqueness
(such as a 1-wire address) that is assigned to the device. Some of the
examples in this draft use the device URN type as specified in
{{I-D.arkko-core-dev-urn}}. UUIDs {{RFC4122}} are another way to
generate a unique name. Note that long-term stable unique identifiers
are problematic for privacy reasons and should be used
with care or avoided as described in {{RFC7721}}. 

The resulting concatenated name MUST consist only of characters out of
the set "A" to "Z", "a" to "z", "0" to "9", "-", ":", ".", or "_" and
it MUST start with a character out of the set "A" to "Z", "a" to "z",
or "0" to "9". This restricted character set was chosen so that these
names can be directly used as in other types of URI including segments
of an HTTP path with no special encoding and can be directly used in
many databases and analytic systems. {{RFC5952}} contains advice on
encoding an IPv6 address in a name.

If the Record has no Unit, the Base Unit is used as the Unit. Having
no Unit and no Base Unit is allowed.
  
If either the Base Time or Time value is missing, the missing
attribute is considered to have a value of zero. The Base Time and
Time values are added together to get the time of measurement. A time
of zero indicates that the sensor does not know the absolute time and
the measurement was made roughly "now". A negative value is used to
indicate seconds in the past from roughly "now". A positive value is
used to indicate the number of seconds, excluding leap seconds, since
the start of the year 1970 in UTC.

If only one of the Base Sum or Sum value is present, the missing
attribute is considered to have a value of zero. The Base Sum and Sum
values are added together to get the sum of measurement. If neither
the Base Sum or Sum are present, then the measurement does not have a
sum value.

If the Base Value or Value is not present, the missing attribute(s)
are considered to have a value of zero. The Base Value and Value are
added together to get the value of the measurement.

Representing the statistical characteristics of measurements, such as
accuracy, can be very complex. Future specification may add new
attributes to provide better information about the statistical
properties of the measurement.

## Resolved Records

Sometimes it is useful to be able to refer to a defined normalized
format for SenML records. This normalized format tends to get used for
big data applications and intermediate forms when converting to other
formats.

A SenML Record is referred to as "resolved" if it does not contain any
base values and has no relative times, but the base values of the
SenML Pack (if any) are applied to the Record. That is, name and base
name are concatenated, base time is added to the time of the Record,
if the Record did not contain Unit the Base Unit is applied to the
record, etc. In addition the records need to be in chronological
order.  An example of this is show in {{resolved-ex}}.

Future specification that defines new base attributes need to specify
how the attribute is resolved.

## Associating Meta-data

SenML is designed to carry the minimum dynamic information about
measurements, and for efficiency reasons does not carry significant
static meta-data about the device, object or sensors. Instead, it is
assumed that this meta-data is carried out of band. For web resources
using SenML Packs, this meta-data can be made available using the CoRE
Link Format {{RFC6690}}. The most obvious use of this link format is
to describe that a resource is available in a SenML format in the
first place. The relevant media type indicator is included in the
Content-Type (ct=) attribute.


# JSON Representation (application/senml+json)

The SenML labels (JSON object member names) shown in
{{tbl-json-labels}} are used in JSON SenML Record attributes.

| Name          | label| Type           |
| Base Name     | bn   | String         |
| Base Time     | bt   | Number         |
| Base Unit     | bu   | String         |
| Base Value    | bv   | Number         |
| Base Sum      | bs   | Number         |
| Version       | bver | Number         |
| Name          | n    | String         |
| Unit          | u    | String         |
| Value         | v    | Number         |
| String Value  | vs   | String         |
| Boolean Value | vb   | Boolean        |
| Data Value    | vd   | String         |
| Value Sum     | s    | Number         |
| Time          | t    | Number         |
| Update Time   | ut   | Number         |
| Link          | l    | String         |
{: #tbl-json-labels cols='r l l' title="JSON SenML Labels"}

The root content consists of an array with one JSON object for each
SenML Record. All the fields in the above table MAY occur in the
records with the type specified in the table.

Only the UTF-8 form of JSON is allowed. Characters in the String Value
are encoded using the escape sequences defined in {{RFC7159}}. Octets
in the Data Value are base64 encoded with URL safe alphabet as defined
in Section 5 of {{RFC4648}}.

Systems receiving measurements MUST be able to process the range of
floating point numbers that are representable as an IEEE double
precision floating point numbers {{IEEE.754.1985}}. The number of
significant digits in any measurement is not relevant, so a reading
of 1.1 has exactly the same semantic meaning as 1.10. If the value has
an exponent, the "e" MUST be in lower case.  The mantissa SHOULD be
less than 19 characters long and the exponent SHOULD be less than 5
characters long. This allows time values to have better than micro
second precision over the next 100 years.


## Examples


### Single Datapoint

The following shows a temperature reading taken approximately "now" by
a 1-wire sensor device that was assigned the unique 1-wire address of
10e2073a01080063:

~~~~
{::include ex1.gen.json}
~~~~


### Multiple Datapoints {#co-ex}

The following example shows voltage and current now, i.e., at an
unspecified time.

~~~~
{::include ex2.gen.json}
~~~~

The next example is similar to the above one, but shows current at Tue
Jun 8 18:01:16.001 UTC 2010 and at each second for the previous 5
seconds.

~~~~
{::include ex3.gen.wrap.json}
~~~~

Note that in some usage scenarios of SenML the implementations MAY
store or transmit SenML in a stream-like fashion, where data is
collected over time and continuously added to the object. This mode of
operation is optional, but systems or protocols using SenML in this
fashion MUST specify that they are doing this. SenML defines a
separate media type to indicate Sensor Streaming Measurement Lists
(SensML) for this usage (see {{sec-senml-json}}).  In this situation
the SensML stream can be sent and received in a partial fashion, i.e.,
a measurement entry can be read as soon as the SenML Record is
received and not have to wait for the full SensML Stream to be
complete.

For instance, the following stream of measurements may be sent via a
long lived HTTP POST from the producer of a SensML to the consumer of
that, and each measurement object may be reported at the time it was
measured:

~~~~
{::include ex4.gen.json-trim}
...
~~~~


### Multiple Measurements {#an-co-ex}

The following example shows humidity measurements from a mobile device
with a 1-wire address 10e2073a01080063, starting at Mon Oct 31
13:24:24 UTC 2011. The device also provides position data, which is
provided in the same measurement or parameter array as separate
entries. Note time is used to for correlating data that belongs
together, e.g., a measurement and a parameter associated with it.
Finally, the device also reports extra data about its battery status
at a separate time.

~~~~
{::include ex5.gen.wrap.json}
~~~~

The size of this example represented in various forms, as well as that
form compressed with gzip is given in the following table.

{::include size.md}
{: #tbl-sizes cols="l r r" title="Size Comparisons"}


### Resolved Data {#resolved-ex}

The following shows the example from the previous section show in
resolved format.

~~~~
{::include ex5.gen.resolved.wrap.json}
~~~~


### Multiple Data Types {#mult-types-ex}

The following example shows a sensor that returns different data
types.

~~~~
{::include ex7.gen.json}
~~~~

### Collection of Resources {#rest-ex}

The following example shows the results from a query to one device
that aggregates multiple measurements from another devices. The example
assumes that a client has fetched information from a device at
2001:db8::2 by performing a GET operation on http://\[2001:db8::2\] at
Mon Oct 31 16:27:09 UTC 2011, and has gotten two separate values as a
result, a temperature and humidity measurement as well as the results
from another device at http://\[2001:db8::1\] that also had a
temperature and humidity. Note that the last record would use the Base
Name from the 3rd record but the Base Time from the first record. 

~~~~
{::include ex6.gen.wrap.json}
~~~~

### Setting an Actuator {#thermo-ex}

The following example show the SenML that could be used to set the
current set point of a typical residential thermostat which has a
temperature set point, a switch to turn on and off the heat, and a
switch to turn on the fan override.

~~~~
{::include ex9.gen.json}
~~~~

In the following example two different lights are turned on. It is
assumed that the lights are on a 802.1BA network that can guarantee
delivery of the messages to the two lights within 15 ms and
uses 802.1AS for time synchronization. The controller has set the time
of the lights coming on to 20 ms in the future from the current
time. This allows both lights to receive the message, wait till that
time, then apply the switch command so that both lights come on at the
same time.

~~~~
{::include ex12.gen.json}
~~~~

The following shows two lights being turned off using a non
deterministic network that has a high odds of delivering a message in
less than 100 ms and uses NTP for time synchronization. The current
time is 1320078429. The user has just turned off a light switch which
is turning off two lights. Both lights are dimmed to 50% brightness
immediately to give the user instant feedback that something is
changing. However given the network, the lights will probably dim at
somewhat different times. Then 100 ms in the future, both lights will
go off at the same time. The instant but not synchronized dimming
gives the user the sensation of quick responses and the timed off 100
ms in the future gives the perception of both lights going off at the
same time.

~~~~
{::include ex13.gen.json}
~~~~


# CBOR Representation (application/senml+cbor) {#sec-cbor}

The CBOR {{RFC7049}} representation is equivalent to the JSON
representation, with the following changes:

* For JSON Numbers, the CBOR representation can use integers, floating
point numbers, or decimal fractions (CBOR Tag 4); however a
representation SHOULD be chosen such that when the CBOR value is
converted back to an IEEE double precision floating point value, it
has exactly the same value as the original Number.  For the version
number, only an unsigned integer is allowed.

* Characters in the String Value are encoded using a definite length
text string (type 3). Octets in the Data Value are encoded using a
definite length byte string (type 2) .

* For compactness, the CBOR representation uses integers for the map
keys defined in {{tbl-cbor-labels}}. This table is conclusive, i.e.,
there is no intention to define any additional integer map keys; any
extensions will use string map keys. This allows translators
converting between CBOR and JSON representations to convert also all
future labels without needing to update implementations.

| Name                      | Label      | CBOR Label |
| Version                   | bver       |         -1 |
| Base Name                 | bn         |         -2 |
| Base Time                 | bt         |         -3 |
| Base Units                | bu         |         -4 |
| Base Value                | bv         |         -5 |
| Base Sum                | bs         |         -6 |
| Name                      | n          |          0 |
| Units                     | u          |          1 |
| Value                     | v          |          2 |
| String Value              | vs         |          3 |
| Boolean Value             | vb         |          4 |
| Value Sum                 | s          |          5 |
| Time                      | t          |          6 |
| Update Time               | ut         |          7 |
| Data Value                | vd         |          8 |
| Link                | l         |          9 |
{: #tbl-cbor-labels cols="r l r" title="CBOR representation: integers for map keys"}

* For streaming SensML in CBOR representation, the array containing
  the records SHOULD be an CBOR indefinite length array while for non
  streaming SenML, a definite length array MUST be used.

The following example shows a dump of the CBOR example for the same
sensor measurement as in {{co-ex}}.

~~~~
{::include ex3.gen.cbor.hex}
~~~~


# XML Representation (application/senml+xml) {#sec-xml-example}

A SenML Pack or Stream can also be represented in XML format as
defined in this section.

Only the UTF-8 form of XML is allowed. Characters in the String Value
are encoded using the escape sequences defined in {{RFC7159}}. Octets
in the Data Value are base64 encoded with URL safe alphabet as defined
in Section 5 of {{RFC4648}}.

The following example shows an XML example for the same sensor
measurement as in {{co-ex}}.

~~~~
{::include ex3.gen.xml}
~~~~

The SenML Stream is represented as a sensml tag that contains a series
of senml tags for each SenML Record. The SenML Fields are represents
as XML attributes.  The following table shows the mapping of the SenML
labels, which are used for the attribute name, to the attribute types
used in the XML senml tags.

| Name          | Label| Type    |
| Base Name     | bn   | string  |
| Base Time     | bt   | double  |
| Base Unit     | bu   | string  |
| Base Value    | bv   | double  |
| Base Sum    | bs   | double  |
| Base Version  | bver | int     |
| Name          | n    | string  |
| Unit          | u    | string  |
| Value         | v    | double  |
| String Value  | vs   | string  |
| Data Value    | vd   | string  |
| Boolean Value | vb   | boolean |
| Value Sum     | s    | double  |
| Time          | t    | double  |
| Update Time   | ut   | double  |
| Link   | l  | string  |
{: #tbl-xml-labels cols='r l l' title="XML SenML Labels"}

The RelaxNG schema for the XML is:

~~~~
{::include senml.rnc}
~~~~


# EXI Representation (application/senml+exi)

For efficient transmission of SenML over e.g. a constrained network,
Efficient XML Interchange (EXI) can be used. This encodes the XML
Schema structure of SenML into binary tags and values rather than
ASCII text.  An EXI representation of SenML SHOULD be made using the
strict schema-mode of EXI. This mode however does not allow tag
extensions to the schema, and therefore any extensions will be lost in
the encoding.  For uses where extensions need to be preserved in EXI,
the non-strict schema mode of EXI MAY be used.

The EXI header MUST include an "EXI Options", as defined in
{{W3C.REC-exi-20140211}}, with an schemaId set to the value of "a"
indicating the schema provided in this specification.
Future revisions to the schema can change the value of the schemaId to
allow for backwards compatibility.
When the data will be
transported over CoAP or HTTP, an EXI Cookie SHOULD NOT be used as it
simply makes things larger and is redundant to information provided in
the Content-Type header.

The following is the XSD Schema to be used for strict schema guided
EXI processing. It is generated from the RelaxNG.

~~~~
{::include senml.gen.xsd}
~~~~

The following shows a hexdump of the EXI produced from encoding the
following XML example. Note this example is the same information as
the first example in {{co-ex}} in JSON format.

~~~~
{::include ex2.gen.xml}
~~~~

Which compresses with EXI to the following displayed in hexdump:

~~~~
{::include ex2.gen.exi.hex}
~~~~

The above example used the bit packed form of EXI but it is also
possible to use a byte packed form of EXI which can makes it easier
for a simple sensor to produce valid EXI without really implementing
EXI.  Consider the example of a temperature sensor that produces a
value in tenths of degrees Celsius over a range of 0.0 to 55.0. It
would produce an XML SenML file such as:

~~~~
{::include ex1.gen.xml}
~~~~

The compressed form, using the byte alignment option of EXI, for the
above XML is the following:

~~~~
{::include ex1.gen.exi.hex}
~~~~

A small temperature sensor devices that only generates this one EXI
file does not really need an full EXI implementation. It can simply
hard code the output replacing the 1-wire device ID starting at byte
0x20 and going to byte 0x2F with it's device ID, and replacing the
value "0xe7 0x01" at location 0x37 and 0x38 with the current
temperature. The EXI Specification {{W3C.REC-exi-20140211}} contains
the full information on how floating point numbers are represented,
but for the purpose of this sensor, the temperature can be converted
to an integer in tenths of degrees (231 in this example). EXI stores 7
bits of the integer in each byte with the top bit set to one if there
are further bytes. So the first bytes at is set to low 7 bits of the
integer temperature in tenths of degrees plus 0x80. In this example
231 & 0x7F + 0x80 = 0xE7. The second byte is set to the integer
temperature in tenths of degrees right shifted 7 bits. In this example
231 >> 7 = 0x01.

# Fragment Identification Methods

A SenML Pack typically consists of multiple SenML Records and for some
applications it may be useful to be able to refer with a Fragment
Identifier to a single record, or a set of records, in a Pack. The
fragment identifier is only interpreted by a client and does not
impact retrieval of a representation. The SenML Fragment
Identification is modeled after CSV Fragment Identifiers {{RFC7111}}.

To select a single SenML Record, the "rec" scheme followed by a single
number is used.  For the purpose of numbering records, the first
record is at position 1.  A range of records can be selected by giving
the first and the last record number separated by a '-'
character. Instead of the second number, the '\*' character can be
used to indicate the last Senml Record in the Pack.  A set of records
can also be selected using a comma separated list of record positions
or ranges.

(We use the term "selecting a record" for identifying it as part of
the fragment, not in the sense of isolating it from the Pack --- the
record still needs to be interpreted as part of the Pack, e.g., using
the base values defined in record 1.)

## Fragment Identification Examples

The 3rd SenML Record from "coap://example.com/temp" resource can be
selected with:

  coap://example.com/temp#rec=3

Records from 3rd to 6th can be selected with:

  coap://example.com/temp#rec=3-6

Records from 19th to the last can be selected with:

  coap://example.com/temp#rec=19-*

The 3rd and 5th record can be selected with:

  coap://example.com/temp#rec=3,5

To select the Records from third to fifth, the 10th record, and all
from 19th to the last:

  coap://example.com/temp#rec=3-5,10,19-*


# Usage Considerations

The measurements support sending both the current value of a sensor as
well as the an integrated sum. For many types of measurements, the sum
is more useful than the current value. For example, an electrical
meter that measures the energy a given computer uses will typically
want to measure the cumulative amount of energy used. This is less
prone to error than reporting the power each second and trying to have
something on the server side sum together all the power
measurements. If the network between the sensor and the meter goes
down over some period of time, when it comes back up, the cumulative
sum helps reflect what happened while the network was down. A meter
like this would typically report a measurement with the units set to
watts, but it would put the sum of energy used in the "s" attribute of
the measurement. It might optionally include the current power in the
"v" attribute.

While the benefit of using the integrated sum is fairly clear for
measurements like power and energy, it is less obvious for something
like temperature. Reporting the sum of the temperature makes it easy
to compute averages even when the individual temperature values are
not reported frequently enough to compute accurate
averages. Implementors are encouraged to report the cumulative sum as
well as the raw value of a given sensor.

Applications that use the cumulative sum values need to understand
they are very loosely defined by this specification, and depending on
the particular sensor implementation may behave in unexpected ways.
Applications should be able to deal with the following issues:

1. Many sensors will allow the cumulative sums to "wrap" back to zero
  after the value gets sufficiently large.

2. Some sensors will reset the cumulative sum back to zero when the
  device is reset, loses power, or is replaced with a different
  sensor.

3. Applications cannot make assumptions about when the device started
  accumulating values into the sum.

Typically applications can make some assumptions about specific
sensors that will allow them to deal with these problems. A common
assumption is that for sensors whose measurement values are always
positive, the sum should never get smaller; so if the sum does get
smaller, the application will know that one of the situations listed
above has happened.


# CDDL

For reference, the JSON and CBOR representations can be described with
the common CDDL {{I-D.greevenbosch-appsawg-cbor-cddl}} specification
in {{senmlcddl}}.

~~~~ cddl
{::include senml.cddl}
~~~~~
{: #senmlcddl title="Common CDDL specification for CBOR and JSON SenML"}

For JSON, we use text labels and base64url-encoded binary data
({{senmlcddl-json}}).

~~~~ cddl
{::include senml-json.cddl}
~~~~~
{: #senmlcddl-json title="JSON-specific CDDL specification for SenML"}

For CBOR, we use integer labels and native binary data
({{senmlcddl-cbor}}).

~~~~ cddl
{::include senml-cbor.cddl}
~~~~~
{: #senmlcddl-cbor title="CBOR-specific CDDL specification for SenML"}


# IANA Considerations

Note to RFC Editor: Please replace all occurrences of "RFC-AAAA" with
the RFC number of this specification.

## Units Registry {#sec-units}

IANA will create a registry of SenML unit symbols. The primary purpose
of this registry is to make sure that symbols uniquely map to give
type of measurement. Definitions for many of these units can be found
in location such as {{NIST811}} and {{BIPM}}.  Units marked with an
asterisk are NOT RECOMMENDED to be produced by new implementations,
but are in active use and SHOULD be implemented by consumers that can
use the related base units.

| Symbol   | Description                                       | Type  | Reference |
| m        | meter                                             | float | RFC-AAAA  |
| kg       | kilogram                                          | float | RFC-AAAA  |
| g        | gram*                                             | float | RFC-AAAA  |
| s        | second                                            | float | RFC-AAAA  |
| A        | ampere                                            | float | RFC-AAAA  |
| K        | kelvin                                            | float | RFC-AAAA  |
| cd       | candela                                           | float | RFC-AAAA  |
| mol      | mole                                              | float | RFC-AAAA  |
| Hz       | hertz                                             | float | RFC-AAAA  |
| rad      | radian                                            | float | RFC-AAAA  |
| sr       | steradian                                         | float | RFC-AAAA  |
| N        | newton                                            | float | RFC-AAAA  |
| Pa       | pascal                                            | float | RFC-AAAA  |
| J        | joule                                             | float | RFC-AAAA  |
| W        | watt                                              | float | RFC-AAAA  |
| C        | coulomb                                           | float | RFC-AAAA  |
| V        | volt                                              | float | RFC-AAAA  |
| F        | farad                                             | float | RFC-AAAA  |
| Ohm      | ohm                                               | float | RFC-AAAA  |
| S        | siemens                                           | float | RFC-AAAA  |
| Wb       | weber                                             | float | RFC-AAAA  |
| T        | tesla                                             | float | RFC-AAAA  |
| H        | henry                                             | float | RFC-AAAA  |
| Cel      | degrees Celsius                                   | float | RFC-AAAA  |
| lm       | lumen                                             | float | RFC-AAAA  |
| lx       | lux                                               | float | RFC-AAAA  |
| Bq       | becquerel                                         | float | RFC-AAAA  |
| Gy       | gray                                              | float | RFC-AAAA  |
| Sv       | sievert                                           | float | RFC-AAAA  |
| kat      | katal                                             | float | RFC-AAAA  |
| m2       | square meter (area)                               | float | RFC-AAAA  |
| m3       | cubic meter (volume)                              | float | RFC-AAAA  |
| l        | liter (volume)*                                   | float | RFC-AAAA  |
| m/s      | meter per second (velocity)                       | float | RFC-AAAA  |
| m/s2     | meter per square second (acceleration)            | float | RFC-AAAA  |
| m3/s     | cubic meter per second (flow rate)                | float | RFC-AAAA  |
| l/s      | liter per second (flow rate)*                     | float | RFC-AAAA  |
| W/m2     | watt per square meter (irradiance)                | float | RFC-AAAA  |
| cd/m2    | candela per square meter (luminance)              | float | RFC-AAAA  |
| bit      | bit (information content)                         | float | RFC-AAAA  |
| bit/s    | bit per second (data rate)                        | float | RFC-AAAA  |
| lat      | degrees latitude (note 2)                         | float | RFC-AAAA  |
| lon      | degrees longitude (note 2)                        | float | RFC-AAAA  |
| pH       | pH value (acidity; logarithmic quantity)          | float | RFC-AAAA  |
| dB       | decibel (logarithmic quantity)                    | float | RFC-AAAA  |
| dBW      | decibel relative to 1 W (power level)             | float | RFC-AAAA  |
| Bspl     | bel (sound pressure level; logarithmic quantity)* | float | RFC-AAAA  |
| count    | 1 (counter value)                                 | float | RFC-AAAA  |
| /        | 1 (Ratio e.g., value of a switch, note 1)         | float | RFC-AAAA  |
| %        | 1 (Ratio e.g., value of a switch, note 1)*        | float | RFC-AAAA  |
| %RH      | Percentage (Relative Humidity)                    | float | RFC-AAAA  |
| %EL      | Percentage (remaining battery energy level)       | float | RFC-AAAA  |
| EL       | seconds (remaining battery energy level)          | float | RFC-AAAA  |
| 1/s      | 1 per second (event rate)                         | float | RFC-AAAA  |
| 1/min    | 1 per minute (event rate, "rpm")*                 | float | RFC-AAAA  |
| beat/min | 1 per minute (Heart rate in beats per minute)*    | float | RFC-AAAA  |
| beats    | 1 (Cumulative number of heart beats)*             | float | RFC-AAAA  |
| S/m      | Siemens per meter (conductivity)                  | float | RFC-AAAA  |
{: #tbl-iana-symbols cols='r l l'}

* Note 1: A value of 0.0 indicates the switch is off while 1.0
  indicates on and 0.5 would be half on.  The preferred name of this
  unit is "/".  For historical reasons, the name "%" is also provided
  for the same unit -- but note that while that name strongly suggests
  a percentage (0..100) --- it is however NOT a percentage, but the
  absolute ratio!
  
* Note 2: Assumed to be in WGS84 unless another reference frame is
  known for the sensor.

New entries can be added to the registration by either Expert Review
or IESG Approval as defined in {{RFC5226}}.  Experts should exercise
their own good judgment but need to consider the following guidelines:

1. There needs to be a real and compelling use for any new unit to be
   added.

2. Units should define the semantic information and be chosen
  carefully. Implementors need to remember that the same word may be
  used in different real-life contexts. For example, degrees when
  measuring latitude have no semantic relation to degrees when
  measuring temperature; thus two different units are needed.

3. These measurements are produced by computers for consumption by
  computers. The principle is that conversion has to be easily be done
  when both reading and writing the media type. The value of a single
  canonical representation outweighs the convenience of easy human
  representations or loss of precision in a conversion.

4. Use of SI prefixes such as "k" before the unit is not recommended.
  Instead one can represent the value using scientific notation such
  a 1.2e3. The "kg" unit is exception to this rule since it is an SI
  base unit; the "g" unit is provided for legacy compatibility.

5. For a given type of measurement, there will only be one unit type
  defined. So for length, meters are defined and other lengths such as
  mile, foot, light year are not allowed. For most cases, the SI unit
  is preferred.

6. Symbol names that could be easily confused with existing common
  units or units combined with prefixes should be avoided. For
  example, selecting a unit name of "mph" to indicate something that
  had nothing to do with velocity would be a bad choice, as "mph" is
  commonly used to mean miles per hour.

7. The following should not be used because the are common SI
  prefixes: Y, Z, E, P, T, G, M, k, h, da, d, c, n, u, p, f, a, z, y,
  Ki, Mi, Gi, Ti, Pi, Ei, Zi, Yi.

8. The following units should not be used as they are commonly used to
  represent other measurements Ky, Gal, dyn, etg, P, St, Mx, G, Oe,
  Gb, sb, Lmb, mph, Ci, R, RAD, REM, gal, bbl, qt, degF, Cal, BTU, HP,
  pH, B/s, psi, Torr, atm, at, bar, kWh.

9. The unit names are case sensitive and the correct case needs to be
  used, but symbols that differ only in case should not be allocated.

10. A number after a unit typically indicates the previous unit raised to that
  power, and the / indicates that the units that follow are the reciprocal. A
  unit should have only one / in the name.

11. A good list of common units can be found in the Unified Code for
   Units of Measure {{UCUM}}.


## SenML Label Registry {#iana-senml-label-registry}

IANA will create a new registry for SenML labels. The initial content
of the registry is:

| Name          | Label|CBOR| XML Type| ID | Note    |
| Base Name     | bn   | -2 | string  |  a | RFCXXXX |
| Base Sum      | bs   | -6 | double  |  a | RFCXXXX |
| Base Time     | bt   | -3 | double  |  a | RFCXXXX |
| Base Unit     | bu   | -4 | string  |  a | RFCXXXX |
| Base Value    | bv   | -5 | double  |  a | RFCXXXX |
| Base Version  | bver | -1 | int     |  a | RFCXXXX |
| Boolean Value | vb   |  4 | boolean |  a | RFCXXXX |
| Data Value    | vd   |  8 | string  |  a | RFCXXXX |
| Name          | n    |  0 | string  |  a | RFCXXXX |
| String Value  | vs   |  3 | string  |  a | RFCXXXX |
| Time          | t    |  6 | double  |  a | RFCXXXX |
| Unit          | u    |  1 | string  |  a | RFCXXXX |
| Update Time   | ut   |  7 | double  |  a | RFCXXXX |
| Value         | v    |  2 | double  |  a | RFCXXXX |
| Value Sum     | s    |  5 | double  |  a | RFCXXXX |
| Link              | l    |  9 | string  |  a | RFCXXXX |
{: #tbl-seml-reg cols='r l l' title="SenML Labels"}

Note to RFC Editor. Please replace RFCXXXX with the number for this
RFC.

All new entries must define the Label Name, Label, and XML Type but
the CBOR labels SHOULD be left empty as CBOR will use the string
encoding for any new labels. The ID fields contains the EXI schemaId value
of the first Schema which includes this label or is empty if this
label was not intended for use with EXI. The Note field SHOULD contain
information about where to find out more information about this label.

The JSON, CBOR, and EXI types are derived from the XML type. All XML
numeric types such as double, float, integer and int become a JSON
Number. XML boolean and string become a JSON Boolean and String
respectively. CBOR represents numeric values with a CBOR type that
does not loose any information from the JSON value. EXI uses the XML
types.

New entries can be added to the registration by either Expert Review
or IESG Approval as defined in {{RFC5226}}.  Experts should exercise
their own good judgment but need to consider that shorter labels
should have more strict review.

All new SenML labels that have "base" semantics (see {{senml-base}})
MUST start with character 'b'. Regular labels MUST NOT start with that
character.

Extensions that add a label that is intended for use with XML need to
create a new RelaxNG scheme that includes all the labels in the IANA
registry.

Extensions that add a label that is intended for use with EXI need to
create a new XSD Schema that includes all the labels in the IANA
registry then allocate a new EXI schemaId value. Moving to the next letter
in the alphabet is the suggested way to create the new value for the EXI schemaId.
Any labels with previously blank ID values SHOULD be updated in the
IANA table to have their ID set to this new schemaId value.

Extensions that are mandatory to understand to correctly process the
Pack MUST have a label name that ends with the '_' character.

## Media Type Registration {#sec-iana-media}

The following registrations are done following the procedure specified
in {{RFC6838}} and {{RFC7303}}.
Clipboard formats are defined for the JSON and XML form of lists but do
not make sense for streams or other formats.

Note to RFC Editor - please remove this paragraph. Note that a request
for media type review for senml+json was sent to the
media-types@iana.org on Sept 21, 2010. A second request for all the
types was sent on October 31, 2016.


### senml+json Media Type Registration {#sec-senml-json}

Type name: application 

Subtype name: senml+json 

Required parameters: none 

Optional parameters: none 

Encoding considerations: Must be encoded as using a subset of the 
encoding allowed in {{RFC7159}}. See RFC-AAAA for details. This 
simplifies implementation of very simple system and does not impose 
any significant limitations as all this data is meant for machine to 
machine communications and is not meant to be human readable. 

Security considerations: Sensor data can contain a wide range of 
information ranging from information that is very public, such the 
outside temperature in a given city, to very private information that 
requires integrity and confidentiality protection, such as patient 
health information. This format does not provide any security and 
instead relies on the transport protocol that carries it to provide 
security. Given applications need to look at the overall context of 
how this media type will be used to decide if the security is 
adequate. 

Interoperability considerations: Applications should ignore any JSON 
key value pairs that they do not understand. This allows backwards 
compatibility extensions to this specification. The "bver" field can 
be used to ensure the receiver supports a minimal level of 
functionality needed by the creator of the JSON object. 

Published specification: RFC-AAAA 

Applications that use this media type: The type is used by systems 
that report e.g., electrical power usage and environmental information 
such as temperature and humidity. It can be used for a wide range of 
sensor reporting systems. 

Fragment identifier considerations: Fragment identification for 
application/senml+json is supported by using fragment identifiers as 
specified by RFC-AAAA. 

Additional information: 

Magic number(s): none 

File extension(s): senml 

Windows Clipboard Name: "JSON Sensor Measurement List" 

Macintosh file type code(s): none 

Macintosh Universal Type Identifier code: org.ietf.senml-json 
conforms to public.text 

Person & email address to contact for further information: 
Cullen Jennings \<fluffy@iii.ca>

Intended usage: COMMON 

Restrictions on usage: None 

Author: Cullen Jennings \<fluffy@iii.ca>

Change controller: IESG

### sensml+json Media Type Registration {#sec-sensml-json}

Type name: application 

Subtype name: sensml+json 

Required parameters: none 

Optional parameters: none 

Encoding considerations: Must be encoded as using a subset of the 
encoding allowed in {{RFC7159}}. See RFC-AAAA for details. This 
simplifies implementation of very simple system and does not impose 
any significant limitations as all this data is meant for machine to 
machine communications and is not meant to be human readable. 

Security considerations: Sensor data can contain a wide range of 
information ranging from information that is very public, such the 
outside temperature in a given city, to very private information that 
requires integrity and confidentiality protection, such as patient 
health information. This format does not provide any security and 
instead relies on the transport protocol that carries it to provide 
security. Given applications need to look at the overall context of 
how this media type will be used to decide if the security is 
adequate. 

Interoperability considerations: Applications should ignore any JSON 
key value pairs that they do not understand. This allows backwards 
compatibility extensions to this specification. The "bver" field can 
be used to ensure the receiver supports a minimal level of 
functionality needed by the creator of the JSON object. 

Published specification: RFC-AAAA 

Applications that use this media type: The type is used by systems 
that report e.g., electrical power usage and environmental information 
such as temperature and humidity. It can be used for a wide range of 
sensor reporting systems. 

Fragment identifier considerations: Fragment identification for 
application/senml+json is supported by using fragment identifiers as 
specified by RFC-AAAA. 

Additional information: 

Magic number(s): none 

File extension(s): sensml 

Macintosh file type code(s): none 

Person & email address to contact for further information: 
Cullen Jennings \<fluffy@iii.ca>

Intended usage: COMMON 

Restrictions on usage: None 

Author: Cullen Jennings \<fluffy@iii.ca>

Change controller: IESG 


### senml+cbor Media Type Registration 

Type name: application 

Subtype name: senml+cbor 

Required parameters: none 

Optional parameters: none 

Encoding considerations: Must be encoded as using {{RFC7049}}. See 
RFC-AAAA for details. 

Security considerations: Sensor data can contain a wide range of 
information ranging from information that is very public, such the 
outside temperature in a given city, to very private information that 
requires integrity and confidentiality protection, such as patient 
health information. This format does not provide any security and 
instead relies on the transport protocol that carries it to provide 
security. Given applications need to look at the overall context of 
how this media type will be used to decide if the security is 
adequate. 

Interoperability considerations: Applications should ignore any 
key value pairs that they do not understand. This allows backwards 
compatibility extensions to this specification. The "bver" field can 
be used to ensure the receiver supports a minimal level of 
functionality needed by the creator of the CBOR object. 

Published specification: RFC-AAAA 

Applications that use this media type: The type is used by systems 
that report e.g., electrical power usage and environmental information 
such as temperature and humidity. It can be used for a wide range of 
sensor reporting systems. 

Fragment identifier considerations: Fragment identification for 
application/senml+cbor is supported by using fragment identifiers as 
specified by RFC-AAAA. 

Additional information: 

Magic number(s): none 

File extension(s): senmlc 
 
Macintosh file type code(s): none 

Macintosh Universal Type Identifier code: org.ietf.senml-cbor 
conforms to public.data 

Person & email address to contact for further information: 
Cullen Jennings \<fluffy@iii.ca>

Intended usage: COMMON 

Restrictions on usage: None 

Author: Cullen Jennings \<fluffy@iii.ca>

Change controller: IESG 

### sensml+cbor Media Type Registration 

Type name: application 

Subtype name: sensml+cbor 

Required parameters: none 

Optional parameters: none 

Encoding considerations: Must be encoded as using {{RFC7049}}. See 
RFC-AAAA for details. 

Security considerations: Sensor data can contain a wide range of 
information ranging from information that is very public, such the 
outside temperature in a given city, to very private information that 
requires integrity and confidentiality protection, such as patient 
health information. This format does not provide any security and 
instead relies on the transport protocol that carries it to provide 
security. Given applications need to look at the overall context of 
how this media type will be used to decide if the security is 
adequate. 

Interoperability considerations: Applications should ignore any 
key value pairs that they do not understand. This allows backwards 
compatibility extensions to this specification. The "bver" field can 
be used to ensure the receiver supports a minimal level of 
functionality needed by the creator of the CBOR object. 

Published specification: RFC-AAAA 

Applications that use this media type: The type is used by systems 
that report e.g., electrical power usage and environmental information 
such as temperature and humidity. It can be used for a wide range of 
sensor reporting systems. 

Fragment identifier considerations: Fragment identification for 
application/senml+cbor is supported by using fragment identifiers as 
specified by RFC-AAAA. 

Additional information: 

Magic number(s): none 

File extension(s): sensmlc 
 
Macintosh file type code(s): none 

Person & email address to contact for further information: 
Cullen Jennings \<fluffy@iii.ca>

Intended usage: COMMON 

Restrictions on usage: None 

Author: Cullen Jennings \<fluffy@iii.ca>

Change controller: IESG 


### senml+xml Media Type Registration 

Type name: application 

Subtype name: senml+xml 

Required parameters: none 

Optional parameters: none 

Encoding considerations: Must be encoded as using 
{{W3C.REC-xml-20081126}}. See RFC-AAAA for details. 

Security considerations: Sensor data can contain a wide range of 
information ranging from information that is very public, such the 
outside temperature in a given city, to very private information that 
requires integrity and confidentiality protection, such as patient 
health information. This format does not provide any security and 
instead relies on the transport protocol that carries it to provide 
security. Given applications need to look at the overall context of 
how this media type will be used to decide if the security is 
adequate. 

Interoperability considerations: Applications should ignore any tags 
or attributes that they do not understand. This allows backwards 
compatibility extensions to this specification. The "bver" attribute in 
the senml tag can be used to ensure the receiver supports a minimal 
level of functionality needed by the creator of the XML. 

Published specification: RFC-AAAA 

Applications that use this media type: The type is used by systems 
that report e.g., electrical power usage and environmental information 
such as temperature and humidity. It can be used for a wide range of 
sensor reporting systems. 

Fragment identifier considerations: Fragment identification for 
application/senml+xml is supported by using fragment identifiers as 
specified by RFC-AAAA. 

Additional information: 

Magic number(s): none 

File extension(s): senmlx 

Windows Clipboard Name: "XML Sensor Measurement List" 

Macintosh file type code(s): none 

Macintosh Universal Type Identifier code: org.ietf.senml-xml 
conforms to public.xml 

Person & email address to contact for further information: 
Cullen Jennings \<fluffy@iii.ca>

Intended usage: COMMON 

Restrictions on usage: None 

Author: Cullen Jennings \<fluffy@iii.ca>

Change controller: IESG 


### sensml+xml Media Type Registration 

Type name: application 

Subtype name: sensml+xml 

Required parameters: none 

Optional parameters: none 

Encoding considerations: Must be encoded as using 
{{W3C.REC-xml-20081126}}. See RFC-AAAA for details. 

Security considerations: Sensor data can contain a wide range of 
information ranging from information that is very public, such the 
outside temperature in a given city, to very private information that 
requires integrity and confidentiality protection, such as patient 
health information. This format does not provide any security and 
instead relies on the transport protocol that carries it to provide 
security. Given applications need to look at the overall context of 
how this media type will be used to decide if the security is 
adequate. 

Interoperability considerations: Applications should ignore any tags 
or attributes that they do not understand. This allows backwards 
compatibility extensions to this specification. The "bver" attribute in 
the senml tag can be used to ensure the receiver supports a minimal 
level of functionality needed by the creator of the XML. 

Published specification: RFC-AAAA 

Applications that use this media type: The type is used by systems 
that report e.g., electrical power usage and environmental information 
such as temperature and humidity. It can be used for a wide range of 
sensor reporting systems. 

Fragment identifier considerations: Fragment identification for 
application/senml+xml is supported by using fragment identifiers as 
specified by RFC-AAAA. 

Additional information: 

Magic number(s): none 

File extension(s): sensmlx 

Macintosh file type code(s): none 

Person & email address to contact for further information: 
Cullen Jennings \<fluffy@iii.ca>

Intended usage: COMMON 

Restrictions on usage: None 

Author: Cullen Jennings \<fluffy@iii.ca>

Change controller: IESG 


### senml+exi Media Type Registration 

Type name: application 

Subtype name: senml+exi 

Required parameters: none 

Optional parameters: none 

Encoding considerations: Must be encoded as using 
{{W3C.REC-exi-20140211}}. See RFC-AAAA for details. 

Security considerations:  Sensor data can contain a wide range of 
information ranging from information that is very public, such the 
outside temperature in a given city, to very private information that 
requires integrity and confidentiality protection, such as patient 
health information. This format does not provide any security and 
instead relies on the transport protocol that carries it to provide 
security. Given applications need to look at the overall context of 
how this media type will be used to decide if the security is 
adequate. 

Interoperability considerations: Applications should ignore any tags 
or attributes that they do not understand. This allows backwards 
compatibility extensions to this specification. The "bver" attribute in 
the senml tag can be used to ensure the receiver supports a minimal 
level of functionality needed by the creator of the XML.  Further 
information on using schemas to guide the EXI can be found in 
RFC-AAAA. 

Published specification: RFC-AAAA 

Applications that use this media type: The type is used by systems 
that report e.g., electrical power usage and environmental information 
such as temperature and humidity. It can be used for a wide range of 
sensor reporting systems. 

Fragment identifier considerations: Fragment identification for 
application/senml+exi is supported by using fragment identifiers as 
specified by RFC-AAAA. 

Additional information: 

Magic number(s): none 

File extension(s): senmle 

Macintosh file type code(s): none 

Macintosh Universal Type Identifier code: org.ietf.senml-exi 
conforms to public.data 

Person & email address to contact for further information: 
Cullen Jennings \<fluffy@iii.ca>

Intended usage: COMMON 

Restrictions on usage: None 

Author: Cullen Jennings \<fluffy@iii.ca>

Change controller: IESG 


### sensml+exi Media Type Registration 

Type name: application 

Subtype name: sensml+exi 

Required parameters: none 

Optional parameters: none 

Encoding considerations: Must be encoded as using 
{{W3C.REC-exi-20140211}}. See RFC-AAAA for details. 

Security considerations:  Sensor data can contain a wide range of 
information ranging from information that is very public, such the 
outside temperature in a given city, to very private information that 
requires integrity and confidentiality protection, such as patient 
health information. This format does not provide any security and 
instead relies on the transport protocol that carries it to provide 
security. Given applications need to look at the overall context of 
how this media type will be used to decide if the security is 
adequate. 

Interoperability considerations: Applications should ignore any tags 
or attributes that they do not understand. This allows backwards 
compatibility extensions to this specification. The "bver" attribute in 
the senml tag can be used to ensure the receiver supports a minimal 
level of functionality needed by the creator of the XML.  Further 
information on using schemas to guide the EXI can be found in 
RFC-AAAA. 

Published specification: RFC-AAAA 

Applications that use this media type: The type is used by systems 
that report e.g., electrical power usage and environmental information 
such as temperature and humidity. It can be used for a wide range of 
sensor reporting systems. 

Fragment identifier considerations: Fragment identification for 
application/senml+exi is supported by using fragment identifiers as 
specified by RFC-AAAA. 

Additional information: 

Magic number(s): none 

File extension(s): sensmle 

Macintosh file type code(s): none 

Person & email address to contact for further information: 
Cullen Jennings \<fluffy@iii.ca>

Intended usage: COMMON 

Restrictions on usage: None 

Author: Cullen Jennings \<fluffy@iii.ca>

Change controller: IESG 



## XML Namespace Registration {#sec-iana-url}

This document registers the following XML namespaces in the IETF XML
registry defined in {{RFC3688}}.

URI: urn:ietf:params:xml:ns:senml

Registrant Contact: The IESG.

XML: N/A, the requested URIs are XML namespaces

## CoAP Content-Format Registration

IANA is requested to assign CoAP Content-Format IDs for the SenML
media types in the "CoAP Content-Formats" sub-registry, within the
"CoRE Parameters" registry {{RFC7252}}. All IDs are assigned from the
"Expert Review" (0-255) range. The assigned IDs are show in
{{tbl-coap-content-formats}}.

| Media type               | ID  |
| application/senml+json   | TBD |
| application/sensml+json  | TBD |
| application/senml+cbor   | TBD |
| application/sensml+cbor  | TBD |
| application/senml+xml    | TBD |
| application/sensml+xml   | TBD |
| application/senml+exi    | TBD |
| application/sensml+exi   | TBD |
{: #tbl-coap-content-formats cols="l l" title="CoAP Content-Format IDs"}
 

# Security Considerations {#sec-sec}

See {{sec-privacy}}. Further discussion of security properties can be
found in {{sec-iana-media}}.


# Privacy Considerations {#sec-privacy}

Sensor data can range from information with almost no security
considerations, such as the current temperature in a given city, to
highly sensitive medical or location data. This specification provides
no security protection for the data but is meant to be used inside
another container or transport protocol such as S/MIME or HTTP with
TLS that can provide integrity, confidentiality, and authentication
information about the source of the data.


# Acknowledgement

We would like to thank Alexander Pelov, Andrew McClure, Andrew
Mcgregor, Bjoern Hoehrmann, Christian Amsuess, Christian Groves,
Daniel Peintner, Jan-Piet Mens, Joe Hildebrand, John Klensin, Karl
Palsson, Lennart Duhrsen, Lisa Dusseault, Lyndsay Campbell, Martin
Thomson, Michael Koster, and Stephen Farrell, for their review
comments.


--- back

# Links Extension

An attribute to support a link extension for SenML is defined as a
string attribute by this specification. The link extension can be used
for additional information about a SenML Record.  The definition and
usage of the contents of this value are specified in
{{I-D.ietf-core-links-json}}.

For JSON and XML the attribute has a label of "l" and a value that is
a string.

The following shows an example of the links extension.

~~~~
{::include ex8.gen.wrap.json}
~~~~
