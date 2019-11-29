
import UIKit

class NoInternetView: UIView {
    @IBOutlet var btnRetry: UIButton?
     @IBOutlet var lblMessage: UILabel?
    
    override func awakeFromNib() {
//        self.lblMessage?.font = FONT_MONT_LIGHT_H14; Gaurav
        self.lblMessage?.textColor = UICOLOR_WHITE;
//        self.btnRetry?.titleLabel?.font = FONT_MONT_REGULAR_H14; Gaurav
    }
    
    func showConnectivityMessage(_ error: String?) {
        if(error == nil)
        {
            self.lblMessage?.text = SSLocalizedString(key: "no_internet_connection")
        }
        else
        {
            self.lblMessage?.text = error;

        }
        self.layoutIfNeeded()
    }
    
    func drawSubviewsWithType() {
       
       // backgroundColor = UICOLOR_GLOBAL_BG
    }

 }
