//
//  FlickrPhotosTVC.h
//  Top Places
//
//  Created by Peter Brooks on 12/9/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotosTVC : UITableViewController

@property (strong,nonatomic) NSArray *photos;   // of Flickr top places NSDictionary
@property (strong,nonatomic) NSArray *tableSectionInfo;   // index = section #, array for each section: (0) description, (1) # of rows, (2) row in Photos of first row

//abstract methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

//optional methods to be used by subclasses
- (IBAction)fetchPhotos;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;  // abstract class default to 1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;   // default to # of photos
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;// default to "Photos"
- (NSString *)titleForCellAtIndexPath:(NSIndexPath *)indexPath;// abstract class
- (NSString *)subtitleForCellAtIndexPath:(NSIndexPath *)indexPath; // abstract class



@end
