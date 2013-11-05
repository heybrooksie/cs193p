//
//  PlayingCardGameViewController.m
//  Set
//
//  Created by Peter Brooks on 11/1/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CONSTANTS.h"

@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController

- (NSUInteger)startingCardCount { return 16; }
- (NSUInteger)NCardsMatchGame { return 2; }
- (Deck *)createDeck { return [[PlayingCardDeck alloc] init]; }
- (NSString *)getGameName { return @"PlayingCard"; }

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)updateNormalButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    [cardButton setImageEdgeInsets:UIEdgeInsetsMake(0, 1.0, 0.0, 0.0)];
    [cardButton setImage:[UIImage imageNamed:@"cardback.png"] forState:UIControlStateNormal];
}

- (void)updateSelectedButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    // set selected state (face up but not yet matched) attributes
    [cardButton setTitle:@"" forState:UIControlStateSelected];
    [cardButton setImage:[[UIImage alloc]init] forState:UIControlStateSelected];
    [cardButton setTitle:card.contents forState:UIControlStateSelected];
}

- (void)updateSelectedAndDisabledButtonStateForButton:(UIButton *)cardButton usingCard:(Card *)card {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    // set selected and disabled state (matched) attributes
    [cardButton setImage:[[UIImage alloc]init] forState:UIControlStateSelected| UIControlStateDisabled];
    [cardButton setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
}

- (void)updateAttributesForButton:(UIButton *)cardButton usingCard:(Card *)card {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    // set state
    cardButton.selected = card.isFaceUp;
    cardButton.enabled = !card.isUnplayable;
    cardButton.alpha = (card.isUnplayable ? 0.3 : 1.0);
}

@end
