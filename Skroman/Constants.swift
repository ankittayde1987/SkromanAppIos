

import UIKit
let APP_NAME_TITLE  = "Skroman"
let TUTORIAL_SHOWN  = "TUTORIAL_SHOWN"
let ALERT  = "Alert"
let CONSTANT_LANGUAGE_CODE  = "EN"
let KEY_USER_ID = "user_id"
let IMAGENAME = "customImage"
let IMAGE_PATH = "file:///var/mobile/Containers/Data/Application/C5F8F4CE-42FF-4761-93C9-A482921074FC/Documents/"
let CONSTANT_IPAD_VIEW_WIDTH  = CGFloat(414.0)

var kDateFormatTypeWithoutTime: String = "yyyy-MM-dd"
var kDateFormatTypeForSMS: String = "dd/MM/yyyy"

var kTimeFormatFor12Hours: String = "hh:mm a"
var kTimeFormatFor24Hours: String = "HH:mm"
var kDateFormatTypeBasicDateTime: String = "dd-MM-yyyy hh:mm a"
var kDateFormatTypeZFormatted: String = "yyyy-MM-dd'T'HH:mm:ss'Z'"
var kDateFormatTypeGeneric: String = "yyyy-MM-dd hh:mm a"
var kDateFormatTypeGeneric24Hours: String = "yyyy-MM-dd HH:mm:ss"
//var kDateFormatForDayAndDate: String = "EEE, MMM dd"
var kDateFormatForDayAndDate: String = "EEEE dd MMM"

var kDateFormatDayMonYear: String = "dd MMM yyyy"
var kDateFormatTypeGeneric24HoursForStartEndDate: String = "dd MMM yyyy HH:mm"
var kDateFormatTypeBasicForStartEndDate: String = "dd MMM yyyy hh:mm a"


var kOnlineConstant = "Online (WiFi)"
var kOnlineConstantWWAN = "Online (WWAN)"


func SYSTEM_VERSION_EQUAL_TO(v: Any) -> Any {
    return UIDevice.current.systemVersion.compare(v as! String, options: .numeric) == .orderedSame
}
func SYSTEM_VERSION_GREATER_THAN(v: Any) -> Any {
    return UIDevice.current.systemVersion.compare(v as! String, options: .numeric) == .orderedDescending
}
func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v: Any) -> Bool {
    return UIDevice.current.systemVersion.compare(v as! String, options: .numeric) != .orderedAscending
}
func SYSTEM_VERSION_LESS_THAN(v: Any) -> Any {
    return UIDevice.current.systemVersion.compare(v as! String, options: .numeric) == .orderedAscending
}
func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v: Any) -> Any {
    return UIDevice.current.systemVersion.compare(v as! String, options: .numeric) != .orderedDescending
}
let APP_NAME = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"]
let btn_corner_radius : CGFloat = 20.0;

let TEMPORARY_SSID = "SkFi01"//"Skrs72"
let TEMPORARY_PASSWORD = "server01"//"pi123456"

let SERVER_DATE_FORMAT = "yyyy-MM-dd HH:mm:ss"

let DD_MM_YYYY = "dd/MM/yyyy"

let TEXT_VIEW_MAX_CHAR = 100

let DUMMY_MOOD_ID = "5000"
let ALL_ROOM_ID = "5000"

let SWITCH_TYPE_LIGHT: Int = 0
let SWITCH_TYPE_FAN: Int = 1
let SWITCH_TYPE_MOOD: Int = 2
let SWITCH_TYPE_DIMMER: Int = 3

let SWITCH_STATUS_ON: Int = 0
let SWITCH_STATUS_OFF: Int = 1

let MOOD_TYPE_HOME = 1
let MOOD_TYPE_ROOM = 1
let MOOD_TYPE_DEVICE = 3
enum ImageViewComfrom : Int {
    case user = 1
    case product = 2
    case Community = 3
    case story = 4
}
enum QRCodeScannType : Int {
    case home = 1
    case device = 2
    case newHomeFromMyHomes = 3
}
let GOOGLE_CLIENT_KEY = "520418178928-jibanj1718djk96j1bvpui5406ugpok5.apps.googleusercontent.com"


