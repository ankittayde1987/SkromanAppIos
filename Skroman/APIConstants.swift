

import UIKit

//var BASE_HTTP_URL  = "http://192.168.2.39:3000"
var BASE_HTTP_URL = "https://www.e-stree.com:6000"
var BASE_HTTP_URL_FOR_ADD_DEVICE = "192.168.4.1"
var PORT_FOR_ADD_DEVICE = 54312

var DEVICE_TYPE = "ios"
var MD5_CONSTANT_KEY = "$P#H!N@X%TR!"

var TERMS_URL =  "http://34.199.202.75/freegoods/terms_conditions"



var SOCIAL_TYPE_FACEBOOK = "FACEBOOK"
var SOCIAL_TYPE_TWITTER = "TWITTER"
var SOCIAL_TYPE_GOOGLE = "GOOGLE"
var SOCIAL_TYPE_INSTAGRAM = "INSTAGRAM"

var CONNECT = "connect"
var DISCONNECT = "disconnect"

func SSLog(message: Any?) {
    #if DEBUG
        print("\(message)")
    #endif
}
