//
//  User.swift
//  Skroman
//
//  Created by ananadmahajan on 10/30/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import GoogleSignIn

class User: Codable {
	
//	name
//	email
//	mobile_number
//	password
//	confirm_password
	var name: String?
	var email: String?
	var phoneNumber: String?
	var password: String?
	var confirm_password: String?
	var user_id: String?
	
	var old_password: String?
	var image: String?
	var googleId: String?
	var social_type: String?
    var piids : [String]?

        //Added For link_user_and_pi API
    var ip: String?
    var pi_id: String?
    var message: String?
    var success: Int?
    
	
	private enum CodingKeys: String, CodingKey {
		case user_id = "_id"
		case name
		case email
		case phoneNumber
		case password
		case confirm_password
		case old_password
		case image
		case googleId
		case social_type
        case piids
        case pi_id
        case ip
        case message
        case success
	}
	
	class func initWithGoogle(user : GIDGoogleUser) -> User?
	{
		let objUser = User();
		objUser.social_type = SOCIAL_TYPE_GOOGLE
		objUser.googleId = user.userID// For client-side use only!
		objUser.name = user.profile.name
		objUser.email = user.profile.email
		
		if(user.profile.hasImage)
		{
			let dimension = round(116 * UIScreen.main.scale);
			objUser.image = "\(user.profile.imageURL(withDimension: UInt(dimension))!)"
		}
		
		/*let givenName = user.profile.givenName
		let familyName = user.profile.familyName
		let idToken = user.authentication.idToken // Safe to send to the server*/
		
		return objUser
	}
	
	
	class func logOutCurrentUser() {
		let userDefaults = UserDefaults.standard
		userDefaults.removeObject(forKey: "user")
		userDefaults.synchronize()
	}
    
    class func dummyRegisterUser() -> User
    {
        let obj = User()
        obj.email = "gaurav78@test.com"
        obj.name = "Gaurav"
        obj.phoneNumber = "9890263390"
        obj.password = "123456"
        obj.confirm_password = "123456"
        return obj
    }
}