let SM_GLOBAL_PREFIX = "global_in/"
let SM_GLOBAL_PREFIX_ACK = "global_vps_app/"


var current_pid = VVBaseUserDefaults.getCurrentPIID()
var current_home_id = VVBaseUserDefaults.getCurrentHomeID()

let SM_GET_PI_ID_ACK = "get_pi_id_ack"
let SM_GET_PI_ID = "get_pi_id"


let SM_TOPIC_SUBSCRIBE_ALL = "\(VVBaseUserDefaults.getCurrentPIID())/#"


let SM_TOPIC_SYNC_EVERYTHING = "\(current_pid)/sync_everything"
let SM_TOPIC_SYNC_EVERYTHING_ACK = "\(current_pid)/sync_everything_ack"

//pi_id + "/" + pi_home_id + "/update_switch";
let SM_TOPIC_UPDATE_SWITCH = "\(current_pid)/\(current_home_id)/update_switch"
let SM_TOPIC_UPDATE_SWITCH_ACK_APP = "\(current_pid)/\(current_home_id)/update_switch_ack_app"

// topic_create_room = pi_id + "/" + pi_home_id + "/create_room";
let SM_TOPIC_CREATE_ROOM = "\(current_pid)/\(current_home_id)/create_room"
let SM_TOPIC_CREATE_ROOM_ACK = "\(current_pid)/\(current_home_id)/create_room_ack"

//topic_rename_room = pi_id + "/" + pi_home_id + "/rename_room";
let SM_TOPIC_RENAME_ROOM = "\(current_pid)/\(current_home_id)/rename_room"
let SM_TOPIC_RENAME_ROOM_ACK = "\(current_pid)/\(current_home_id)/rename_room_ack"

//topic_create_home_mood = pi_id + "/" + pi_home_id + "/create_moods";
let SM_TOPIC_CREATE_HOME_MOOD = "\(current_pid)/\(current_home_id)/create_moods"
let SM_TOPIC_CREATE_HOME_MOOD_ACK = "\(current_pid)/\(current_home_id)/create_moods_ack"

//topic_edit_home_mood = pi_id + "/" + pi_home_id + "/edit_home_mood";
let SM_TOPIC_EDIT_HOME_MOOD = "\(current_pid)/\(current_home_id)/edit_home_mood" //It has same ack as SM_TOPIC_CREATE_HOME_MOOD_ACK so not created

//topic_rename_mood = prefix + pi_id + "/" + pi_home_id + "/rename_mood";
let SM_TOPIC_RENAME_HOME_MOOD = "\(current_pid)/\(current_home_id)/rename_mood"
let SM_TOPIC_RENAME_HOME_MOOD_ACK = "\(current_pid)/\(current_home_id)/rename_mood_ack"

//topic_delete_home_mood = pi_id + "/" + pi_home_id + "/delete_home_mood";
let SM_TOPIC_DELETE_HOME_MOOD = "\(current_pid)/\(current_home_id)/delete_home_mood"
let SM_TOPIC_DELETE_HOME_MOOD_ACK = "\(current_pid)/\(current_home_id)/delete_home_mood_ack"


//topic_master_mode_app_to_rpi = prefix + pi_id + "/" + pi_home_id + "/master_mode_app_to_rpi";
let SM_TOPIC_MASTER_MOOD_APP_TO_RPI = "\(current_pid)/\(current_home_id)/master_mode_app_to_rpi"
let SM_TOPIC_MASTER_MOOD_APP_TO_RPI_FEEDBACK = "\(current_pid)/\(current_home_id)/master_mode_feedback"

