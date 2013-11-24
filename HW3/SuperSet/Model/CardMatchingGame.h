//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Peter Brooks on 10/8/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"    

@interface CardMatchingGame : NSObject

@property (readonly,nonatomic) int      score;              // current score
@property (readonly,nonatomic) int      incrementalScore;   // last change in score
@property (readonly,nonatomic) BOOL     doCardsMatch;
@property (readonly,nonatomic) NSArray  *currentCard;       // card just flipped
@property (readonly,nonatomic) NSArray  *cardsThatMayMatchCurrentCard;   // cards flipped before current card

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck initWithMatchesInGame:(int)matchNcards usingMatchBonus:(NSUInteger)matchBonusIn usingMismatchPenalty:(NSUInteger)mismatchPenaltyIn usingFlipCost:(NSUInteger)flipCostIn;                         //designated initializer
- (void)flipCardAtIndex:(NSUInteger)index;          // flip a card
- (Card *)cardAtIndex:(NSUInteger)index;            // get a card
- (void)removeCardAtIndex:(NSUInteger)index;        // remove a card
- (NSUInteger)count;                                // how many cards in game?
- (NSUInteger)addCards:(NSUInteger) numberOfCards;  // add cards to game

@end
