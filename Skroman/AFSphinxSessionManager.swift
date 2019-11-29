//
//  AFSphinxSessionManager.swift
//  AlamofireBase
//
//  Created by anand mahajan on 09/07/17.
//  Copyright © 2017 Sphinx Solution Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire


open class AFSphinxSessionManager
{
//    static let clinet_id = "shopave"
//    static let secret_id = "SpH!nX"
//    static let scope = "read+write"
//
//    let  oauth2 =  OAuth2PasswordGrant(settings: [
//        "client_id": clinet_id ,
//        "client_secret": secret_id,
//        "scope": scope,
//        "authorize_uri": BASE_HTTP_URL + "/users/access-token",
//        "keychain": true,
//        ])
//
//
//   static func defaultSessionManager() -> SessionManager
//    {
//        let retrier = OAuth2RetryHandler(oauth2: AFSphinxSessionManager().oauth2)
//
//        let tempSession = Alamofire.SessionManager.default;
//        tempSession.session.configuration.urlCache = nil
//        tempSession.adapter = retrier
//       // tempSession.retrier = retrier
//
//        return tempSession;
//    }
//
//    func authorizeUser(username : String , password : String ,
//                              success: @escaping (OAuth2JSON?) -> Void,
//                              failure: @escaping (OAuth2Error?)-> Void)
//   {
//
//    oauth2.username = username
//    oauth2.password = password
//
//    var param =  [String:String]()
//    param.updateValue(username, forKey: "username")
//    param.updateValue(password, forKey: "password")
//
//    try! oauth2.doAuthorize(params: param)
//    oauth2.afterAuthorizeOrFail  = { authParameters, error in
//             // inspect error or oauth2.accessToken / authParameters or do something else
//            NSLog("access token \(authParameters)")
//            if((error) != nil) {
//                return failure(error)
//            }
//            return  success(authParameters);
//        }
//    }
//
//    static func clearAccessToken() {
//        AFSphinxSessionManager().oauth2.forgetTokens()
//    }
//
//    static func setAccessToken(data: Data)
//    {
//        let temOauth2 = AFSphinxSessionManager().oauth2;
//        let dict = try! temOauth2.parseAccessTokenResponse(data:data)
//
//        if temOauth2.useKeychain {
//            temOauth2.storeTokensToKeychain()
//        }
//    }
//    static func setAccessTokenDict(dict: OAuth2JSON)
//    {
//
//
//        let temOauth2 = AFSphinxSessionManager().oauth2;
//        let dict = try! temOauth2.parseAccessTokenResponse(params:dict)
//        if temOauth2.useKeychain {
//            temOauth2.storeTokensToKeychain()
//        }
//    }
//
	
	static func defaultSessionManager() -> SessionManager {
		let tempSession = Alamofire.SessionManager.default;
		return tempSession;
	}
}



