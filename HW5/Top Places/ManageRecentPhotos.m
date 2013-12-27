//
//  manageRecentPhotos.m
//  Top Places
//
//  Created by Peter Brooks on 12/18/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "ManageRecentPhotos.h"
#import "FlickrData.h"
#import "CONSTANTS.h"

@implementation ManageRecentPhotos

+ (NSArray *)getPhotos {
    NSMutableArray *photosMut = [[NSMutableArray alloc] init];
    NSDictionary *dictToBeSorted = [[NSUserDefaults standardUserDefaults] dictionaryForKey:RECENT_IMAGES_KEY];
    NSArray *sortedKeys = [[dictToBeSorted allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    NSArray *objects = [dictToBeSorted objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
    for (id plist in objects) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *imageDictionary = (NSDictionary *)plist;
            NSDictionary *recentPhoto = imageDictionary[IMAGE_DATA];
            [photosMut addObject:recentPhoto];
        }
    }
    return [[NSArray alloc] initWithArray:photosMut];
}

#define MAXSAVEDPHOTOS 50
+ (void)savePhoto:(NSDictionary *)photo {
    NSMutableDictionary *mutableImageHistoryFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:RECENT_IMAGES_KEY] mutableCopy];
    if (!mutableImageHistoryFromUserDefaults) { mutableImageHistoryFromUserDefaults = [[NSMutableDictionary alloc] init];}
    // if photo already exists do not add again
    NSString *newPhotoID = photo[[FlickrData photoIDKey]];
    BOOL match = NO;
    for (id plist in mutableImageHistoryFromUserDefaults) {
        if ([plist isKindOfClass:[NSString class]]) {
            NSString *existingPhotoID = mutableImageHistoryFromUserDefaults[plist][IMAGE_DATA][[FlickrData photoIDKey]];
            if ([existingPhotoID isEqualToString:newPhotoID]) {
                match = YES;
                break;
            }
        }
    }
    if (match == NO) {
        // if at max count delete that first (earliest) dictionary entry
        if ([mutableImageHistoryFromUserDefaults count] >= MAXSAVEDPHOTOS) {
            NSArray *sortedKeys = [[mutableImageHistoryFromUserDefaults allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
            NSString *firstKey = sortedKeys[0]; // this one to be deleted
            [mutableImageHistoryFromUserDefaults removeObjectForKey:firstKey];
        }
        // update user defaults Finally!
        mutableImageHistoryFromUserDefaults[[[NSDate date] description]] = @{ IMAGE_DATA : photo};
        [[NSUserDefaults standardUserDefaults] setObject:mutableImageHistoryFromUserDefaults forKey:RECENT_IMAGES_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
