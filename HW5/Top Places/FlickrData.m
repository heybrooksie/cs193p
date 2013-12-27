//
//  \FlickrData.m
//  Top Places
//
//  Created by Peter Brooks on 12/20/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "FlickrData.h"
#import "FlickrFetcher.h"
#import "CONSTANTS.h"

@implementation FlickrData

+ (NSString *)countryFromPhoto:(NSDictionary *)photo {
    return [[[photo valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] lastObject];;
}

+ (NSString *)locationFromPhoto:(NSDictionary *)photo {
    return [[[photo valueForKeyPath:FLICKR_PLACE_NAME] componentsSeparatedByString:@", "] firstObject];
}

+ (NSString *)placeNameFromPhoto:(NSDictionary *)photo {
    return photo[FLICKR_PLACE_NAME];
}

+ (NSString *)placeIDFromPhoto:(NSDictionary *)photo {
    return photo[FLICKR_PLACE_ID];
}

+ (NSString *)minorLocationsFromPhoto:(NSDictionary *)photo {
    NSArray *locations = [photo[FLICKR_PLACE_NAME] componentsSeparatedByString:@", "];
    NSString *midLocations = [[NSString alloc] init];
    if ([locations count] <=2) {
        midLocations = @"";
    } else {
        midLocations = [[locations subarrayWithRange:NSMakeRange(1,([locations count]-2))] componentsJoinedByString:@", "];
    }
    return midLocations;
}

+ (NSString *)descriptionFromPhoto:(NSDictionary *)photo {
    return photo[FLICKR_PHOTO_DESCRIPTION];
}

+ (NSString *)titleFromPhoto:(NSDictionary *)photo {
    NSString *title = [[NSString alloc] initWithString:photo[FLICKR_PHOTO_TITLE]];
    if (([photo[FLICKR_PHOTO_TITLE] length] == 0) &&
        ([photo[FLICKR_PHOTO_DESCRIPTION] length] == 0)) {
        title = @"UNKNOWN";
    }
    return title;
}

#define MAXLOCATIONS 50
+ (NSURL *)placeURL:(NSString *)place {
    return [FlickrFetcher URLforPhotosInPlace:place maxResults:MAXLOCATIONS];
}

+ (NSURL *)photoURL:(NSDictionary *)photo {
    return [FlickrFetcher URLforPhoto:photo format:FlickrPhotoFormatLarge];
}

+ (NSURL *)topPlacesURL {
    return [FlickrFetcher URLforTopPlaces];
}

+ (NSString *)resultsPhotosKey {
    return FLICKR_RESULTS_PHOTOS;
}

+ (NSString *)resultsPlacesKey {
    return FLICKR_RESULTS_PLACES;
}

+ (NSString *)photoIDKey {
    return FLICKR_PHOTO_ID;
}

@end
