//
//  NetworkModel.swift
//  EFAB
//
//  Created by David  Bowen on 10/31/16.
//  Copyright © 2016 David  Bowen. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

protocol NetworkModel: JSONDecodable {
    init(json: JSON) throws
    init()
    
    func method () -> Alamofire.HTTPMethod
    func path() -> String
    func toDictionary() -> [String: AnyObject]?
    }

