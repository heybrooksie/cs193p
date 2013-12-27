//
//  AllFlickrPhotosTVC.h
//  Top Places
//
//  Created by Peter Brooks on 12/9/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "FlickrPhotosTVC.h"

@interface LocationsFlickrPhotosTVC : FlickrPhotosTVC

@property (strong,nonatomic) NSString *place;

- (void)storeSectionDetail;

@end
