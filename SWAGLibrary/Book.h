//
//  Book.h
//  SWAGLibrary
//
//  Created by Joyce Matos on 5/4/17.
//  Copyright © 2017 Joyce Matos. All rights reserved.
//

#ifndef Book_h
#define Book_h
#import <Foundation/Foundation.h>

#endif /* Book_h */

@interface Book: NSObject

// NOTE: - Check to see if you need nonatomic, copy, rewrite for your properties
@property (nonatomic, copy, readwrite) NSString *author;
@property (nonatomic, copy, readwrite) NSString *categories;
@property (nonatomic, copy, readwrite) NSNumber *id;
@property (nonatomic, copy, readwrite) NSString *publisher;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *url;
@property (nonatomic, copy, readwrite) NSMutableString *lastCheckedOut;
@property (nonatomic, copy, readwrite) NSMutableString *lastCheckedOutBy;

-(id)initWithDictionary: (NSDictionary *)JSON;


@end

