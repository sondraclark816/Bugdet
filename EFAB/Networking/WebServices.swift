//
//  WebServices.swift
//  EFAB
//
//  Created by David  Bowen on 10/31/16.
//  Copyright © 2016 David  Bowen. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

class WebServices: NSObject {
    
    //Singleton
    static let shared = WebServices()
    
    //prevent object creation
    private override init() { }
    
    //baseURL private and public vars
    fileprivate var _baseURL = ""
    var baseURL: String {
        get {
            return _baseURL
        }
        
        set {
            _baseURL = newValue
        }
    }
    
    //Store auth token
    private var authToken: String?
    
    func setAuthToken(_ token: String?) {
        authToken = token
    }
    
    // AuthRouter - all network calls go through this
    enum AuthRouter: URLRequestConvertible {
        static var baseURLString = WebServices.shared._baseURL
        static var OAuthToken: String?
        
        // Because AuthRouter is an enum, it needs to have a case to instantiate it
        case restRequest(NetworkModel)
        
        func asURLRequest() throws -> URLRequest {
            let URL = try AuthRouter.baseURLString.asURL()
            var urlRequest: URLRequest
            
            switch self {
            case .restRequest(let model):
                // Create the url request with the base url and add on the path component passed in via the NetworkModel
                urlRequest = URLRequest(url: URL.appendingPathComponent(model.path()))
                
                // Set the method to the method passed in via the NetworkModel
                urlRequest.httpMethod = model.method().rawValue
                
                // Check for an auth token and if it exists, add it to the request
                if let token = WebServices.shared.authToken {
                    urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                }
                
                // Check for parameters and eithe radd them to the URL or the body depending on the Method
                if let params = model.toDictionary() {
                    if model.method() == .get {
                        return try! URLEncoding.default.encode(urlRequest, with: params)
                    } else {
                        return try! JSONEncoding.default.encode(urlRequest, with: params)
                    }
                }
                
                return urlRequest
            }
        }
    }
    
    
    
    
}
