//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Peter Brooks on 9/8/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "CardGameViewController.h"
#import "GameResult.h"
#import "CONSTANTS.h"

@interface CardGameViewController () <UICollectionViewDataSource>

// outlet properties
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

// internal properties
@property (nonatomic) NSUInteger flipCount;
@property (strong, nonatomic) GameResult *gameResult;

@end

@implementation CardGameViewController

#pragma mark - External methods

// property getter methods that subclasses should override
- (NSUInteger)NCardsMatchGame   { return 0;}            // abstract
- (NSUInteger)startingCardCount {return 0;}             // abstract

// non-property methods that subclasses must override
- (NSString *)ResultsLabelInitialText { return @"";} // abstract
- (Deck *)createDeck            { return nil; }         // abstract
- (NSString *)getGameName       { return nil; }         // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card { } // abstract

// property getter methods that subclasses might override
- (NSUInteger)matchBonus        { return 4; }           // default
- (NSUInteger)mismatchPenalty   { return 2; }           // default
- (NSUInteger)flipCost          { return 1; }           // default

#pragma mark - Internal methods

- (void)setFlipCount: (NSUInteger)flipCount { _flipCount = flipCount; }

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView { return 1; }

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section { return [self.game count]; }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
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

#pragma mark - Button action methods

- (IBAction)dealButton:(id)sender // action from deal button
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    self.game = nil;
    self.gameResult = nil;
    self.flipCount = 0;
    [self updateUI];
    [self.cardCollectionView reloadData];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        [self updateUI];
        self.gameResult.score = self.game.score;
    }
}

#pragma mark - UI update methods

// set up updateUI to call various routines that subclasses can call rather than have subclasses override updateUI
- (void)updateUI {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    // following for-loop sets collectionView states 
    NSUInteger isItAMatch = [self doCardsMatch];  // is it a match?
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        if (card.isUnplayable && card.isFaceUp) {
            /* It is a match so call the delete card method. If a subclass deletes the cards (return = YES) then all is good. If a subclass does not delete the cards, then we need to update the UI to show the cards just flipped / matched / mismatched according to the subclass rules */
            if (![self deleteCardAtIndexPath:indexPath ofCollectionView:self.cardCollectionView ofGame:self.game])
            [self updateCell:cell usingCard:card];
        }
        else {
            [self updateCell:cell usingCard:card];   
        }
    }
    [self updateScoreLabelWithScore:self.game.score];
    [self createResultsTextUsingCard:self.game.currentCard usingMatchCards:self.game.cardsThatMayMatchCurrentCard usingView:self.resultsView forState:isItAMatch];
}

-(NSUInteger)doCardsMatch { 
    NSUInteger matchState = STARTOFGAME;
    if (self.flipCount > 0) {                        // if game is in progress
        matchState = CARDWASFLIPPED;
        if ([self.game.cardsThatMayMatchCurrentCard count] == (self.NCardsMatchGame - 1)) { // max cards in game are face up
            if (self.game.doCardsMatch) {
                matchState = CARDSMATCH;
            } else {
                matchState = CARDSMISMATCH;
            }
        }
    }
return matchState;
}

// subclasses not override this one
-(void)updateScoreLabelWithScore:(NSUInteger)score { self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d",self.game.score]; }

- (void)createResultsTextUsingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards usingView:(UIView *)view forState:(NSUInteger)matchState {
    [self removeAllSubviewsFromView:view];  // eliminate old view being seen from under new view
    UIView *resultsSubview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width,view.bounds.size.height)];           // create a subview of the results view so methods can update with labels or drawing
    switch (matchState) {
        case CARDWASFLIPPED: {
            resultsSubview = [self showFlipResultsUsingView:resultsSubview usingCard:card];
            break;
        }case CARDSMATCH: {
            resultsSubview = [self showMatchResultsUsingView:resultsSubview usingCard:card usingMatchCards:matchCards];
            break;
        }
        case CARDSMISMATCH: {
            resultsSubview = [self showMismatchResultsUsingView:resultsSubview usingCard:card usingMatchCards:matchCards];
            break;
        }
        default: {  // it is beginning of game
            resultsSubview = [self initializeResultsUsingView:resultsSubview];
        }
    }
    [view addSubview:resultsSubview];
}

- (UIView *)initializeResultsUsingView:(UIView *)view {
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width,                                                                       view.bounds.size.height)];
    labelView.backgroundColor=[UIColor clearColor];
    labelView.text = [self ResultsLabelInitialText];
    [view addSubview:labelView];
    return view;
}

- (UIView *)showFlipResultsUsingView:(UIView *)view usingCard:(NSArray *)card {
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width,                                                                       view.bounds.size.height)];
    labelView.text = @"Card Flipped";
    [view addSubview:labelView];
    return view;
}

- (UIView *)showMatchResultsUsingView:(UIView *)view usingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards {
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width,                                                                       view.bounds.size.height)];
    labelView.text = @"Cards Matched";
    [view addSubview:labelView];
    return view;}

- (UIView *)showMismatchResultsUsingView:(UIView *)view usingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards {
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width,                                                                       view.bounds.size.height)];
    labelView.text = @"Cards Mismatched";
    [view addSubview:labelView];
    return view;
}


- (BOOL)deleteCardAtIndexPath:(NSIndexPath *)indexPath ofCollectionView:(UICollectionView *)view ofGame:(CardMatchingGame *)game {
    // abstract class
    return NO;
}

- (void)removeAllSubviewsFromView:(UIView *)view {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    for (UIView *subview in view.subviews)
    {
        [subview removeFromSuperview];
    }
}

@end
