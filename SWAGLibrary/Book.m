//
//  Book.m
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@implementation Book: NSObject

-(id)initWithDictionary: (NSDictionary *)JSON {
    self = [super init];
    if (self) {
        // Set values and initialize here?
        _author = JSON[@"author"];
        _categories = JSON[@"categories"];
        _id = JSON[@"id"];
        _publisher = JSON[@"publisher"];
        _title = JSON[@"title"];
        _url = JSON[@"url"];
        _lastCheckedOut= JSON[@"lastCheckedOut"];
        _lastCheckedOutBy= JSON[@"lastCheckedOutBy"];
        
        }
    
    return self;
    
}

@end
