//
//  AllFlickrPhotosTVC.m
//  Top Places
//
//  Created by Peter Brooks on 12/9/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "LocationsFlickrPhotosTVC.h"
#import "ViewController.h"
#import "ManageRecentPhotos.h"
#import "FlickrData.h"
#import "Spinner.h"
#import "CONSTANTS.h"

@interface LocationsFlickrPhotosTVC ()

@end

@implementation LocationsFlickrPhotosTVC

- (IBAction)fetchPhotos {
    UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc] init];
    if (!self.refreshControl.refreshing) {  // already refreshing so don't start again
        spin = [Spinner start:self.view];   // start the spinner
    }
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrData placeURL:self.place]];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        NSArray *photos = [propertyListResults valueForKeyPath:[FlickrData resultsPhotosKey]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [Spinner stop:spin];                    // stop the spinner
            self.photos = photos;                   // in original order
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath && ([segue.identifier isEqualToString:@"Images"])) {
                ViewController *vc= (ViewController *)segue.destinationViewController;
                [self prepareImageViewController:vc toDisplayPhoto:self.photos[indexPath.row]];
        }
    }
}

- (void)storeSectionDetail {
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    NSMutableString *sectionName = [[NSMutableString alloc] initWithString:@"PHOTOS"];
    NSArray *sectionDetail = [[NSArray alloc] initWithObjects:sectionName,[NSNumber numberWithInt:[self.photos count]],nil];
    [mutArray addObject:sectionDetail];
    self.tableSectionInfo = [[NSArray alloc] initWithArray:mutArray];
}

- (void)savePhoto:(NSDictionary *)photo {
    [ManageRecentPhotos savePhoto:photo];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get the Detail view controller in our UISplitViewController (nil if not in one)
    id detail = self.splitViewController.viewControllers[1];
    // if Detail is a UINavigationController, look at its root view controller to find it
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
        // is the Detail is an ImageViewController?
        if ([detail isKindOfClass:[ViewController class]]) {
            // yes ... we know how to update that!
            [self prepareImageViewController:detail toDisplayPhoto:self.photos[indexPath.row]];
        }
    }
}

#pragma mark - Navigation

// prepares the given ImageViewController to show the given photo
// used either when segueing to an ImageViewController
//   or when our UISplitViewController's Detail view controller is an ImageViewController
// In a story board-based application, you will often want to do a little preparation before navigation

- (void)prepareImageViewController:(ViewController *)ivc toDisplayPhoto:(NSDictionary *)photo
{
    ivc.imageURL = [FlickrData photoURL:photo];
    ivc.title = [FlickrData titleFromPhoto:photo];
    [self savePhoto:photo];
}

#pragma mark - Table view data source methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

@end
