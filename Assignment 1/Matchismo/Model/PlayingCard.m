//
//  PlayingCard.m
//  Matchismo
//
//  Created by Peter Brooks on 9/24/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "PlayingCard.h"
#import "CONSTANTS.h"

@implementation PlayingCard

//beginning of syntheses
// must use synthesize if creating getter and setter
@synthesize suit = _suit;

// validates suit is a valid suit
- (void)setSuit:(NSString *)suit
{
     if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

// returns ? if suit has never been set (is equal to nil)
- (NSString *)suit
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return _suit ? _suit : @"?";
}


- (int)match:(NSArray *)otherCards
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    int score = 0;                      // starting score
    int scoreMultiplier = 1;            // multiplier increases with match complexity (# of cards)
    int scoreMultiplierIncrement = 2;   // how much to increment complexity each time
    BOOL matchOnSuit = YES;             // are we matching on suit? Initially yes
    BOOL matchOnRank = YES;             // are we matching on suit? Initially yes
    BOOL firstTimeInLoop = YES;  
    for (PlayingCard *card in otherCards) {     // for each card in incoming array
        if ((matchOnSuit &&[card.suit isEqualToString:self.suit])) {
            score = 1;
            matchOnRank = NO;           //since we matched on suit, don't match on rank
        } else {
            if ((matchOnRank && card.rank == self.rank)) {
                score = 4;
                matchOnSuit = NO;       //since we matched on rank, don't match on suit
            }
            else { // no suit or rank match
                score = 0;
                break;
            }
        }
        if (firstTimeInLoop) firstTimeInLoop = NO; else scoreMultiplier *= scoreMultiplierIncrement; // increment complexity multiplier
    }
    return score*scoreMultiplier;
}

- (NSString *)contents
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

// end of syntheses

+ (NSArray *)validSuits
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♥", @"♦",@"♠",@"♣"];
    return validSuits;
}

+ (NSArray *)rankStrings
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    return rankStrings;
}

+ (NSUInteger)maxRank
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return [self rankStrings].count-1;
}

@end
