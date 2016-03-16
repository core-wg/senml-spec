# TODO List

add in a link format from draft-ietf-core-interfaces-04

? make base values only allowed in first record

? make the base and other values mutuall exclusive -

? show a non scalar extention in XML (such as link)


{
"bn":"/3300/1/",
“i":[
{"n":"5700","v":"31.3"},
{"n":"5602","v":"37.1"},
{"n":"5601","v":"18.3"},
{"n":"5605"},
{"n":"5603","v":"0"},
{"n":"5604","v":"100"},
{"n":"5750","sv":"Inboard Bearing"}
],
"l":[
{"href":"","rel":"self","rt":"temperature","u":"C"},
{"href":"5700","rt":"currentValue","u":"C"},
{"href":"5602","rt":"maxValue","u":"C"},
{"href":"5601","rt":"minValue","u":"C"},
{"href":"5605","rt":"resetMaxMin"},
{"href":"5603","rt":"minScale","u":"C"},
{"href":"5604","rt":"maxScale","u":"C"},
{"href":"5750","rt":"appType"}
]
}

? define a "expanded" document as no base names and no releative (negative) times

