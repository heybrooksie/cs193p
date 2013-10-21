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

//designated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index :(int)cardsInGame;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (readonly,nonatomic) int score;
@property (readonly,nonatomic) int incrementalScore;
@property (readonly,nonatomic) BOOL doCardsMatch;
@property (readonly,nonatomic) NSArray *currentCard;
@property (readonly,nonatomic) NSArray *cardsThatMayMatchCurrentCard;
@end
