//
//  Constants.swift
//  FreeGoods
//
//  Created by Mehul Shah on 6/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
let APP_NAME_TITLE  = "Skroman"
let TUTORIAL_SHOWN  = "TUTORIAL_SHOWN"
let ALERT  = "Alert"

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

let COMMUNITY_MODE_PUBLIC = "PUBLIC"
let COMMUNITY_MODE_PRIVATE = "PRIVATE"
let COMMUNITY_MODE_ALL = "ALL"

let PRODUCT_STATUS_AVAILABLE = "AVAILABLE"
let PRODUCT_STATUS_RESERVED = "RESERVED"
let PRODUCT_STATUS_LOOKING_FOR = "LOOKING FOR"

let LISTING_TYPE_ALL = "ALL"
let LISTING_TYPE_I_NEED = "SOMETHING_TO_NEED"
let LISTING_TYPE_I_GIVING_AWAY = "SOMETHING_TO_GIVE"


let REVIEW_TYPE_AS_GIVER = "SOMETHING_TO_GIVE"
let REVIEW_TYPE_AS_RECEIVER = "SOMETHING_TO_NEED"

let PRODUCT_CONDITION_NEW = "NEW"
let PRODUCT_CONDITION_ANY = "ANY"

let PRODUCT_SORT_BY_NEWEST = "newest"
let PENDING = "PENDING"
let RESERVED = "RESERVED"

let SOMETHING_TO_GIVE = "SOMETHING_TO_GIVE"
let SOMETHING_I_NEED = "SOMETHING_TO_NEED"

let USER_STATUS_INVITE = "INVITE"
let USER_STATUS_PENDING = "INVITED"
let USER_STATUS_ACCEPTED = "ACCEPTED"

let EMAIL_NOTIFICATION_TYPE_IS_NOTIFICATION = "IS_NOTIFICATION"
let EMAIL_NOTIFICATION_TYPE_NEW_CHAT_MESSAGE = "NEW_CHAT_MESSAGES"
let EMAIL_NOTIFICATION_TYPE_NEW_COMMENT = "NEW_COMMENTS"
let EMAIL_NOTIFICATION_TYPE_NEW_MATCHES = "NEW_MATCHES"
let EMAIL_NOTIFICATION_TYPE_NEW_COMMUNITY_INVITE = "NEW_COMMUNITY_INVITE"
let EMAIL_NOTIFICATION_TYPE_PROMOTION_FREEGOOD = "PROMOTION_FREEGOOD"

let NOTIFICATION_TYPE_COMMUNITY_INVITE = "COMMUNITY_INVITE"
let NOTIFICATION_TYPE_COMMUNITE_REQUEST = "COMMUNITE_REQUEST"
let NOTIFICATION_TYPE_FREEGOOD_REQUEST = "FREEGOOD_REQUEST"
let NOTIFICATION_TYPE_FREEGOOD_REJECTED = "FREEGOOD_REJECTED"
let NOTIFICATION_TYPE_FREEGOOD_ACCEPTED = "FREEGOOD_ACCEPTED"
let NOTIFICATION_TYPE_PRODUCT_LIKE = "PRODUCT_LIKE"
let NOTIFICATION_TYPE_PRODUCT_REVIEW = "PRODUCT_REVIEW"
let NOTIFICATION_TYPE_PRODUCT_REVIEW_GIVEN = "PRODUCT_REVIEW_GIVEN"
let NOTIFICATION_TYPE_PRODUCT_THANKYOU_NOTE = "PRODUCT_THANKYOU_NOTE"
let NOTIFICATION_TYPE_PRODUCT_SIMILIER_LINK = "PRODUCT_SIMILIER_LINK"
let NOTIFICATION_TYPE_SIMILAR_COMMUNITY = "SIMILAR_COMMUNITY"
let NOTIFICATION_TYPE_PRODUCT_PUBLIC_COMMENT = "PRODUCT_PUBLIC_COMMENT"
let NOTIFICATION_TYPE_COMMUNITE_APPROVED = "COMMUNITE_APPROVED"
let NOTIFICATION_TYPE_COMMUNITE_JOINED = "COMMUNITE_JOINED"
let MEETUP = "MEETUP"
let MAILING = "MAILING"
let LOCATION = "LOCATION"
let COMMUNITY = "Community"
let NEWEST = "newest"
let CLOSEST = "closest"
let CATEGORY = "Category"
let DELIVERY = "Delivery"
let ADDITIONAL_INFO = "Additional Info"

let REFRESH_PRODUCT_DETAILS = "REFRESH_PRODUCT_DETAILS"
let REFRESH_HOME = "REFRESH_HOME"
let REFRESH_PRODUCT_LIST = "REFRESH_PRODUCT_LIST"

let SERVER_DATE_FORMAT = "yyyy-MM-dd HH:mm:ss"

let DD_MM_YYYY = "dd/MM/yyyy"

let ACCEPT = "ACCEPT"
let REJECT = "REJECT"
let REQUEST = "REQUEST"
let AWARDED = "AWARDED"
let TEXT_VIEW_MAX_CHAR = 100
enum ImageViewComfrom : Int {
    case user = 1
    case product = 2
    case Community = 3
    case story = 4
}

