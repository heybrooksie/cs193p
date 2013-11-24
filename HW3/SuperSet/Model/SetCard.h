//
//  SetCard.h
//  Set
//
//  Created by Peter Brooks on 11/2/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

// a set card has four properties. Note: symbol is one symbol represented by a number code, not say 1 to 3 symbols in an array or attributed string.

@property (nonatomic) NSNumber *symbol;
@property (nonatomic) NSNumber *numberOfSymbols;
@property (nonatomic) NSNumber *color;
@property (nonatomic) NSNumber *shade;

+ (NSArray *)validSymbols;
+ (NSArray *)validColors;
+ (NSArray *)validShades;
+ (NSUInteger)maxNumberOfSymbols;

@end
