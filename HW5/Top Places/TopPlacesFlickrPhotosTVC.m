//
//  TopPlacesFlickrPhotoListTVC.m
//  Top Places
//
//  Created by Peter Brooks on 12/9/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "TopPlacesFlickrPhotosTVC.h"
#import "LocationsFlickrPhotosTVC.h"
#import "ViewController.h"
#import "FlickrData.h"
#import "CONSTANTS.h"

#define SECTIONNAME 0
#define NUMBEROFROWSINSECTION 1

@interface TopPlacesFlickrPhotosTVC ()

@end

@implementation TopPlacesFlickrPhotosTVC

#pragma mark - UITableViewDelegate

// when a row is selected and we are in a UISplitViewController,
//   this updates the Detail ImageViewController (instead of segueing to it)
// knows how to find an ImageViewController inside a UINavigationController in the Detail too
// otherwise, this does nothing (because detail will be nil and not "isKindOfClass:" anything)


#pragma mark - Prepare for seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath &&([segue.identifier isEqualToString:@"Locations At A Place"])) {
                NSDictionary *photo = [self photoAtIndexPath:indexPath];
                LocationsFlickrPhotosTVC *locationPlace = (LocationsFlickrPhotosTVC *)segue.destinationViewController;
                locationPlace.place = [FlickrData placeIDFromPhoto:photo];
                locationPlace.title = [FlickrData locationFromPhoto:photo];
        }
    }
}

-(NSDictionary *)photoAtIndexPath:(NSIndexPath *)indexPath {
    // get photorow for cell at indexPath section and row
    NSUInteger photoRow = 0;
    for (int i=0; i<indexPath.section; i++) {             // add # of rows until input section
        photoRow = photoRow + [self.tableSectionInfo[i][NUMBEROFROWSINSECTION] integerValue];
    }
    photoRow = photoRow + indexPath.row;
    return self.photos[photoRow];
}

#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableSectionInfo count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableSectionInfo[section][NUMBEROFROWSINSECTION] integerValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.tableSectionInfo[section][SECTIONNAME];
}

- (NSString *)titleForCellAtIndexPath:(NSIndexPath *)indexPath {
    return [FlickrData locationFromPhoto:[self photoAtIndexPath:indexPath]];
}

- (NSString *)subtitleForCellAtIndexPath:(NSIndexPath *)indexPath {
    return [FlickrData minorLocationsFromPhoto:[self photoAtIndexPath:indexPath]];
}

@end
