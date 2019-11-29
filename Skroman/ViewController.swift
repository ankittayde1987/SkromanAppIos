




import UIKit

class ViewController: UIViewController {

    var responseJson : NSMutableDictionary = [:]
    var dictonaryIds : NSMutableDictionary = [:]


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickInstagram(_ sender: Any) {
        
      
    }
    
    @IBAction func clickDropbox(_ sender: Any)
    {
        
    }
    
    @IBAction func clickTwitter(_ sender: Any)
    {
        
    }
    
    @IBAction func clickGoogle(_ sender: Any)
    {
        
    }
    
    @IBAction func clickLinkedIn(_ sender: Any)
    {
        let cnt = LinkedInLoginVC(nibName: "LinkedInLoginVC" , bundle : nil)
        self.navigationController?.pushViewController(cnt, animated: true)
    }
    

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
