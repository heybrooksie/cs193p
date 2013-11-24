//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Peter Brooks on 9/8/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

// public outlets amd properties that subclasses MAY reference if needed
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak,nonatomic) IBOutlet UIView *resultsView;
@property (strong,nonatomic) CardMatchingGame *game;

// property getter methods that subclasses MUST override
@property (nonatomic) NSUInteger NCardsMatchGame;   // abstract
@property (nonatomic) NSUInteger startingCardCount; // abstract

// properties and property getter methods that subclasses MAY override
@property (nonatomic) NSUInteger matchBonus;
@property (nonatomic) NSUInteger mismatchPenalty;
@property (nonatomic) NSUInteger flipCost;
- (NSString *)ResultsLabelInitialText;           // abstract
- (Deck *)createDeck;                               // abstract
- (NSString *)getGameName;                          // abstract

// methods that subclasses MUST override
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card;     // abstract
- (BOOL)deleteCardAtIndexPath:(NSIndexPath *)indexPath ofCollectionView:(UICollectionView *)view ofGame:(CardMatchingGame *)game;                // abstract

// methods that subclasses MAY override
- (UIView *)initializeResultsUsingView:(UIView *)view;
- (UIView *)showFlipResultsUsingView:(UIView *)view usingCard:(NSArray *)card;
- (UIView *)showMatchResultsUsingView:(UIView *)view usingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards;
- (UIView *)showMismatchResultsUsingView:(UIView *)view usingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards;

@end
