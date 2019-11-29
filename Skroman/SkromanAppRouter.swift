//
//  MakeAppRouter.swift
//  MakeApp
//
//  Created by ananadmahajan on 7/13/17.
//  Copyright © 2017 ananadmahajan. All rights reserved.
//

import UIKit
import Alamofire

enum SkromanAppRouter: URLRequestConvertible
{
     var baseComponent: String
    {
        return ""   //X--- "makeapp/v1"
    }
	
	
	case loginUser(parameters : Parameters) //1
	case forgotPassword(parameters: Parameters) //2
	case registerNewUser(parameters: Parameters) //3
	case getUserDetails(parameters : Parameters) //4
	case changePassword(parameters: Parameters) //5
	case updateUser(parameters: Parameters) //6
	case socialLogin(parameters: Parameters) //7
    
    var method: HTTPMethod
    {
        switch self
        {
		case .loginUser,
			 .forgotPassword,
			 .registerNewUser,
			 .changePassword,
			 .updateUser,
			 .socialLogin:
			return .post
			
		case .getUserDetails :
			return .get
        }
    }
    
    var path: String
    {
        switch self
        {
		case .loginUser :
			return "/\(baseComponent)login"
		
		case .forgotPassword :
			return "/\(baseComponent)forgotpassword"
		
		case .registerNewUser :
			return "/\(baseComponent)signup"
			
		case .getUserDetails :
			return  "/\(baseComponent)user-details"
			
		case .changePassword :
			return "/\(baseComponent)change-password"
			
		case .updateUser :
			return "/\(baseComponent)update-user-details"
			
		case .socialLogin :
			return "/\(baseComponent)social-login"
        }
    }
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = URL.init(fileURLWithPath: BASE_HTTP_URL)
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        
        switch self
        {
		
		case .loginUser(parameters: let parameters) ,
			 .forgotPassword(parameters: let parameters),
			 .registerNewUser(parameters: let parameters),
			 .changePassword(parameters: let parameters),
			 .updateUser(parameters: let parameters),
			 .socialLogin(parameters: let parameters):
			urlRequest.setValue(self.getContentType(type: "JSON"), forHTTPHeaderField: "Content-Type");
			urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
			break
			
		case .getUserDetails(parameters: let parameters) :
			urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
			break
        default:
            break
        }
        
        return urlRequest
    }
    
    
    
    func getContentType(type : String) -> String
    {
        if(type=="JSON")
        {
            return "application/json";
        }
        else
        {
            return "application/x-www-form-urlencoded; charset=utf-8";
        }
    }
}

