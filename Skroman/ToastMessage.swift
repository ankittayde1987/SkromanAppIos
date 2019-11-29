
import UIKit
import TWMessageBarManager

private var duration: CGFloat = 2.0

class ToastMessage: NSObject {
    
    class func showMessage(withTitle title: String, message: String, type: TWMessageBarMessageType) {
        TWMessageBarManager.sharedInstance()
        TWMessageBarManager.sharedInstance().showMessage(withTitle: title, description: message, type: type, duration: duration)
    }
    
    class func showSuccessMessage(_ message: String) {
        ToastMessage.showMessage(withTitle: message, message: "", type: TWMessageBarMessageType.success)
    }
    
    class func showInfoMessage(_ message: String) {
        ToastMessage.showMessage(withTitle: message, message: "", type: TWMessageBarMessageType.info)
    }
    
    
    class func showErrorMessageOppsTitle(withMessage message: String) {
        ToastMessage.showMessage(withTitle: SSLocalizedString(key: "oops"), message: message, type: TWMessageBarMessageType.error)
    }
    
    class func showErrorMessageAppTitle(withMessage message: String) {
        //let messag = "sdfjksdjf sdjfkldsj fkljsdf sdjfklsdjf sdfkjdskljfsl dfjkdsjfkd fsdjfkljdslf";
        ToastMessage.showMessage(withTitle: message, message: "", type: TWMessageBarMessageType.error)
    }
}
