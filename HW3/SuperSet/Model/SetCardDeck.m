//
//  SetCardDeck.m
//  Set
//
//  Created by Peter Brooks on 11/2/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"
#import "CONSTANTS.h"

@implementation SetCardDeck

- (id)init // init called first
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    self = [super init];
    if (self) {
        for (NSNumber *symbol in [SetCard validSymbols]) {
            for (NSUInteger numberOfSymbols = 1; numberOfSymbols <= [SetCard maxNumberOfSymbols]; numberOfSymbols++) {
                for (NSNumber *color in [SetCard validColors]) {
                    for (NSNumber *shade in [SetCard validShades]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.numberOfSymbols = [NSNumber numberWithInteger:numberOfSymbols];
                        card.color = color;
                        card.shade = shade;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}
@end
