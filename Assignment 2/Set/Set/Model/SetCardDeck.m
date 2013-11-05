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
        for (NSString *symbol in [SetCard validSymbols]) {
            for (NSUInteger symbolsOnCard = 1; symbolsOnCard <= [SetCard maxNumberOfSymbolsOnCard]; symbolsOnCard++) {
                for (UIColor *color in [SetCard validColors]) {
                    for (NSNumber *shade in [SetCard validShades]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.numberOfSymbolsOnCard = symbolsOnCard;
                        card.color = color;
                        card.shade = [shade floatValue]; // convert NSNumber to float
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}
@end
