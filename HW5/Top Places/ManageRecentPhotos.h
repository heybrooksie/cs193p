//
//  ManageRecentPhotos.h
//  Top Places
//
//  Created by Peter Brooks on 12/18/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManageRecentPhotos : NSObject

+ (NSArray *)getPhotos;
+ (void)savePhoto:(NSDictionary *)photo;

@end
