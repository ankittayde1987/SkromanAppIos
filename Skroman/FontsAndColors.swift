
import UIKit

var INVALID_MISSING_TOKEN:String = "Invalid or missing login token."

let SCREEN_SIZE:CGSize = UIScreen.main.bounds.size
let NAVIGATION_HEIGHT : CGFloat = 64.0
let TAB_HEIGHT : CGFloat = 49.0
let PAGE_MENU_HEIGHT : CGFloat = 34.0

let UIAppDelegate = UIApplication.shared.delegate as! AppDelegate

let IS_IPHONE_6_Or_GREATER:Bool = (SCREEN_SIZE.height > 568.0)

let DATE_DISPLAY_FORMAT  = "MMM dd, yyyy hh:mm:ss a"


func SSLocalizedString(key: String) -> String {
    return LanguageManager.get(key: key, alter: "")
}

let FONT_INCREMENT:CGFloat = (SCREEN_SIZE.width == 320 ? 0.0 : 2.0)
let SanFranciscoText_Medium = "SanFranciscoText-Medium"
let SanFranciscoText_Regular = "SanFranciscoText-Regular"
let Titillium_Regular = "Titillium-Regular"
let Titillium_Semibold = "Titillium-Semibold"


let Font_SanFranciscoText_Regular_H06 =  UIFont(name: SanFranciscoText_Regular, size: 6.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H07 =  UIFont(name: SanFranciscoText_Regular, size: 7.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H08 =  UIFont(name: SanFranciscoText_Regular, size: 8.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H09 =  UIFont(name: SanFranciscoText_Regular, size: 9.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H10 =  UIFont(name: SanFranciscoText_Regular, size: 10.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H11 =  UIFont(name: SanFranciscoText_Regular, size: 11.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H12 =  UIFont(name: SanFranciscoText_Regular, size: 12.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H13 =  UIFont(name: SanFranciscoText_Regular, size: 13.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H14 =  UIFont(name: SanFranciscoText_Regular, size: 14.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H15 =  UIFont(name: SanFranciscoText_Regular, size: 15.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H16 =  UIFont(name: SanFranciscoText_Regular, size: 16.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H17 =  UIFont(name: SanFranciscoText_Regular, size: 17.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H18 =  UIFont(name: SanFranciscoText_Regular, size: 18.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H19 =  UIFont(name: SanFranciscoText_Regular, size: 19.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H20 =  UIFont(name: SanFranciscoText_Regular, size: 20.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H21 =  UIFont(name: SanFranciscoText_Regular, size: 21.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H22 =  UIFont(name: SanFranciscoText_Regular, size: 22.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H23 =  UIFont(name: SanFranciscoText_Regular, size: 23.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H24 =  UIFont(name: SanFranciscoText_Regular, size: 24.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H25 =  UIFont(name: SanFranciscoText_Regular, size: 25.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H26 =  UIFont(name: SanFranciscoText_Regular, size: 26.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H27 =  UIFont(name: SanFranciscoText_Regular, size: 27.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H28 =  UIFont(name: SanFranciscoText_Regular, size: 28.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H29 =  UIFont(name: SanFranciscoText_Regular, size: 29.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Regular_H30 =  UIFont(name: SanFranciscoText_Regular, size: 30.0 + FONT_INCREMENT)


let Font_SanFranciscoText_Medium_H06 =  UIFont(name: SanFranciscoText_Medium, size: 6.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H07 =  UIFont(name: SanFranciscoText_Medium, size: 7.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H08 =  UIFont(name: SanFranciscoText_Medium, size: 8.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H09 =  UIFont(name: SanFranciscoText_Medium, size: 9.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H10 =  UIFont(name: SanFranciscoText_Medium, size: 10.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H11 =  UIFont(name: SanFranciscoText_Medium, size: 11.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H12 =  UIFont(name: SanFranciscoText_Medium, size: 12.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H13 =  UIFont(name: SanFranciscoText_Medium, size: 13.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H14 =  UIFont(name: SanFranciscoText_Medium, size: 14.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H15 =  UIFont(name: SanFranciscoText_Medium, size: 15.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H16 =  UIFont(name: SanFranciscoText_Medium, size: 16.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H17 =  UIFont(name: SanFranciscoText_Medium, size: 17.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H18 =  UIFont(name: SanFranciscoText_Medium, size: 18.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H19 =  UIFont(name: SanFranciscoText_Medium, size: 19.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H20 =  UIFont(name: SanFranciscoText_Medium, size: 20.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H21 =  UIFont(name: SanFranciscoText_Medium, size: 21.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H22 =  UIFont(name: SanFranciscoText_Medium, size: 22.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H23 =  UIFont(name: SanFranciscoText_Medium, size: 23.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H24 =  UIFont(name: SanFranciscoText_Medium, size: 24.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H25 =  UIFont(name: SanFranciscoText_Medium, size: 25.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H26 =  UIFont(name: SanFranciscoText_Medium, size: 26.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H27 =  UIFont(name: SanFranciscoText_Medium, size: 27.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H28 =  UIFont(name: SanFranciscoText_Medium, size: 28.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H29 =  UIFont(name: SanFranciscoText_Medium, size: 29.0 + FONT_INCREMENT)
let Font_SanFranciscoText_Medium_H30 =  UIFont(name: SanFranciscoText_Medium, size: 30.0 + FONT_INCREMENT)





let Font_Titillium_Regular_H06 =  UIFont(name: Titillium_Regular, size: 6.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H07 =  UIFont(name: Titillium_Regular, size: 7.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H08 =  UIFont(name: Titillium_Regular, size: 8.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H09 =  UIFont(name: Titillium_Regular, size: 9.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H10 =  UIFont(name: Titillium_Regular, size: 10.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H11 =  UIFont(name: Titillium_Regular, size: 11.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H12 =  UIFont(name: Titillium_Regular, size: 12.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H13 =  UIFont(name: Titillium_Regular, size: 13.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H14 =  UIFont(name: Titillium_Regular, size: 14.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H15 =  UIFont(name: Titillium_Regular, size: 15.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H16 =  UIFont(name: Titillium_Regular, size: 16.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H17 =  UIFont(name: Titillium_Regular, size: 17.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H18 =  UIFont(name: Titillium_Regular, size: 18.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H19 =  UIFont(name: Titillium_Regular, size: 19.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H20 =  UIFont(name: Titillium_Regular, size: 20.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H21 =  UIFont(name: Titillium_Regular, size: 21.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H22 =  UIFont(name: Titillium_Regular, size: 22.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H23 =  UIFont(name: Titillium_Regular, size: 23.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H24 =  UIFont(name: Titillium_Regular, size: 24.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H25 =  UIFont(name: Titillium_Regular, size: 25.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H26 =  UIFont(name: Titillium_Regular, size: 26.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H27 =  UIFont(name: Titillium_Regular, size: 27.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H28 =  UIFont(name: Titillium_Regular, size: 28.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H29 =  UIFont(name: Titillium_Regular, size: 29.0 + FONT_INCREMENT)
let Font_Titillium_Regular_H30 =  UIFont(name: Titillium_Regular, size: 30.0 + FONT_INCREMENT)


let Font_Titillium_Semibold_H06 =  UIFont(name: Titillium_Semibold, size: 6.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H07 =  UIFont(name: Titillium_Semibold, size: 7.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H08 =  UIFont(name: Titillium_Semibold, size: 8.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H09 =  UIFont(name: Titillium_Semibold, size: 9.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H10 =  UIFont(name: Titillium_Semibold, size: 10.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H11 =  UIFont(name: Titillium_Semibold, size: 11.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H12 =  UIFont(name: Titillium_Semibold, size: 12.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H13 =  UIFont(name: Titillium_Semibold, size: 13.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H14 =  UIFont(name: Titillium_Semibold, size: 14.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H15 =  UIFont(name: Titillium_Semibold, size: 15.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H16 =  UIFont(name: Titillium_Semibold, size: 16.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H17 =  UIFont(name: Titillium_Semibold, size: 17.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H18 =  UIFont(name: Titillium_Semibold, size: 18.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H19 =  UIFont(name: Titillium_Semibold, size: 19.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H20 =  UIFont(name: Titillium_Semibold, size: 20.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H21 =  UIFont(name: Titillium_Semibold, size: 21.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H22 =  UIFont(name: Titillium_Semibold, size: 22.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H23 =  UIFont(name: Titillium_Semibold, size: 23.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H24 =  UIFont(name: Titillium_Semibold, size: 24.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H25 =  UIFont(name: Titillium_Semibold, size: 25.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H26 =  UIFont(name: Titillium_Semibold, size: 26.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H27 =  UIFont(name: Titillium_Semibold, size: 27.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H28 =  UIFont(name: Titillium_Semibold, size: 28.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H29 =  UIFont(name: Titillium_Semibold, size: 29.0 + FONT_INCREMENT)
let Font_Titillium_Semibold_H30 =  UIFont(name: Titillium_Semibold, size: 30.0 + FONT_INCREMENT)


//UICOLOR FOR SKORMAN
let UICOLOR_WHITE = UIColor.white
let UICOLOR_CONTAINER_BG = UIColor(netHex: 0x2C2E3F)
let UICOLOR_MAIN_BG = UIColor(netHex: 0x1A1C2A)
let UICOLOR_SEPRATOR = UIColor(netHex: 0x3B3E4F)
let UICOLOR_RED = UIColor(netHex: 0xC34E4E)
let UICOLOR_BLUE = UIColor(netHex: 0x4060FA)
let UICOLOR_NAVIGATION_BAR = UIColor(netHex: 0x2C2E3F)
let UICOLOR_TEXTFIELD_CONTAINER_BORDER = UIColor(netHex: 0x383A4B)
let UICOLOR_TEXTFIELD_CONTAINER_BG = UIColor(netHex: 0x2D3042)
let UICOLOR_SELECTEDORON_BG = UIColor(netHex: 0xFFD166)
let UICOLOR_SWIPECELL_EDIT = UIColor(netHex: 0x06D6A0)
let UICOLOR_SWIPECELL_DELETE = UIColor(netHex: 0xF15151)
let UICOLOR_ODD_CELL_BG = UIColor(netHex: 0x383A4D)
let UICOLOR_CAPSMENU_SELECTED_LINE = UIColor(netHex: 0x4060FA)
let UICOLOR_ADD_MOOD_BG = UIColor(netHex: 0x616375)
let UICOLOR_ADDED_MOOD_CLR = UIColor(netHex: 0x2DCCED)
let UICOLOR_ROOM_CELL_BG = UIColor(netHex: 0x0B0C13)
let UICOLOR_ROOM_CELL_SEPRATOR = UIColor(netHex: 0x36394C)
let UICOLOR_TXTFIELD_BORDER_COLOR = UIColor(netHex: 0x898A93)
let UICOLOR_SWITCH_BORDER_COLOR_UNSELECTED = UIColor(netHex: 0x383B51)
let UICOLOR_SWITCH_BORDER_COLOR_BLUE = UIColor(netHex: 0x06B2D6)
let UICOLOR_SWITCH_BORDER_COLOR_YELLOW = UIColor(netHex: 0xFFD166)
let UICOLOR_MOODS_BUTTON_BG = UIColor(netHex: 0xA554FE)
let UICOLOR_POPUP_BORDER = UIColor(netHex: 0x8B9298)
let UICOLOR_CHANGE_PW_TEXT = UIColor(netHex: 0xE4BC5E)
let UICOLOR_DEVICE_MOOD_TABLE_BORDER = UIColor(netHex: 0xB5BBC3)
let UICOLOR_PINK = UIColor(netHex: 0xFF4081)
let UICOLOR_IPAD_HOME_BG = UIColor(netHex : 0x1A1C2A)
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

