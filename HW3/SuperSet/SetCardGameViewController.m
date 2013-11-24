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
#import "SetCardCollectionViewCell.h"
#import "SetCardView.h"
#import "CardMatchingGame.h"
#import "CONSTANTS.h"

#define flipTextPosition 5
#define matchAndMismatchTextPosition 6


@interface SetCardGameViewController ()
@end

@implementation SetCardGameViewController

// this class defaults
- (NSUInteger)startingCardCount { return 12; }
- (NSUInteger)NCardsMatchGame { return 3; }
- (NSUInteger)numberOfCardsToAddToGame { return 3; }
- (NSString *)ResultsLabelInitialText { return @"Set is a three card game";}

// CardGame class overrides
- (NSUInteger)matchBonus { return 15; }
- (NSUInteger)mismatchPenalty { return 5; }
- (NSUInteger)flipCost { return 1; }
- (Deck *)createDeck { return [[SetCardDeck alloc] init]; }
- (NSString *)getGameName { return @"Set"; }


- (NSString *)flipText {return @"Card               flipped, for a cost of %d";}
- (NSString *)matchText {return @"match, %d points!";}
- (NSString *)mismatchText {return @"do not match, penalty of %d points";}

#pragma mark - Initialization

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.color = setCard.color;
            setCardView.symbol = setCard.symbol;
            setCardView.shade = setCard.shade;
            setCardView.numberOfSymbols = setCard.numberOfSymbols;
            if (setCard.faceUp) {
                UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(.5,.5,setCardView.bounds.size.width*0.4,setCardView.bounds.size.height*0.2)];
                labelView.backgroundColor = [UIColor clearColor];
                [labelView setFont:[UIFont fontWithName:labelView.font.fontName size: 13.0f]];
                labelView.text = @"✔";
                [setCardView addSubview:labelView];
            } else {
                for (UIView *subview in setCardView.subviews)
                {
                    [subview removeFromSuperview];
                }
            }
            setCardView.faceUp = setCard.isFaceUp;
        }
    }
}
- (UIView *)initializeResultsUsingView:(UIView *)view {
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width,                                                                       view.bounds.size.height)];
    [labelView setFont:[UIFont fontWithName:labelView.font.fontName size: 13.0f]];
    labelView.text = [self ResultsLabelInitialText];
    [labelView sizeToFit];
    [view addSubview:labelView];
    return view;
}

- (IBAction)add3Cards:(id)sender {
    NSUInteger numberOfCardsAddedToGame = [self.game addCards:[self numberOfCardsToAddToGame]]; // add cards to game
    if (numberOfCardsAddedToGame == [self numberOfCardsToAddToGame]) {
        // next lines find last UICollectionView indexpath and add the same # of cards that were added to game
        NSInteger lastSectionIndex = [self.cardCollectionView numberOfSections] - 1;    // secction #s start at 0
        NSInteger lastItemIndex = [self.cardCollectionView numberOfItemsInSection:lastSectionIndex] - 1;    // items start at 0
        NSMutableArray *newIndexPathsArray = [[NSMutableArray alloc] init];
        for (int i=1; i<= numberOfCardsAddedToGame; i++) {
            [newIndexPathsArray addObject:[NSIndexPath indexPathForItem:(lastItemIndex + i) inSection:lastSectionIndex]];
        }
        [self.cardCollectionView insertItemsAtIndexPaths:newIndexPathsArray];
        [self.cardCollectionView scrollToItemAtIndexPath:[newIndexPathsArray lastObject] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    } else {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Cards NOT Added To Game" message:@"No more cards in deck - Press the Deal button to start a new game." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (BOOL)deleteCardAtIndexPath:(NSIndexPath *)indexPath ofCollectionView:(UICollectionView *)view ofGame:(CardMatchingGame *)game {
    [game removeCardAtIndex:indexPath.item];    // remove card from game
    NSArray *deletedItemIndexPathArray = [NSMutableArray arrayWithObject:indexPath];            // get the indexpath of the deleted item
    [view deleteItemsAtIndexPaths:deletedItemIndexPathArray];   // remove UICollectionViewItem
    return YES;// it is a match
}

- (UIView *)showFlipResultsUsingView:(UIView *)view usingCard:(NSArray *)card {
    if ([card[0] isKindOfClass:[SetCard class]]) {
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width,                                                                       view.bounds.size.height)];
        labelView.backgroundColor=[UIColor clearColor];
        [labelView setFont:[UIFont fontWithName:labelView.font.fontName size: 10.0f]];
        SetCard *setCard = (SetCard *)card[0];
        CGFloat labelCardHeight = view.bounds.size.height * .9;
        CGFloat labelCardWidth = labelCardHeight * 64/87;
        SetCardView *setCardView = [[SetCardView alloc] initWithFrame:CGRectMake(24.0, 0.0, labelCardWidth, labelCardHeight)];
        [setCardView setBackgroundColor:[UIColor clearColor]];
        setCardView.numberOfSymbols = setCard.numberOfSymbols;
        setCardView.symbol = setCard.symbol;
        setCardView.shade = setCard.shade;
        setCardView.color = setCard.color;
        setCardView.faceUp = YES;
        [view addSubview:setCardView];
        [labelView setText:[NSString stringWithFormat:[self flipText],[self flipCost]]];
        [view addSubview:labelView];
    }
    return view;
}

