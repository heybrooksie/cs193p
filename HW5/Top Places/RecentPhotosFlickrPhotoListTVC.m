//
//  RecentPhotosFlickrPhotoListTVC.m
//  Top Places
//
//  Created by Peter Brooks on 12/9/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//
#import "RecentPhotosFlickrPhotoListTVC.h"
#import "CONSTANTS.h"
#import "ManageRecentPhotos.h"

@implementation RecentPhotosFlickrPhotoListTVC

- (void)viewDidLoad  {  // don't want to refresh photos in super's viewDidLoad
    //[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:NO];
    self.photos = [ManageRecentPhotos getPhotos];
    [self.tableView reloadData];
}
@end