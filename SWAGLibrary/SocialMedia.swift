//
//  SocialMedia.swift
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/7/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

import Foundation
import Social


protocol ShareDetails {
    
    var type: String { get }
    var typeName: String { get }
    
}

enum SocialMedia {
    
    case twitter
    case fb
    
}

extension SocialMedia: ShareDetails {
    
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
