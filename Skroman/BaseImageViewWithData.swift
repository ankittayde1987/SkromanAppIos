
import UIKit
import Masonry
import SDWebImage

class BaseImageViewWithData: UIImageView {
    var placeholder: UIImage?
    var comefrom = ImageViewComfrom.user
    var activity: UIActivityIndicatorView?
    
    func getImageWithURL(_ stringURL: String?, comefrom: ImageViewComfrom) {
        if activity == nil {
            activity = UIActivityIndicatorView()
            activity?.activityIndicatorViewStyle = .white
            addSubview(activity!)
            
            _ = activity?.mas_makeConstraints { (make:MASConstraintMaker?) in
                _ = make?.centerX.equalTo()(self.mas_centerX)
                _ = make?.centerY.equalTo()(self.mas_centerY)
            }
         
        }
        self.comefrom = comefrom
        setPlaceHolder()
        loadImage1(withURL: stringURL)
    }
    
    func loadImage1(withURL stringURL: String?) {
        if stringURL == "" || stringURL == nil {
            image = placeholder
            return
        }
        var url: URL?
        url = URL(string: stringURL!)
        activity?.startAnimating()
        weak var weakSelf: BaseImageViewWithData? = self
        sd_setImage(with: url, placeholderImage: placeholder, options: []) { (_ image, _ error, _ cacheType, _ originalImageURL) in
            self.activity?.stopAnimating()
            if (image != nil) {
                UIView.transition(with: weakSelf!, duration: 0.2, options: .transitionCrossDissolve, animations: {() -> Void in
                    weakSelf?.image = image
                }, completion: { _ in })
            }
            
        }
    }
    
    func setPlaceHolder() {
        clipsToBounds = true
        if comefrom == ImageViewComfrom.user {
            placeholder = UIImage(named: "profile_pic")
            contentMode = .scaleAspectFill
        }
        if comefrom == ImageViewComfrom.product {
            placeholder = UIImage(named: "profile_pic")
            contentMode = .scaleAspectFill
        }
        if comefrom == ImageViewComfrom.Community {
            placeholder = UIImage(named: "profile_pic")
            contentMode = .scaleAspectFill
        }
        if comefrom == ImageViewComfrom.story {
            placeholder = UIImage(named: "profile_pic")
            contentMode = .scaleAspectFill
        }
    }
    
}