enum TokenTableViewCellType : NSInteger {
//    case MyToken = 0
    case TotalItemsReceived = 0
    case TotalItemsGiven = 1
    case TokensThisMonth = 2
    case MyTotalTokens = 3
}

enum ListViewComefrom : Int {
    case ListViewComefromHistory = 0
    case ListViewComefromINeed = 1
    case ListViewComefromGivingAway = 2
    case Home = 3
    case CreateList = 4
    case OthersProfile = 5
}

enum ReviewViewComefrom : Int {
    case ReviewViewComefromAsGiver = 0
    case ReviewViewComefromAsRecevier = 1
    case ReviewViewComefromOthersProfile = 2
}

enum ProfileViewCellType : Int {
    case ProfileViewCellTypePublicInfo = 0
    case ProfileViewCellTypeMyListing = 1
    case ProfileViewCellTypeMyReviews = 2
    case ProfileViewCellTypeMyTokens = 3
    case ProfileViewCellTypeMyCommunity = 4
    case ProfileViewCellTypePrivateInfo = 5
    case ProfileViewCellTypeMyFavourite = 6
    case ProfileViewCellTypeThankYouNotes = 7
}

enum ProductDetailsTableViewCellType : Int{
    case ProductDetailsTableViewCellTypePersonalInfo = 0
    case ProductDetailsTableViewCellTypeLocation = 1
    case ProductDetailsTableViewCellTypeDetails = 2
}

enum SettingTableViewCellType : Int{
    case SettingTableViewCellTypeNotificationSetting = 0
    case SettingTableViewCellTypeBuildTrus = 1
    case SettingTableViewCellTypeReferFriend = 2
    case SettingTableViewCellTypeEmailSupport = 3
    case SettingTableViewCellTypeDeactivateAccount = 4
    case SettingTableViewCellTypeAdditionalInfo = 5
    case SettingTableViewCellTypeFAQ = 6
    case SettingTableViewCellTypeCommunityGuidelines = 7
    case SettingTableViewCellTypePrivacyPolicy = 8
    case SettingTableViewCellTypeTermsService = 9
    case SettingTableViewCellTypeAboutUs = 10
    case SettingTableViewCellTypeLogout = 11
}

enum TokenViewCellType : Int{
    case TokenViewCellTypeMyTokens = 0
    case TokenViewCellTypeItemsReceived = 1
    case TokenViewCellTypeItemsGiven = 2
    case TokenViewCellTypeTokenThisMonth = 3
    case TokenViewCellTypeTotalToken = 4
}

enum WebViewComefrom : Int{
    case WebViewComefromTermsAndCondition = 0
    case WebViewComefromPrivacyPolicy = 1
    case WebViewComefromFaq = 2
    case WebViewComefromCommunicationGuidelines = 3
    case WebViewComefromAboutUs = 4
    case WebViewComefromStories = 5
}

enum FilterCellType : Int{
    case FilterCellTypeCategory = 0
    case FilterCellTypeSubCategory = 1
    case FilterCellTypeCondition = 2
    case FilterCellTypeLocation = 3
    case FilterCellTypeDistance = 4
    case FilterCellTypeSortBy = 5
}

enum ChangeMobileComefrom : Int{
    case  OTP = 0
    case  EditProfile = 1
}

enum CategoryViewComefrom : Int{
    case  Category = 0
    case  SubCategory = 1
    case  Condition = 2
}

enum MyCommunityViewComefrom : NSInteger {
    case Normal = 0
    case Alphabetical = 1
    case Nearest = 2
    case RecentlyAdded = 3
    case CommunityList = 4
    case SelectCommunity = 5
    case MyCommunityFromSearch = 6
}

enum PopupComfrom : Int {
    case SignUp = 1
    case Report = 2
    case WantFreeGood = 3
    case ConfirmRequest = 4
    case List = 5
    case SubmitProductGive = 6
    case SubmitProductNeed = 7
    case CancelProduct = 8
    case JoinCommunity = 9
    case LeaveCommunity = 10
    case AcceptProduct = 11
    case SaveAsDraft = 12
    case AddCommunity = 13
    case ICanGiveFreeGood = 14


}

enum CreateListComefrom : Int {
    case ToGive = 1
    case INeed = 2
}

enum LocationViewComefrom : Int {
    case Filter = 0
    case AddCommunity = 1
}

enum ProductListComeFrom : Int {
    case ViewAll = 0
    case Search = 1
    case Menu = 2

}

enum MemberRequestCellComeFrom : Int {
    case Request = 0
    case Invite = 1
    case Chat = 2
}

enum ChatComeFrom : Int {
    case ProductDetails = 0
    case Inbox = 1
}

enum EmailNotificationCellType : Int{
    case EmailNotificationCellTypeIsNotification = 0
    case EmailNotificationCellTypeNewChatMessage = 1
    case EmailNotificationCellTypeNewComments = 2
    case EmailNotificationCellTypeNewMatches = 3
    case EmailNotificationCellTypeNewCommunityInvite = 4
    case EmailNotificationCellTypePromoteFreegood = 5
}


//FOR SKORMAN
enum QRCodeScannerViewControllerComeFrom : Int {
	case RegisterFlow = 0
	case AddDeviceFlow = 1

}
