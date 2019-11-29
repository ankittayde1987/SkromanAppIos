//
//  MakeAppAPI.swift
//  MakeApp
//
//  Created by ananadmahajan on 7/13/17.
//  Copyright © 2017 ananadmahajan. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire

open class SkromanAppAPI {
	private var timestamp: String {
		return "\(Date.timeIntervalSinceReferenceDate)"
	}
	
	fileprivate func generateMD5Key(components: [String]) -> String {
		var fullStr: String = ""
		for str: String in components {
			fullStr = fullStr + str
		}
		
		return fullStr.MD5()
	}
	
	private let errorUnexpectedResponse: NSError = {
		let error: SSError = SSError.init(message: SSLocalizedString(key: "unexpected_response"), code: "", from: "", errorType: SSErrorType.UnexpectedResponse)
		var dicUesrInfo = [String : Any]()
		dicUesrInfo[kSSErrorObjectKey] = error;
		return NSError(domain: "", code: 0, userInfo: dicUesrInfo)
	}()
	
	func cancelAllRequests() {
		let sessionManager = AFSphinxSessionManager.defaultSessionManager()
		sessionManager.session.invalidateAndCancel()
	}
	

	
	//MARK: - LoginUser
	func loginUserAPICall(body : User ,success:@escaping(_ user : UserWrapper)->Void,
				   failure:@escaping (Error?)->Void)
	{
		let session = AFSphinxSessionManager.defaultSessionManager()
		
		let parameters = NSMutableDictionary()
		parameters.setValue(body.email, forKey: "email")
		parameters.setValue(body.password, forKey: "password")
		
		session.request(SkromanAppRouter.loginUser(parameters: parameters as! Parameters) as URLRequestConvertible).validate().responseJSON(completionHandler:  { data in
			
			print("data.result  --\(data.result)")
			if(SSError.isErrorReponse(operation: data.response)){
				failure(SSError.errorWithData(data:data))
			}
			else {
				let dictResponse : NSDictionary? = data.result.value as? NSDictionary
				let status : String? = dictResponse?["status"] as? String
				
				if(status  == "error")
				{
					SSLog(message: "ERROR BLOCKKKK")
				}
				else
				{
					guard let data = data.data else {
						return
					}
						if let objParsed : UserWrapper? = UserWrapper.decode(data){
							success(objParsed!)
						}
				}
			}
		})
	}
	
	
	
	
	//MARK: - ForgotPasswordAPICall
	func forgotPasswordAPICall(email: String ,success:@escaping(_ response : String)->Void,
						  failure:@escaping (Error?)->Void)
	{
		let session = AFSphinxSessionManager.defaultSessionManager()
		
		let parameters = NSMutableDictionary()
		parameters.setValue(email, forKey: "email")
		
		session.request(SkromanAppRouter.forgotPassword(parameters: parameters as! Parameters) as URLRequestConvertible).validate().responseJSON(completionHandler:  { data in
			
			print("data.result  --\(data.result)")
			if(SSError.isErrorReponse(operation: data.response)){
				failure(SSError.errorWithData(data:data))
			}
			else {
				let dictResponse : NSDictionary? = data.result.value as? NSDictionary
				let status : String? = dictResponse?["status"] as? String
				
				if(status  == "error")
				{
					SSLog(message: "ERROR BLOCKKKK")
				}
				else
				{
					let message: String? = dictResponse!["message"] as? String
					success(message!)
				}
			}
		})
	}
	
	
	
	
	//MARK: - RegisterUser
	func registerNewUser(body : User ,success:@escaping(_ user : UserWrapper)->Void,
						  failure:@escaping (Error?)->Void)
	{
		let session = AFSphinxSessionManager.defaultSessionManager()
		
		let parameters = NSMutableDictionary()
		parameters.setValue(body.name, forKey: "name")
		parameters.setValue(body.email, forKey: "email")
		if !Utility.isEmpty(val: body.password)
		{
			parameters.setValue(body.password, forKey: "password")
		}
		
		parameters.setValue(body.phoneNumber, forKey: "phoneNumber")
		
		if !Utility.isEmpty(val: body.googleId)
		{
			parameters.setValue(body.googleId, forKey: "googleId")
		}
		
		
		
		session.request(SkromanAppRouter.registerNewUser(parameters: parameters as! Parameters) as URLRequestConvertible).validate().responseJSON(completionHandler:  { data in
			
			print("data.result  --\(data.result)")
			if(SSError.isErrorReponse(operation: data.response)){
				failure(SSError.errorWithData(data:data))
			}
			else {
				let dictResponse : NSDictionary? = data.result.value as? NSDictionary
				let status : String? = dictResponse?["status"] as? String
				
				if(status  == "error")
				{
					SSLog(message: "ERROR BLOCKKKK")
				}
				else
				{
					guard let data = data.data else { return }
					if let objParsed : UserWrapper? = UserWrapper.decode(data){
						success(objParsed!)
					}
				}
			}
		})
	}
	
	
	