// topic_child_mode_app_to_rpi = prefix + pi_id + "/" + pi_home_id + "/child_mode_app_to_rpi";
let SM_TOPIC_CHILD_MOOD_APP_TO_RPI = "\(current_pid)/\(current_home_id)/child_mode_app_to_rpi"
let SM_TOPIC_CHILD_MOOD_APP_TO_RPI_FEEDBACK = "\(current_pid)/\(current_home_id)/child_mode_feedback"


// topic_child_mode_app_to_rpi = prefix + pi_id + "/" + pi_home_id + "/child_mode_app_to_rpi";
let SM_TOPIC_CREATE_HOME = "\(current_pid)/create_home"
let SM_TOPIC_CREATE_HOME_ACK = "\(current_pid)/create_home_ack"


//PI-VI2MI3/HM-0B3D3/set_wattage
//PI-VI2MI3/HM-0B3D3/set_wattage_ack
let SM_TOPIC_SET_WATTAGE = "\(current_pid)/\(current_home_id)/set_wattage"
let SM_TOPIC_SET_WATTAGE_ACK = "\(current_pid)/\(current_home_id)/set_wattage_ack"


// get_energy_consumption = prefix + pi_id + "/" + pi_home_id + "/get_energy_consumption";
let SM_TOPIC_GET_ENERGY_CONSUMPTION = "\(current_pid)/\(current_home_id)/get_energy_consumption"
let SM_TOPIC_GET_ENERGY_CONSUMPTION_ACK = "\(current_pid)/\(current_home_id)/get_energy_consumption_ack"


//PI-VI3MI4/delete_everything
//PI-VI3MI4/delete_everything_ack
let SM_TOPIC_DELETE_EVERYTHING = "\(current_pid)/delete_everything"
let SM_TOPIC_DELETE_EVERYTHING_ACK = "\(current_pid)/delete_everything_ack"

//PI_ID/HOME_ID/get_configuration_data
//PI_ID/HOME_ID/create_switchbox_ack.
let SM_TOPIC_GET_CONFIGURATION_DATA = "\(current_pid)/\(current_home_id)/get_configuration_data"
let SM_TOPIC_CREATE_SWITCHBOX_ACK = "\(current_pid)/\(current_home_id)/create_switchbox_for_app"


//PI_ID/HOME_ID/rename_switch
//PI_ID/HOME_ID/rename_switch_ack.
let SM_TOPIC_RENAME_SWITCH = "\(current_pid)/\(current_home_id)/rename_switch"
let SM_TOPIC_RENAME_SWITCH_ACK = "\(current_pid)/\(current_home_id)/rename_switch_ack"



//global_in/PI-VI3MI5/link_user_and_pi
//global_vps_app/PI-VI3MI5/link_user_and_pi_ack
let SM_TOPIC_LINK_USER_ID_AND_PI_ID = "global_in/\(current_pid)/link_user_and_pi"
let SM_TOPIC_LINK_USER_ID_AND_PI_ID_ACK = "global_vps_app/\(Utility.getCurrentUserId())/link_user_and_pi_ack"


//global_in/get_previous_data
//global_vps_app/pradip123456789/get_previous_data
let SM_TOPIC_GET_PREVIOUS_DATA = "global_in/get_previous_data"
let SM_TOPIC_GET_PREVIOUS_DATA_ACK = "global_vps_app/\(Utility.getCurrentUserId())/get_previous_data"


//global_in/PI-VI2MI3/sync_for_vps
//global_vps_app/pradip12345678/sync_for_vps_ack
let SM_TOPIC_GLOBAL_SYNC_FOR_VPS = "global_in/\(current_pid)/sync_for_vps"
let SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK = "global_vps_app/\(Utility.getCurrentUserId())/sync_for_vps_ack"


//Added on 15 - 04 - 2019
//Edit hardware mood: Sends request on incorrect topic (PI-VI3MI5/HM-02A0F/edit_home_mood). Correct topic is PIID/HOMEID/create_hardware_mood_from_app
let SM_TOPIC_EDIT_HARDWARD_MOOD_FROM_APP = "\(current_pid)/\(current_home_id)/create_hardware_mood_from_app" //It has same ack as SM_TOPIC_CREATE_HOME_MOOD_ACK so not created


