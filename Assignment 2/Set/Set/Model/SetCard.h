//
//  SetCard.h
//  Set
//
//  Created by Peter Brooks on 11/2/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong,nonatomic) NSString *symbol;
@property (nonatomic) NSInteger numberOfSymbolsOnCard;
@property (strong,nonatomic) UIColor *color;
@property (nonatomic) CGFloat shade;


//@property (nonatomic) BOOL faceUp;

+ (NSArray *)validSymbols;
+ (NSArray *)validColors;
+ (NSArray *)validShades;
+ (NSInteger)maxNumberOfSymbolsOnCard;

@end
