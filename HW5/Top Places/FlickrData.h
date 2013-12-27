//
//  FlickrData.h
//  Top Places
//
//  Created by Peter Brooks on 12/20/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrData : NSObject

+ (NSString *)countryFromPhoto:(NSDictionary *)photo;
+ (NSString *)locationFromPhoto:(NSDictionary *)photo;
+ (NSString *)placeIDFromPhoto:(NSDictionary *)photo;
+ (NSString *)placeNameFromPhoto:(NSDictionary *)photo;
+ (NSString *)minorLocationsFromPhoto:(NSDictionary *)photo;
+ (NSString *)descriptionFromPhoto:(NSDictionary *)photo;
+ (NSString *)titleFromPhoto:(NSDictionary *)photo;

+ (NSURL *)topPlacesURL;
+ (NSURL *)placeURL:(NSString *)place;
+ (NSURL *)photoURL:(NSDictionary *)photo;

+ (NSString *)resultsPhotosKey;
+ (NSString *)resultsPlacesKey;
+ (NSString *)photoIDKey;


@end
