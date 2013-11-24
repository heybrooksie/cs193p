//
//  GameResultViewController.m
//  Matchismo
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University.
//  All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"
#import "CONSTANTS.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;  // wire this up to a UITextView
@property (nonatomic) SEL sortSelector; // added after lecture
@end

@implementation GameResultViewController

- (void)updateUI
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    NSString *displayText = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init]; // added after lecture
    [formatter setDateStyle:NSDateFormatterShortStyle];          // added after lecture
    [formatter setTimeStyle:NSDateFormatterShortStyle];          // added after lecture
    for (GameResult *result in [[GameResult allGameResults] sortedArrayUsingSelector:self.sortSelector]) { // sorted
        displayText = [displayText stringByAppendingFormat:@"%@: Score: %d (%@, %0g seconds)\n",result.gameName, result.score, [formatter stringFromDate:result.end], round(result.duration)];  // formatted date
    }
    self.display.text = displayText;
}

#pragma mark - View Controller Lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    [super viewWillAppear:animated];
    [self updateUI];
}

// Sorting section added after lecture.
// See also the Sorting section in GameResult.[mh].
// Wire up the three IBActions to the three buttons in the View.

#pragma mark - Sorting

@synthesize sortSelector = _sortSelector;  // because we implement BOTH setter and getter

// return default sort selector if none set (by score)

- (SEL)sortSelector
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_sortSelector) _sortSelector = @selector(compareEndDateToGameResult:);
    return _sortSelector;
}

// update the UI when changing the sort selector

- (void)setSortSelector:(SEL)sortSelector
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    _sortSelector = sortSelector;
    [self updateUI];
}

- (IBAction)sortByDate
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    self.sortSelector = @selector(compareEndDateToGameResult:);
}

- (IBAction)sortByScore
{
    self.sortSelector = @selector(compareScoreToGameResult:);
}

- (IBAction)sortByDuration
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    self.sortSelector = @selector(compareDurationToGameResult:);
}

#pragma mark - (Unused) Initialization before viewDidLoad

- (void)setup
{
    // initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

@end