- (UIView *)showMatchResultsUsingView:(UIView *)view usingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards {
    NSString *text = [NSString stringWithFormat:[self matchText],[self matchBonus]];
    NSArray *positionArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:40.0],[NSNumber numberWithFloat:80.0],nil];
    view = [self createMatchAndMismatchResultsUsingView:view usingCard:card usingMatchCards:matchCards usingText:text forPositions:positionArray];
    return view;
}

- (UIView *)showMismatchResultsUsingView:(UIView *)view usingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards {
    NSString *text = [NSString stringWithFormat:[self mismatchText],[self mismatchPenalty]];
    NSArray *positionArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:40.0],[NSNumber numberWithFloat:80.0],nil];
    view = [self createMatchAndMismatchResultsUsingView:view usingCard:card usingMatchCards:matchCards usingText:text forPositions:positionArray];
    return view;
}

- (UIView *)createMatchAndMismatchResultsUsingView:(UIView *)view usingCard:(NSArray *)card usingMatchCards:(NSArray *)matchCards usingText:(NSString *)textString forPositions:(NSArray *)positionArray {
    // add text to view
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, view.bounds.size.width,                                                                       view.bounds.size.height)];
    labelView.backgroundColor=[UIColor clearColor];
    [labelView setFont:[UIFont fontWithName:labelView.font.fontName size: 10.0f]];
    [labelView setText:[NSString stringWithFormat:textString,0]];
    [view addSubview:labelView];
    //add card images to view
    if ([card[0] isKindOfClass:[SetCard class]]) {
        CGFloat labelCardHeight = view.bounds.size.height * .9;
        CGFloat labelCardWidth = labelCardHeight * 64/87;
        for (int i=1;i<=3;i++) {    // show last card flipped last in results
            SetCard *setCard = nil;
            if (i == 3) {   
                setCard = (SetCard *)card[0];
            } else {
                setCard = (SetCard *)matchCards[i-1];
            }
            SetCardView *setCardView = [[SetCardView alloc] initWithFrame:CGRectMake([positionArray[i-1] floatValue], 0.0, labelCardWidth, labelCardHeight)];
            [setCardView setBackgroundColor:[UIColor clearColor]];
            setCardView.numberOfSymbols = setCard.numberOfSymbols;
            setCardView.symbol = setCard.symbol;
            setCardView.shade = setCard.shade;
            setCardView.color = setCard.color;
            setCardView.faceUp = YES;
            [view addSubview:setCardView];
        }
    }
    return view;
}

@end
