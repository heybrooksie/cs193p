//
//  Deck.m
//  Matchismo
//
//  Created by Peter Brooks on 9/24/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "Deck.h"
#import "CONSTANTS.h"

@interface Deck()
@property (strong,nonatomic) NSMutableArray *cards;
@end

@implementation Deck

// syntheses begin

- (NSMutableArray *)cards {
     if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}

// systheses end

- (void)addCard:(Card *)card atTop:(BOOL)atTop {
     if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (atTop) {
        [self.cards insertObject:card atIndex:0]; // call cards
    }
    else {
        [self.cards addObject:card]; // call cards
    }
}

- (Card *)drawRandomCard {
     if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    Card *randomCard = nil;
    if (self.cards.count) {
        unsigned index = arc4random() % self.cards.count;
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}



@end
