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

- (void)setSymbol:(NSString *)symbol
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString *)symbol
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return _symbol ? _symbol : @"?";
}

- (NSInteger)numberOfSymbolsOnCard {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return _numberOfSymbolsOnCard ? _numberOfSymbolsOnCard : 0;
}

@synthesize color = _color;

// validates color is valid
- (void)setColor:(UIColor *)color
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (UIColor *)color
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return _color ? _color : 0;
}

@synthesize shade = _shade;

- (void)setShade:(CGFloat)shade
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    NSNumber *num = [NSNumber numberWithFloat:shade];
    if ([[SetCard validShades] containsObject:num]) {
        _shade = shade;
    }
}

// returns 0 if shade has never been set (is equal to nil)
- (CGFloat)shade
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return _shade ? _shade : 0;
}

- (NSString *)contents
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    NSString *cardContents = @"";
    int numberOfSymbols = self.numberOfSymbolsOnCard;
    NSString *symbol = self.symbol;
    return cardContents = [cardContents stringByPaddingToLength:numberOfSymbols withString:symbol startingAtIndex:0];;
}

+ (NSArray *)validSymbols
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    static NSArray *validSymbols = nil;
    if (!validSymbols) validSymbols = @[@"●", @"▲",@"◆"];
    return validSymbols;
}

+ (NSArray *)validShades
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    static NSArray *validShades = nil;
    if (!validShades) validShades = @[[NSNumber numberWithFloat:0.15f],[NSNumber numberWithFloat:.45f],[NSNumber numberWithFloat:1.0f]]; // Shade value is direct convert to alpha
    return validShades;
}

+ (NSArray *)validColors
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    static NSArray *validColors = nil;
    if (!validColors) validColors = @[[UIColor redColor], [UIColor greenColor],[UIColor blueColor]];
    return validColors;
}

+ (NSInteger)maxNumberOfSymbolsOnCard
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return [self validSymbols].count;
}

- (int)match:(NSArray *)otherCards {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    bool allNumbersMatch = YES;
    bool allColorsMatch = YES;
    bool allSymbolsMatch = YES;
    bool allShadesMatch = YES;
    bool noNumbersMatch = NO;
    bool noColorsMatch = NO;
    bool noSymbolsMatch = NO;
    bool noShadesMatch = NO;BOOL itIsAMatch;
    switch (otherCards.count) {
        case 1:  // if only one other card, card and otherCard[0] are always a possible match by definition of Set game
            itIsAMatch = YES;
            break;
        default: // current card plus two other cards
            // check if all card properties match.
            itIsAMatch = NO;  // didn't really need this, for readibility only
            // check for matches across all cards
            for (SetCard *card in otherCards) {
                if (!(card.numberOfSymbolsOnCard == self.numberOfSymbolsOnCard)) {
                    allNumbersMatch = NO;
                    break;
                }
            }
            for (SetCard *card in otherCards) {
                if (![card.symbol isEqualToString:self.symbol]) {
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
            if (!(card0.numberOfSymbolsOnCard == self.numberOfSymbolsOnCard) &&
                !(card1.numberOfSymbolsOnCard == self.numberOfSymbolsOnCard) &&
                !(card0.numberOfSymbolsOnCard == card1.numberOfSymbolsOnCard)) noNumbersMatch = YES;
            if (!([card0.symbol isEqualToString:self.symbol]) &&
                !([card1.symbol isEqualToString:self.symbol]) &&
                !([card0.symbol isEqualToString:card1.symbol])) noSymbolsMatch = YES;
            if (!([card0.color isEqual:self.color]) &&
                !([card1.color isEqual:self.color]) &&
                !([card0.color isEqual:card1.color])) noColorsMatch = YES;
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
