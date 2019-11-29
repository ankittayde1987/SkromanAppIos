
let kAppDelegateDemoStyleSheetImageIconError: String = "icon-error.png"
let kAppDelegateDemoStyleSheetImageIconSuccess: String = "icon-success.png"
let kAppDelegateDemoStyleSheetImageIconInfo: String = "icon-info.png"

import UIKit
import TWMessageBarManager
class TWMessageBarManagerStyleSheet: NSObject , TWMessageBarStyleSheet
{
    // MARK: - Alloc/Init
    class func styleSheet() -> TWMessageBarManagerStyleSheet {
        return TWMessageBarManagerStyleSheet()
    }
    
    // MARK: - TWMessageBarStyleSheet
    func backgroundColor(for type: TWMessageBarMessageType) -> UIColor {
        var backgroundColor: UIColor? = nil
        switch type {
        case .error:
            backgroundColor = UICOLOR_BLUE
        case .success:
            backgroundColor = UICOLOR_BLUE
        case .info:
            backgroundColor = UICOLOR_BLUE
        default:
            break
        }
        
        return backgroundColor!
    }
    
    func strokeColor(for type: TWMessageBarMessageType) -> UIColor {
        let strokeColor = UIColor.clear
        /*   switch (type)
         {
         case TWMessageBarMessageTypeError:
         strokeColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
         break;
         case TWMessageBarMessageTypeSuccess:
         strokeColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
         break;
         case TWMessageBarMessageTypeInfo:
         strokeColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0];
         break;
         default:
         break;
         }*/
        return strokeColor
    }
    
    
    func iconImage(for type: TWMessageBarMessageType) -> UIImage {
        var iconImage: UIImage? = nil
        switch type {
        case .error:
            iconImage = UIImage(named: kAppDelegateDemoStyleSheetImageIconError)
        case .success:
            iconImage = UIImage(named: kAppDelegateDemoStyleSheetImageIconSuccess)
        case .info:
            iconImage = UIImage(named: kAppDelegateDemoStyleSheetImageIconInfo)
        default:
            break
        }
        
        return iconImage!
    }
    
   /* func titleFont(for type: TWMessageBarMessageType) -> UIFont {
        return FONT_MONT_REGULAR_H12!
    }
    
    func descriptionFont(for type: TWMessageBarMessageType) -> UIFont {
        return FONT_AVENIR_PRO_REGULAR_H6
    }
    
    func titleColor(for type: TWMessageBarMessageType) -> UIColor {
        return UIColor.white
    }
    
    func descriptionColor(for type: TWMessageBarMessageType) -> UIColor {
        return UIColor.white
    }*/

}
