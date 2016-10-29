//
//  User.swift
//  Twitter
//
//  Created by Mike Tehranian on 10/28/16.
//  Copyright © 2016 Mike Tehranian. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    
    init(dictionary: NSDictionary) {
//        print("name: \()")
//        print("screenname: \(user["screen_name"])")
//        print("profile url: \(user["profile_image_url_https"])")
//        print("description: \(user["description"])")

        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)!
        }
        
        tagline = dictionary["description"] as? String
        
    }
    
}
