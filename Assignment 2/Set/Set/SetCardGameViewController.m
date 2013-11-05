//
//  SetCardGameViewController.m
//  Set
//
//  Created by Peter Brooks on 11/1/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CONSTANTS.h"

#define flipTextPosition 5
#define matchAndMismatchTextPosition 6


@interface SetCardGameViewController ()
@end

@implementation SetCardGameViewController

// defaults
- (NSUInteger)startingCardCount { return 24; }
- (NSUInteger)NCardsMatchGame { return 3; }

// CardGame default overrides
- (NSUInteger)matchBonus { return 15; }
- (NSUInteger)mismatchPenalty { return 5; }
- (NSUInteger)flipCost { return 1; }
- (Deck *)createDeck { return [[SetCardDeck alloc] init]; }
- (NSString *)getGameName { return @"Set"; }


/*
Button and card statuses by button states (there are 3 button states):
 
 Normal (initial and no card selected): 
    Button: enabled = YES, selected = NO, alpha = 1.0, background = color, title = card content
    Card: faceup = NO, playable = YES
 
 Selected (selected but not complete match):
    Button: enabled = YES, selected = YES, alpha = 1.0, background = gray, title = card content
    Card: faceup = YES, playable = YES
 
 Selected and Disabled (complete match, no longer playable):
    Button: enabled = NO, selected = YES, alpha = 0.0, 
    Card: faceup = YES, playable = NO

Card.faceup and Card.playable is set in CardMatchingGame
*/

- (void)updateNormalButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    [cardButton.layer setBorderWidth:1.0];
    [cardButton.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [cardButton.layer setBackgroundColor:[[[UIColor cyanColor] colorWithAlphaComponent:.2] CGColor]];
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        // set up card color to be card color + shading
        CGFloat red, green, blue, alpha;
        [setCard.color getRed:&red green:&green blue:&blue alpha:&alpha];
        UIColor *colorWithShade = [UIColor colorWithRed:red green:green blue:blue alpha:setCard.shade];
        // set up attributed string dictionary
        NSMutableDictionary *titleAttributes = [[NSMutableDictionary alloc] init];
        [titleAttributes setObject:colorWithShade forKey:NSForegroundColorAttributeName];
        [titleAttributes setObject:[cardButton.titleLabel.font fontWithSize:10.0] forKey:NSFontAttributeName];
        // set up attributed string and set to title
        NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:setCard.contents];
        [titleString addAttributes:titleAttributes range:NSMakeRange(0,[setCard.contents length])];
        [cardButton setAttributedTitle:titleString forState:UIControlStateNormal];
    }
}

- (void)updateSelectedButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (card.isFaceUp)[cardButton.layer setBackgroundColor:[[UIColor lightGrayColor] CGColor]];
}

- (void)updateSelectedAndDisabledButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    // set selected and disabled state (matched) attributes
    if (card.isFaceUp && card.isUnplayable) [cardButton.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
}

- (void)updateAttributesForButton:(UIButton *)cardButton usingCard:(Card *)card {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    // set state
    cardButton.selected = card.isFaceUp;
    cardButton.enabled = !card.isUnplayable;
    cardButton.alpha = (card.isUnplayable ? 0.0 : 1.0); // if unplayable, then unseen! (alpha = 0)
}

//  method needs to have knowledge of label text coming in re: text positions. Could change to either have this method create messsage text or get attribute text location from calling method
// inputs - current card (last card being flipped) and the  match cards (first one or two cards flipped)
/*  1. Get text into attributed string      
    2. Create attribute dict        
    3. Add color and shade into dict        
    4. Update the string 
 
 Thsi method is a bit complex and confusing, could simplify, no time, want to keep on going :) */

-(void)formatResultsLabel:(NSString *)resultsLabelText forLabelType:(NSUInteger)labelType
         usingCurrentCard:(Card *)currentCard usingFirstTwoMatchCards:(NSArray *)matchCards forLabel:(UILabel *)resultsLabel {
    // position and length of items in label text string. Remember, current card is last card being flipped and the  match cards are the first one or two cards flipped
    int matchCard1Position = 0;
    int matchCard1Length = 0;
    int matchCard2Position = 0;
    int matchCard2Length = 0;
    int curCardPosition = 0;
    int curCardLength = [currentCard.contents length];
    CGFloat red, green, blue, alpha;
    // colors of each item
    UIColor *matchCard1Color;
    UIColor *matchCard2Color;
    UIColor *curCardColor;
    // if we get input variables, then figure out positions, colors, and lengths
    if ([currentCard isKindOfClass:[SetCard class]]) {
        SetCard *curCard = (SetCard *)currentCard;
        [curCard.color getRed:&red green:&green blue:&blue alpha:&alpha];
        curCardColor = [UIColor colorWithRed:red green:green blue:blue alpha:curCard.shade];
        if ([matchCards count] == 2) { // only with 3 cards up (current + 2 matchCards) can there be a match or mismatch
           if ([matchCards[0]isKindOfClass:[SetCard class]]) { // get attributes of 2 match cards
            SetCard *matchCard1 = (SetCard *)matchCards[0];
            SetCard *matchCard2 = (SetCard *)matchCards[1];
            [matchCard1.color getRed:&red green:&green blue:&blue alpha:&alpha];
            matchCard1Color = [UIColor colorWithRed:red green:green blue:blue alpha:matchCard1.shade];
            [matchCard2.color getRed:&red green:&green blue:&blue alpha:&alpha];
            matchCard2Color = [UIColor colorWithRed:red green:green blue:blue alpha:matchCard2.shade];
            matchCard1Length = [matchCard1.contents length];
            matchCard2Length = [matchCard2.contents length];
           }
        }
        NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:resultsLabelText];
        NSMutableDictionary *labelAttributes = [[NSMutableDictionary alloc] init];
        [labelAttributes setObject:[resultsLabel.font fontWithSize:10.0] forKey:NSFontAttributeName];
        [labelString addAttributes:labelAttributes range:NSMakeRange(0,[labelString length])];
        switch (labelType) {
            case FLIPLABEL: {  // it's only a flip, only attributed text is current card
                curCardPosition = flipTextPosition;
                [labelAttributes setObject:curCardColor forKey:NSForegroundColorAttributeName];
                break;
            }
            default: // either a match or mismatch
                if (labelType == MATCHLABEL) matchCard1Position = matchAndMismatchTextPosition;
                else matchCard1Position = matchAndMismatchTextPosition;
                matchCard1Position = matchAndMismatchTextPosition;
                //now we have the starting position, everthing else is the same
                [labelAttributes setObject:matchCard1Color forKey:NSForegroundColorAttributeName];
                [labelString addAttributes:labelAttributes range:NSMakeRange(matchCard1Position,matchCard1Length)];
                [labelAttributes setObject:matchCard2Color forKey:NSForegroundColorAttributeName];
                matchCard2Position = matchCard1Position + matchCard1Length + 2;
                [labelString addAttributes:labelAttributes range:NSMakeRange(matchCard2Position,matchCard2Length)];
                [labelAttributes setObject:curCardColor forKey:NSForegroundColorAttributeName];
                curCardPosition = matchCard2Position + matchCard2Length + 5;
                break;
        }
        [labelString addAttributes:labelAttributes range:NSMakeRange(curCardPosition,curCardLength)];
        [resultsLabel setAttributedText:labelString];
    }
}


@end
