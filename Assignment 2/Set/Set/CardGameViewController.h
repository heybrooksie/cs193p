//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Peter Brooks on 9/8/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

// all of the following methods must be overriden by concrete subclasses

@property (readonly, nonatomic) NSUInteger startingCardCount; // abstract
@property (readonly,nonatomic) NSUInteger matchBonus;
@property (readonly,nonatomic) NSUInteger mismatchPenalty;
@property (readonly,nonatomic) NSUInteger flipCost;

- (Deck *)createDeck; // abstract
- (NSString *)getGameName; // abstract
- (void)updateNormalButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card; //abstract
- (void)updateSelectedButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card; // abstract
- (void)updateSelectedAndDisabledButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card; // abstract
- (void)updateAttributesForButton:(UIButton *)cardButton usingCard:(Card *)card; //abstract
- (void)formatResultsLabel:(NSString *)resultsLabelText forLabelType:(NSUInteger)labelType
         usingCurrentCard:(Card *)currentCard usingFirstTwoMatchCards:(NSArray *)matchCards forLabel:(UILabel *)resultsLabel; //abstract

@end
