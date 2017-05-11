//
//  SocialMedia.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/7/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation
import Social

// NOTE: - This retrieves the type of service and platform for any designated account, ie: Facebook, Twitter

protocol GetPlatformDetails {
    
    var type: String { get }
    var typeName: String { get }
    
}

// NOTE: - These are the types of platforms available for sharing capabilities

enum SocialMedia {
    
    case twitter
    case fb
    
}

// NOTE: - This retrieves the type of service and name of each platorm

extension SocialMedia: GetPlatformDetails {
    
    var type: String {
        switch self {
        case .twitter:
            return SLServiceTypeTwitter
        case .fb:
            return SLServiceTypeFacebook
        }
    }
    
    var typeName: String {
        switch self {
        case .twitter:
            return "Twitter"
        case .fb:
            return "Facebook"
        }
    }
    
}
