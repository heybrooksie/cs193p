//
//  PlayingCardGameViewController.m
//  Set
//
//  Created by Peter Brooks on 11/1/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCard.h"
#import "CONSTANTS.h"

@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController

- (NSUInteger)startingCardCount { return 22; }
- (NSUInteger)NCardsMatchGame { return 2; }
- (NSString *)ResultsLabelInitialText { return @"Playing Card is a two card game";}

- (Deck *)createDeck { return [[PlayingCardDeck alloc] init]; }
- (NSString *)getGameName { return @"PlayingCard"; }

- (NSString *)flipText {return @"Card %@ flipped, for a cost of %d";}
- (NSString *)matchText {return @"Cards %@ and %@ match, %d points!";}
- (NSString *)mismatchText {return @"Cards %@ and %@ do not match, penalty of %d points";}

/*
 Cell and Card statuses by states (there are 3 states):
 
 Normal (initial and no card selected):
 Cell shows cardback.png per PlayingCardView, alpha = 1.0
 Card: faceup = NO, playable = YES
 
 Selected (selected but not match):
 Cell shows cards face per PlayingCardView, alpha = 1.0
 Card: faceup = YES, playable = YES
 
 Selected and Disabled (complete match, no longer playable):
 Cell shows cards face per PlayingCardView, alpha = .3
 Card: faceup = YES, playable = NO
 
 Card.faceup and Card.playable is set in CardMatchingGame. Cell views created in PlayingCardView
 */
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (UIView *)initializeResultsUsingView:(UIView *)view {
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width,                                                                       view.bounds.size.height)];
    labelView.backgroundColor=[UIColor clearColor];
    [labelView setFont:[UIFont fontWithName:labelView.font.fontName size: 10.0f]];
    labelView.text = [self ResultsLabelInitialText];
    [view addSubview:labelView];
    return view;
}

- (UIView *)showFlipResultsUsingView:(UIView *)view usingCard:(NSArray *)card {
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width,                                                                       view.bounds.size.height)];
    labelView.backgroundColor=[UIColor clearColor];
    [labelView setFont:[UIFont fontWithName:labelView.font.fontName size: 10.0f]];
    if ([card[0] isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card[0];
        UIColor *cardColor = [[UIColor alloc] init];
        if ([playingCard.suit isEqualToString:@"♥"] || [playingCard.suit isEqualToString:@"♦"]) {
            cardColor = [UIColor redColor];
        } else {
            cardColor = [UIColor blackColor];
        }
        NSMutableDictionary *labelAttributes = [[NSMutableDictionary alloc] init];
        [labelAttributes setObject:cardColor forKey:NSForegroundColorAttributeName];

        NSString *labelString = [NSString stringWithFormat:[self flipText],playingCard.contents,[self flipCost]];
        NSMutableAttributedString *labelAttributedString = [[NSMutableAttributedString alloc] initWithString:labelString];
        [labelAttributedString addAttributes:labelAttributes range:NSMakeRange(5,2)];
        
        [labelView setAttributedText:labelAttributedString];
    }
    [view addSubview:labelView];
    return view;
}

- (UIView *)showMatchResultsUsingView:(UIView *)view usingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards {
    view = [self createMatchAndMismatchResultsUsingView:view usingCard:card usingMatchCards:matchCards usingText:[self matchText] forRange1:NSMakeRange(6,2) forRange2:NSMakeRange(13,2)];
    return view;
}

- (UIView *)showMismatchResultsUsingView:(UIView *)view usingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards {
    view = [self createMatchAndMismatchResultsUsingView:view usingCard:card usingMatchCards:matchCards usingText:[self mismatchText] forRange1:NSMakeRange(6,2) forRange2:NSMakeRange(13,2)];
    return view;
}

- (UIView *)createMatchAndMismatchResultsUsingView:(UIView *)view usingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards usingText:(NSString *)textString forRange1:(NSRange)range1 forRange2:(NSRange)range2 {
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width,                                                                       view.bounds.size.height)];
    labelView.backgroundColor=[UIColor clearColor];
    [labelView setFont:[UIFont fontWithName:labelView.font.fontName size: 10.0f]];
    if ([card[0] isKindOfClass:[PlayingCard class]] && [matchCards[0] isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card[0];
        PlayingCard *matchCard = (PlayingCard *)matchCards[0];
        UIColor *playingCardColor = [[UIColor alloc] init];
        UIColor *matchCardColor = [[UIColor alloc] init];
        if ([playingCard.suit isEqualToString:@"♥"] || [playingCard.suit isEqualToString:@"♦"]) {
            playingCardColor = [UIColor redColor];
        } else {
            playingCardColor = [UIColor blackColor];
        }
        if ([matchCard.suit isEqualToString:@"♥"] || [matchCard.suit isEqualToString:@"♦"]) {
            matchCardColor = [UIColor redColor];
        } else {
            matchCardColor = [UIColor blackColor];
        }NSMutableDictionary *labelAttributes = [[NSMutableDictionary alloc] init];
        NSString *labelString = [NSString stringWithFormat:textString,matchCard.contents,playingCard.contents,[self mismatchPenalty]];
        NSMutableAttributedString *labelAttributedString = [[NSMutableAttributedString alloc] initWithString:labelString];
        [labelAttributes setObject:matchCardColor forKey:NSForegroundColorAttributeName];
        [labelAttributedString addAttributes:labelAttributes range:range1];
        [labelAttributes setObject:playingCardColor forKey:NSForegroundColorAttributeName];
        [labelAttributedString addAttributes:labelAttributes range:range2];
        [labelView setAttributedText:labelAttributedString];
    }
    [view addSubview:labelView];
    return view;
  
}

@end
