//
//  SetCard.m
//  Set
//
//  Created by Peter Brooks on 11/2/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "SetCard.h"
#import "CONSTANTS.h"
#import <objc/runtime.h>

// valid symbols, colors, shades set in valid...  Max # of symbols set based on size of validsymbols array

@implementation SetCard

//beginning of syntheses
// must use synthesize if creating getter and setter

@synthesize symbol = _symbol;

- (void)setSymbol:(NSNumber *)symbol
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSNumber *)symbol
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return _symbol ? _symbol : 0;
}


@synthesize color = _color;

// validates color is valid
- (void)setColor:(NSNumber *)color
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSNumber *)color
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return _color ? _color : 0; // returns 0 if requested color not valid
}

@synthesize shade = _shade;

- (void)setShade:(NSNumber *)shade
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if ([[SetCard validShades] containsObject:shade]) {
        _shade = shade;
    }
}

- (NSNumber *)shade
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return _shade ? _shade : 0; // returns 0 if requested color not valid
}

+ (NSArray *)validSymbols
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    static NSArray *validSymbols = nil;
    if (!validSymbols) validSymbols = @[@diamond,@squiqqle,@oval];  // symbols defined as constants
    return validSymbols;
}

+ (NSArray *)validShades
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    static NSArray *validShades = nil;
    if (!validShades) validShades = @[@solid,@striped,@open];       // shades defined as constants
    return validShades;
}

+ (NSArray *)validColors
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    static NSArray *validColors = nil;
    if (!validColors) validColors = @[@red,@green,@purple];         // colors defined as constants
    return validColors;
}

+ (NSUInteger)maxNumberOfSymbols    // could have made this same as others, e.g. validNumberof Symbols
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return [self validSymbols].count;
}

- (int)match:(NSArray *)otherCards {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    BOOL allNumbersMatch = YES;
    BOOL allColorsMatch = YES;
    BOOL allSymbolsMatch = YES;
    BOOL allShadesMatch = YES;
    BOOL noNumbersMatch = NO;
    BOOL noColorsMatch = NO;
    BOOL noSymbolsMatch = NO;
    BOOL noShadesMatch = NO;
    BOOL itIsAMatch = NO;
    switch (otherCards.count) {
        case 1:  // if only one other card, card and otherCard[0] are always a possible match by definition of Set game
            itIsAMatch = YES;
            break;
        default: // current card plus two other cards. otherCards.count = 2
            // check for matches across all cards
            for (SetCard *card in otherCards) {
                if (!(card.numberOfSymbols == self.numberOfSymbols)) {
                    allNumbersMatch = NO;
                    break;
                }
            }
            for (SetCard *card in otherCards) {
                if (!(card.symbol == self.symbol)) {
                    allSymbolsMatch = NO;
                    break;
                }
            }
            for (SetCard *card in otherCards) {
                if (![card.color isEqual:self.color]) {
                    allColorsMatch = NO;
                    break;
                }
            }
            for (SetCard *card in otherCards) {
                if (!(card.shade == self.shade)) {
                    allShadesMatch = NO;
                    break;
                }
            }
            // check for no matches across all cards
            SetCard *card0 = otherCards[0];
            SetCard *card1 = otherCards[1];
            if (!(card0.numberOfSymbols == self.numberOfSymbols) &&
                !(card1.numberOfSymbols == self.numberOfSymbols) &&
                !(card0.numberOfSymbols == card1.numberOfSymbols)) noNumbersMatch = YES;
            if (!(card0.symbol == self.symbol) &&
                !(card1.symbol == self.symbol) &&
                !(card0.symbol == card1.symbol)) noSymbolsMatch = YES;
            if (!(card0.color == self.color) &&
                !(card1.color == self.color) &&
                !(card0.color == card1.color)) noColorsMatch = YES;
            if (!(card0.shade == self.shade) &&
                !(card1.shade == self.shade) &&
                !(card0.shade == card1.shade)) noShadesMatch = YES;
            break;
    }
    
    if ((allNumbersMatch || noNumbersMatch) &&
        (allSymbolsMatch || noSymbolsMatch) &&
        (allColorsMatch || noColorsMatch) &&
        (allShadesMatch || noShadesMatch)) itIsAMatch = YES;
    if (itIsAMatch) {return 1;} else {return 0;}
}

@end
