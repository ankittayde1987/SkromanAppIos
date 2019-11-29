
import UIKit

class SimpleJson: NSObject {
    func jsonRepresentation() -> String? {
        if !JSONSerialization.isValidJSONObject(self) {
            return nil
        }
        //write ourself to a JSON string; only works if we're a type that 'NSJSONSerialization' supports
        let error: Error? = nil
        let tempData: Data? = try? JSONSerialization.data(withJSONObject: self, options: [])
        if error != nil {
            return nil
        }
        // print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) ?? "")
        return String(data: tempData!, encoding: String.Encoding.utf8)
    }
    
    /*func jsonValue() -> Any {
        //converts from a string back into a proper object; only works if we're an NSString or NSData instance
        if !(self is String) && !(self is Data) {
            return nil
        }
        var jsonData: Data? = nil
        if (self is Data) {
            jsonData = (self as? Data)
        }
        else {
            //we must be an NSString
            jsonData = (self as? String)?.data(using: String.Encoding.utf8)
        }
        return try? JSONSerialization.jsonObject(withData: jsonData, options: kNilOptions)!
    }*/
}