	//MARK: - GetUserDetails
	func getUserDetails(success:@escaping(_ user : UserWrapper)->Void,
						 failure:@escaping (Error?)->Void)
	{
		let session = AFSphinxSessionManager.defaultSessionManager()
		
		let parameters = NSMutableDictionary()
		parameters.setValue(Utility.getCurrentUserId(), forKey: "_id")
		
		session.request(SkromanAppRouter.getUserDetails(parameters: parameters as! Parameters) as URLRequestConvertible).validate().responseJSON(completionHandler:  { data in
			
			print("data.result  --\(data.result)")
			if(SSError.isErrorReponse(operation: data.response)){
				failure(SSError.errorWithData(data:data))
			}
			else {
				let dictResponse : NSDictionary? = data.result.value as? NSDictionary
				let status : String? = dictResponse?["status"] as? String
				
				if(status  == "error")
				{
					SSLog(message: "ERROR BLOCKKKK")
				}
				else
				{
					guard let data = data.data else { return }
					if let objParsed : UserWrapper? = UserWrapper.decode(data){
						success(objParsed!)
					}
				}
			}
		})
	}
	
	
	
	
	//MARK: - ChangePassword
	func changePasswordOfUser(body : User ,success:@escaping(_ user : UserWrapper)->Void,
						 failure:@escaping (Error?)->Void)
	{
		let session = AFSphinxSessionManager.defaultSessionManager()
		
		let parameters = NSMutableDictionary()
		parameters.setValue(Utility.getCurrentUserId(), forKey: "_id")
		parameters.setValue(body.old_password, forKey: "password")
		parameters.setValue(body.password, forKey: "newpassword")
		
		session.request(SkromanAppRouter.changePassword(parameters: parameters as! Parameters) as URLRequestConvertible).validate().responseJSON(completionHandler:  { data in
			
			print("data.result  --\(data.result)")
			if(SSError.isErrorReponse(operation: data.response)){
				failure(SSError.errorWithData(data:data))
			}
			else {
				let dictResponse : NSDictionary? = data.result.value as? NSDictionary
				let status : String? = dictResponse?["status"] as? String
				
				if(status  == "error")
				{
					SSLog(message: "ERROR BLOCKKKK")
				}
				else
				{
					guard let data = data.data else { return }
					if let objParsed : UserWrapper? = UserWrapper.decode(data){
						success(objParsed!)
					}
				}
			}
		})
	}
	
	
	//MARK: - updateUserAPI
	func updateUserAPI(body : User ,success:@escaping(_ user : UserWrapper)->Void,
						 failure:@escaping (Error?)->Void)
	{
		let session = AFSphinxSessionManager.defaultSessionManager()
		
		let parameters = NSMutableDictionary()
		parameters.setValue(Utility.getCurrentUserId(), forKey: "_id")
		parameters.setValue(body.email, forKey: "email")
		parameters.setValue(body.name, forKey: "name")
		parameters.setValue(body.phoneNumber, forKey: "phoneNumber")
		
		session.request(SkromanAppRouter.updateUser(parameters: parameters as! Parameters) as URLRequestConvertible).validate().responseJSON(completionHandler:  { data in
			
			print("data.result  --\(data.result)")
			if(SSError.isErrorReponse(operation: data.response)){
				failure(SSError.errorWithData(data:data))
			}
			else {
				let dictResponse : NSDictionary? = data.result.value as? NSDictionary
				let status : String? = dictResponse?["status"] as? String
				
				if(status  == "error")
				{
					SSLog(message: "ERROR BLOCKKKK")
				}
				else
				{
					guard let data = data.data else { return }
					if let objParsed : UserWrapper? = UserWrapper.decode(data){
						success(objParsed!)
					}
				}
			}
		})
	}
	
	//MARK: - socialLoginAPI
	func socialLoginAPI(body : User ,success:@escaping(_ user : UserWrapper)->Void,
					   failure:@escaping (Error?)->Void)
	{
		let session = AFSphinxSessionManager.defaultSessionManager()
		
		let parameters = NSMutableDictionary()
		parameters.setValue(body.email, forKey: "email")
		parameters.setValue(body.googleId, forKey: "googleId")
		
		session.request(SkromanAppRouter.socialLogin(parameters: parameters as! Parameters) as URLRequestConvertible).validate().responseJSON(completionHandler:  { data in
			
			print("data.result  --\(data.result)")
			if(SSError.isErrorReponse(operation: data.response)){
				failure(SSError.errorWithData(data:data))
			}
			else {
				let dictResponse : NSDictionary? = data.result.value as? NSDictionary
				let status : String? = dictResponse?["status"] as? String
				
				if(status  == "error")
				{
					SSLog(message: "ERROR BLOCKKKK")
				}
				else
				{
					guard let data = data.data else { return }
					if let objParsed : UserWrapper? = UserWrapper.decode(data){
						success(objParsed!)
					}
				}
			}
		})
	}
}
