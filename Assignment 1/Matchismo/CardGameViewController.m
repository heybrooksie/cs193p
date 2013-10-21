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
/* to do's
 
 - use hint to better snych card image to edge
 - in PlayingCardGame, match 3 cards using an array not ||'s or &&'s. Or two inputs not one.
 - results in PlayingCardGame sends back results data (e.g. card values and status and score), not a string. The string is created in the controller, the philosophy that the controller handles all text.
 - generalize the two card match loop to handle a three card match, eliminating the 3 card match loop.
*/

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (strong,nonatomic) CardMatchingGame *game;
@property (strong,nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic) int cardsInGame;
@end

@implementation CardGameViewController

- (void)viewDidLoad
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    UISegmentedControl *sC = self.segmentedControl;
    sC.frame = CGRectMake(144, 419, 80, 25);
    sC.segmentedControlStyle = UISegmentedControlStylePlain;
    
    UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [sC setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    sC.selectedSegmentIndex = 0;
    [sC addTarget:self
                         action:@selector(pickone:)
               forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:sC];
    self.cardsInGame = 2;
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
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[PlayingCardDeck alloc] init]];
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
    // following for-loop sets card states
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents
                    forState:UIControlStateSelected | UIControlStateDisabled];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(0, 1.0, 0.0, 0.0)];
        [cardButton setImage:[UIImage imageNamed:@"cardback.png"] forState:UIControlStateNormal];
        [cardButton setImage:[[UIImage alloc]init] forState:UIControlStateSelected | UIControlStateDisabled];
        [cardButton setImage:[[UIImage alloc]init] forState:UIControlStateSelected];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
    }
    // following logic sets results and score fields
    self.resultsLabel.text = [NSString stringWithFormat:@"Card %@ flipped, cost of %d",self.game.currentCard[0],self.game.incrementalScore]; // default result is flip cost
    if ([self.game.cardsThatMayMatchCurrentCard count] == self.cardsInGame - 1) { // max cards in game are face up
        NSString *cardString = [self.game.cardsThatMayMatchCurrentCard componentsJoinedByString:@", "];
        if (self.game.doCardsMatch)
            self.resultsLabel.text = [NSString stringWithFormat:@"Cards %@ and %@ matched for a score of %d",cardString,self.game.currentCard[0],self.game.incrementalScore];
        else 
            self.resultsLabel.text = [NSString stringWithFormat:@"Cards %@ and %@ do not match, penalty of %d",cardString,self.game.currentCard[0],self.game.incrementalScore];
    }         
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    // enable or not segmented control
    self.segmentedControl.enabled = (self.flipCount >0)? NO:YES;
}

- (void)setFlipCount: (int)flipCount
{
     if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d ",self.flipCount];
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
            self.cardsInGame = 2;
            break;
        default:
            self.cardsInGame = 3;
            break;
    }
}

- (IBAction)flipCard:(UIButton *)sender
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender] :self.cardsInGame];
    self.flipCount++;
    [self updateUI];
}

@end
