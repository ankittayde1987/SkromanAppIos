//
//  Constants.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 10/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation



/* for api json parameters */


let SERVER_ID               = "pi_id"
let USER_ID                 = "user_id"
let SYNCDATA                = "syncData"
let HOME_ID                 = "home_id"
let ROOM_ID                 = "room_id"
let SWITCHBOX_ID            = "switchbox_id"
let SWITCH_ID               = "switch_id"
let TYPE                    = "type"
let STATUS                  = "status"
let POSITION                = "position"
let WATTAGE                 = "wattage"
let SLIDE_END               = "slide_end"
let MASTER_MODE_STATUS      = "master_mode_status"
let MASTER_MODE_ACTIVE      = "master_mode_active"
let MASTER_MODE_SWITCH_ID   = "master_mode_switch_id"
let CHILD_LOCK_STATUS       = "child_lock_status"
let CHILD_LOCK_ACTIVE       = "child_lock_active"
let roomConstant            = "rooms"
let ROOM_NAME               = "room_name"
let SWITCHBOXES             = "switchboxes"
let NAME                    = "name"
let EMAIL                    = "email"
let PHONE                    = "phone"
let SWITCHES                = "switches"


/* cell sizes */


let CellSize : Float = 140


/* Switch type */


let SwitchOnOffType = 0
let SwitchSpeedType = 1
let SwitchMoodType  = 2


/* Switch status */


let SwitchStatusOFF = 0
let SwitchStatusON  = 1


/* Mastermode status */


let MasterModeOFF = 0
let MasterModeON  = 1


/* Childlock status */


let ChildLockOFF =  0
let ChildLockON  = 1


/* FOR MQTT PUBLISH */


let PUBLISH_UPDATE_SWITCH           = "update_switch"
let PUBLISH_Master_Mode_App_To_Rpi  = "master_mode_app_to_rpi"
let PUBLISH_Child_Mode_App_To_Rpi   = "child_mode_app_to_rpi"


/* FOR MQTT SUBSCRIBE */


let SUBSCRIBE_UPDATE_SWITCH           = "update_switch_ack_app"
let SUBSCRIBE_Master_Mode_Feedback    = "master_mode_feedback"
let SUBSCRIBE_Child_Mode_Feedback   = "child_mode_feedback"
