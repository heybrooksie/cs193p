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


- (int)match:(NSArray *)otherCards {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    int score = 0;
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
                score = 4;
        }
    }
    return score;
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
