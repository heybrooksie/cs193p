//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Peter Brooks on 9/8/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameResult.h"
#import "CONSTANTS.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) NSUInteger flipCount;

@property (strong,nonatomic) CardMatchingGame *game;

@property (nonatomic) NSUInteger NCardsMatchGame;
@property (nonatomic) NSUInteger startingCardCount;
@property (readwrite,nonatomic) NSUInteger matchBonus;
@property (readwrite,nonatomic) NSUInteger mismatchPenalty;
@property (readwrite,nonatomic) NSUInteger flipCost;

@property (strong, nonatomic) GameResult *gameResult;

@end

@implementation CardGameViewController

#pragma mark - Properties

// set default values passed to game
- (NSUInteger)matchBonus { return 4; }
- (NSUInteger)mismatchPenalty { return 2; }
- (NSUInteger)flipCost { return 1; }

- (NSString *)getGameName { return nil; } // abstract
- (Deck *)createDeck { return nil; } // abstract

- (void)setCardButtons:(NSArray *)cardButtons //called when buttons first appear on screen
{
     if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    _cardButtons = cardButtons;
    for (UIButton *cardButton in cardButtons) { // Not create or call game in loop
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [self updateNormalButtonStateForButton:cardButton usingCard:card];
    }
}

- (void)setFlipCount: (NSUInteger)flipCount
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    _flipCount = flipCount;
}

- (CardMatchingGame *)game
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck]
                                      initWithMatchesInGame:self.NCardsMatchGame usingMatchBonus:self.matchBonus
                                       usingMismatchPenalty:self.mismatchPenalty usingFlipCost:self.flipCost];
    }
    return _game;
}

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] initFromGame:[self getGameName]];
    return _gameResult;
}

#pragma mark - Button actions

- (IBAction)dealButton:(id)sender // action from deal button
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    [self updateUI];
}


- (IBAction)flipCard:(UIButton *)sender
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
    self.gameResult.score = self.game.score;
}

#pragma mark - UI updates

// set up updateUI to call various routines that subclasses can call rather than have subclasses override updateUI
- (void)updateUI
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    // following for-loop sets button states 
    for (UIButton *cardButton in self.cardButtons) { // Not create or call game in loop
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [self updateNormalButtonStateForButton:cardButton usingCard:card];
        [self updateSelectedButtonStateForButton:cardButton usingCard:card];
        [self updateSelectedAndDisabledButtonStateForButton:cardButton usingCard:card];
        [self updateAttributesForButton:cardButton usingCard:card];
    }
    [self updateAllLabelsUsingGame:self.game withFlipCount:self.flipCount];
}

- (void)updateNormalButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card { //abstract
}

- (void)updateSelectedButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card { // abstract
    }

- (void)updateSelectedAndDisabledButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card { // abstract
}

- (void)updateAttributesForButton:(UIButton *)cardButton usingCard:(Card *)card { // abstract
}

-(void)updateAllLabelsUsingGame:(CardMatchingGame *)game withFlipCount:(NSUInteger)flipCount {
    self.resultsLabel.text = @"";
    self.scoreLabel.text = @"Score: 0";
    self.flipsLabel.text = @"Flips: 0";
    if (self.flipCount >0) {                        // if game is in progress
        [self updateFlipLabelWithNumberofFlips:self.flipCount];
        [self updateScoreLabelWithScore:self.game.score];
        [self updateResultsLabelWithGame:self.game];
    }
}

// subclasses not overrides this one
-(void)updateFlipLabelWithNumberofFlips:(NSUInteger)flipCount { self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d ",self.flipCount];}

// subclasses not overrides this one
-(void)updateScoreLabelWithScore:(NSUInteger)score { self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score]; }

// subclasses not overrides this one
-(void)updateResultsLabelWithGame:(CardMatchingGame *)game {
    NSUInteger labelType = FLIPLABEL;
    self.resultsLabel.text = [NSString stringWithFormat:@"Card %@ flipped, cost of %d",self.game.currentCard[0],self.game.incrementalScore];
    if ([self.game.cardsThatMayMatchCurrentCard count] == self.NCardsMatchGame - 1) { // max cards in game are face up
        NSString *cardString = [self.game.cardsThatMayMatchCurrentCard componentsJoinedByString:@", "];
        if (self.game.doCardsMatch) {
            labelType = MATCHLABEL;
            self.resultsLabel.text = [NSString stringWithFormat:@"Cards %@ and %@ matched for a score of %d",cardString,self.game.currentCard[0],self.game.incrementalScore];
        } else {
            labelType = MISMATCHLABEL;
            self.resultsLabel.text = [NSString stringWithFormat:@"Cards %@ and %@ do not match, penalty of %d",cardString,self.game.currentCard[0],self.game.incrementalScore];
        }
    }
    [self formatResultsLabel:self.resultsLabel.text forLabelType:labelType usingCurrentCard:self.game.currentCard[0]
        usingFirstTwoMatchCards:self.game.cardsThatMayMatchCurrentCard forLabel:self.resultsLabel];
}

// subclasses override this one if not use non-attributed strings (e.g. PlayingCard not override, SetCard does override)
-(void)formatResultsLabel:(NSString *)resultsLabelText forLabelType:(NSUInteger)labelType
        usingCurrentCard:(Card *)currentCard usingFirstTwoMatchCards:(NSArray *)matchCards forLabel:(UILabel *)resultsLabel {
    // abstract class
}

@end
