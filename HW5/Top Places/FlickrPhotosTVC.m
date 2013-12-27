//
//  FlickrPhotosTVC.m
//  Top Places
//
//  Created by Peter Brooks on 12/9/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "FlickrPhotosTVC.h"
#import "CONSTANTS.h"
#import "FlickrData.h"
#import "Spinner.h"

#define SECTION_TITLE @"All Photos"
#define NUMBER_OF_SECTIONS 1

@implementation FlickrPhotosTVC

#pragma mark - Setup / getters and setters

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotos];
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    if ([photos count] > 0) {
        [self storeSectionDetail];
        [self.tableView reloadData];
    }
}

#pragma mark - Get Photos

- (IBAction)fetchPhotos {
    UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc] init];
    if (!self.refreshControl.refreshing) {  // already refreshing so don't start again
        spin = [Spinner start:self.view];   // start the spinner
    }
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:[FlickrData topPlacesURL]];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        NSArray *photos = [[propertyListResults valueForKeyPath:[FlickrData resultsPlacesKey]]
                           sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                               NSString *sort1 = [[FlickrData countryFromPhoto:obj1] stringByAppendingString:[FlickrData locationFromPhoto:obj1]];
                               NSString *sort2 = [[FlickrData  countryFromPhoto:obj2] stringByAppendingString:[FlickrData locationFromPhoto:obj2]];
        return [sort1 compare:sort2];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [Spinner stop:spin];    // stop the spinner
            self.photos = photos;   // in original order;
        });
    });

}

#pragma mark - Photos location section-row xref

// create dictionary of number of sections and rows so only need to go through photos once
// rather than each time we check # of sections and rows
- (void)storeSectionDetail {
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    NSUInteger rowInPhotos = 0;                                         // row in Photos array
    NSUInteger rowsInSection = 0;
    NSMutableString *sectionName = [[NSMutableString alloc] initWithString:[FlickrData countryFromPhoto:self.photos[0]]];  // init to first row value
       for (id obj in self.photos) {                                       // for each row in photos. Photos is already sorted
        NSString *country = [FlickrData countryFromPhoto:self.photos[rowInPhotos]];
        if ([sectionName isEqualToString:country]) {                    // if same place name
            rowsInSection++;                                            // one more row is in the section
        } else {                                                        // new place name
            sectionName = [NSMutableString stringWithString:[FlickrData countryFromPhoto:self.photos[rowInPhotos-1]]];
            NSArray *sectionDetail = [[NSArray alloc] initWithObjects:sectionName,[NSNumber numberWithInt:rowsInSection],nil];
            [mutArray addObject:sectionDetail];
            sectionName = [NSMutableString stringWithString:country];
            rowsInSection = 1;
        }
        rowInPhotos++;
    }
    NSArray *sectionDetail = [[NSArray alloc] initWithObjects:sectionName,[NSNumber numberWithInt:rowsInSection],nil];
    [mutArray addObject:sectionDetail];
    self.tableSectionInfo = [[NSArray alloc] initWithArray:mutArray];
}

#pragma mark - Prepare for seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender    // abstract method
{
    // abstract method
}

#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return SECTION_TITLE;
}

- (NSString *)titleForCellAtIndexPath:(NSIndexPath *)indexPath {     //   abstract
    return [FlickrData titleFromPhoto:self.photos[indexPath.row]];
}

- (NSString *)subtitleForCellAtIndexPath:(NSIndexPath *)indexPath {  //   abstract
    return [FlickrData descriptionFromPhoto:self.photos[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"All Photos" forIndexPath:indexPath];
        cell.textLabel.text = [self titleForCellAtIndexPath:indexPath];
        cell.detailTextLabel.text = [self subtitleForCellAtIndexPath:indexPath];
    } else {
        cell = nil;
    }
    return cell;
}

@end