//PI-VI2MI3/HM-0B3D3/hardware_mood_triggered
//PI-VI2MI3/HM-0B3D3/update_mood_status_ack
let SM_TOPIC_HARDWARD_MOOD_TRIGGERED = "\(current_pid)/\(current_home_id)/hardware_mood_triggered"
let SM_TOPIC_HARDWARD_MOOD_TRIGGERED_ACK = "\(current_pid)/\(current_home_id)/update_mood_status_ack"


//PI-VI3MI5/HM-02A0F/delete_room
//PI-VI3MI5/HM-02A0F/delete_room_ack
let SM_TOPIC_DELETE_ROOM = "\(current_pid)/\(current_home_id)/delete_room"
let SM_TOPIC_DELETE_ROOM_ACK = "\(current_pid)/\(current_home_id)/delete_room_ack"


//PI-VI3MI5/HM-02A0F/delete_switchbox
//PI-VI3MI5/HM-02A0F/delete_switchbox_ack
let SM_TOPIC_DELETE_SWITCHBOX = "\(current_pid)/\(current_home_id)/delete_switchbox"
let SM_TOPIC_DELETE_SWITCHBOX_ACK = "\(current_pid)/\(current_home_id)/delete_switchbox_ack"

//PI-VI3MI5/HM-02A0F/rename_switchbox
//PI-VI3MI5/HM-02A0F/rename_switchbox_ack
let SM_TOPIC_RENAME_SWITCHBOX = "\(current_pid)/\(current_home_id)/rename_switchbox"
let SM_TOPIC_RENAME_SWITCHBOX_ACK = "\(current_pid)/\(current_home_id)/rename_switchbox_ack"


let SM_TOPIC_GLOBAL_SYNC_FOR_VPS_LEFT_MENU = "\(current_pid)/sync_for_vps"
let SM_TOPIC_GLOBAL_SYNC_FOR_VPS_ACK_LEFT_MENU = "\(Utility.getCurrentUserId())/sync_for_vps_ack"

//global_in/PI-VI2MI2/get_ssid_password
//global_vps_app/pradip123456/get_ssid_password_ack
let SM_TOPIC_GLOBAL_GET_SSID_AND_PASSWORD = "global_in/\(current_pid)/get_ssid_password"
let SM_TOPIC_GLOBAL_GET_SSID_AND_PASSWORD_ACK = "global_vps_app/\(Utility.getCurrentUserId())/get_ssid_password_ack"


enum MenuViewControllerComeFrom : Int {
	case room = 0
	case switches = 1
	case deviceMoods = 2
    case homeMoods = 3
    case roomMoods = 4
}
enum SkormanPopupViewControllerComeFrom : Int {
	case renameSwitchBox = 0
	case addNewMood = 1
	case renameMoodName = 2
	case editHomeMood = 3
    case switchPowerConsumption = 4
    case addRoomMood = 5

}
enum SelectOptionViewControllerComeFrom : Int {
	case selectHome = 0
	case selectRoom = 1
	case selectRoomForDataUsage = 2
	case selectDeviceForDataUsage = 3
}
enum DataUsageViewControllerComeFrom : Int {
	case home = 0
	case roomDetails = 1
}
enum MoodSettingsMainContainerViewControllerComeFrom : Int {
	case addNewHomeMood = 0
    case editHomeMood = 1
    case addNewRoomMood = 2
    case editRoomMood = 3
}
enum AddNewHomeViewControllerComeFrom : Int {
	case addNewHome = 0
	case editHome = 1
}
enum AddNewRoomViewControllerComeFrom : Int {
	case addNewRoom = 0
	case editRoom = 1
}
enum DeleteOptionsPopupViewControllerComeFrom : Int {
	case deleteHomeMood = 0
	case deleteRoom = 1
}
enum SetStepperValuePopupViewControllerComeFrom : Int {
	case roomDetails = 0
	case moodSeetings = 1
}
