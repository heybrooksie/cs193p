//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Peter Brooks on 9/8/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "CONSTANTS.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (strong,nonatomic) CardMatchingGame *game;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic) int NCardsMatchGame;
@end

@implementation CardGameViewController

- (void)viewDidLoad // all outlets set before here, but geometry not set (do in viewWillAppear)
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    UISegmentedControl *sC = self.segmentedControl;
    sC.frame = CGRectMake(144, 419, 80, 25);
    sC.segmentedControlStyle = UISegmentedControlStylePlain;
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [sC setTitleTextAttributes:attributes forState:UIControlStateNormal];
    sC.selectedSegmentIndex = 0;
    [sC addTarget:self action:@selector(pickone:)
               forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:sC];
    self.NCardsMatchGame = 2; // just starting, set to default
}

- (UISegmentedControl *)segmentedControl
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_segmentedControl) {
        NSArray *itemArray = [NSArray arrayWithObjects: @"2 Card", @"3 Card", nil];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    }
    return _segmentedControl;
}

- (CardMatchingGame *)game
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_game) {
        //if (self.cardsInGame == 0) self.cardsInGame = 2; // just starting, set to default
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init] initWithMatchesInGame:self.NCardsMatchGame];
    }
    return _game;
}

// called when buttons first displayed on screen
- (void)setCardButtons:(NSArray *)cardButtons
{
     if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    // following for-loop sets button states 
    for (UIButton *cardButton in self.cardButtons) { // Not create or call game in loop
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(0, 1.0, 0.0, 0.0)];
        [cardButton setImage:[UIImage imageNamed:@"cardback.png"] forState:UIControlStateNormal];
        [cardButton setImage:[[UIImage alloc]init] forState:UIControlStateSelected | UIControlStateDisabled];
        [cardButton setImage:[[UIImage alloc]init] forState:UIControlStateSelected];
        [cardButton setTitle:@"" forState:UIControlStateSelected];
        cardButton.selected = NO;
        cardButton.enabled = YES;
        cardButton.alpha = 1.0;
        if (self.flipCount > 0) { //if game in play (we know 2- or 3- card game)
            Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];            [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
            [cardButton setTitle:card.contents forState:UIControlStateSelected];
            cardButton.selected = card.isFaceUp;
            cardButton.enabled = !card.isUnplayable;
            cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
        }
    }
    // move here all logic to updates text fields and segmentcontrol enable 
    self.resultsLabel.text = @"";
    self.scoreLabel.text = @"Score: 0";
    self.flipsLabel.text = @"Flips: 0";
    self.segmentedControl.enabled = YES;
    if (self.flipCount >0) {                        // if game is in progress
        self.segmentedControl.enabled = NO;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
        self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d ",self.flipCount];
        self.resultsLabel.text = [NSString stringWithFormat:@"Card %@ flipped, cost of %d",self.game.currentCard[0],self.game.incrementalScore];
        if ([self.game.cardsThatMayMatchCurrentCard count] == self.NCardsMatchGame - 1) { // max cards in game are face up
            NSString *cardString = [self.game.cardsThatMayMatchCurrentCard componentsJoinedByString:@", "];
            if (self.game.doCardsMatch)
                self.resultsLabel.text = [NSString stringWithFormat:@"Cards %@ and %@ matched for a score of %d",cardString,self.game.currentCard[0],self.game.incrementalScore];
            else 
                self.resultsLabel.text = [NSString stringWithFormat:@"Cards %@ and %@ do not match, penalty of %d",cardString,self.game.currentCard[0],self.game.incrementalScore];
        }
    }
}

- (void)setFlipCount: (int)flipCount
{
     if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    _flipCount = flipCount;
}

- (IBAction)dealButton:(id)sender
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
}
- (IBAction)pickone:(id)sender
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch(selectedSegment) {
        case 0:
            self.NCardsMatchGame = 2;
            break;
        default:
            self.NCardsMatchGame = 3;
            break;
    }
}

- (IBAction)flipCard:(UIButton *)sender
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

@end
