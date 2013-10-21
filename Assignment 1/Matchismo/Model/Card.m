//
//  Card.m
//  Matchismo
//
//  Created by Peter Brooks on 9/24/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "Card.h"
#import "CONSTANTS.h"

@interface Card()
@end

@implementation Card

 -(NSString *)description
{
    return self.contents;
}

- (int)match:(NSArray *)otherCards
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

@end
