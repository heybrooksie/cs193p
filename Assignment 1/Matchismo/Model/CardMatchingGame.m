//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Peter Brooks on 10/8/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "CardMatchingGame.h"
#import "CONSTANTS.h"

@interface CardMatchingGame()

@property (readwrite,nonatomic) int score;
@property (readwrite,nonatomic) NSString *results;
@property (strong,nonatomic) NSMutableArray *cards; //of Card 

@end


@implementation CardMatchingGame

// beginning of syntheses

- (NSMutableArray *)cards
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}
// end of syntheses

//designmated initializer
- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck;

{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}
// end of initializers

- (Card *)cardAtIndex:(NSUInteger)index {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define TWO_CARD_MATCH_BONUS 4
#define TWO_CARD_MISMATCH_PENALTY 2
#define THREE_CARD_MATCH_BONUS 8
#define THREE_CARD_MISMATCH_PENALTY 4
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index :(int)cardsInGame {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    Card *card = [self cardAtIndex:index];
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            if (cardsInGame == 2) {
                for (Card *otherCard in self.cards) {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            card.unplayable = YES;
                            otherCard.unplayable = YES;
                            self.score += matchScore * TWO_CARD_MATCH_BONUS;
                            self.results = [NSString stringWithFormat:@"Matched %@ and %@ for %d points",card.contents,otherCard.contents,matchScore * TWO_CARD_MATCH_BONUS];
                        } else {
                            otherCard.faceUp = NO;
                            self.score -= TWO_CARD_MISMATCH_PENALTY;
                            self.results = [NSString stringWithFormat:@"Mismatched %@ and %@ for %d point penalty",card.contents,otherCard.contents,TWO_CARD_MISMATCH_PENALTY];
                        }
                        break;
                    } else {
                        self.results = [NSString stringWithFormat:@"Flipped up %@ (-%d points)",card.contents,FLIP_COST];
                    }
                }
            } else { // three card play
                /* 
                SPECIFICATIONS / RULES
                 
                - Flip up one card.
                - Flip up 2nd card. If match, keep on going. If no match, 3 card match penalty.
                - Flip up 3rd card. If all 3 match, all 3 become unplayable. score = 3 card match score. If all 3 do not match, last card flipped stays face up, others go face down. score = 3 card match penalty.
                - For all flips including matches - score includes flip cost.
                */
                NSUInteger numberOfCardsFUP = 1; // init with current card
                NSUInteger numberOfCardsMatching = 1; // init with current card
                Card *secondCardFaceUp;
                Card *thirdCardFaceUp;
                int matchScore = 0;
                self.results = @"";
                // go through cards, set up # (FUP = Faceup) cards, # matches, all FUP cards
                for (Card *otherCard in self.cards) {
                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                        numberOfCardsFUP++; // we found a faceup and playable car
                        if (numberOfCardsFUP == 2) { // just found 2nd FUP card
                            secondCardFaceUp = otherCard; // save 2nd FUP card
                            matchScore = [card match:@[secondCardFaceUp]];
                            if (matchScore) { // do the 2 cards match?
                                numberOfCardsMatching++;
                                self.results = [NSString stringWithFormat:@"Flipped %@, matched with %@, flip cost of -%d",card.contents,secondCardFaceUp.contents,FLIP_COST];
                            } else {
                                self.score -= matchScore * THREE_CARD_MISMATCH_PENALTY;
                                self.results = [NSString stringWithFormat:@"Mismatched %@, and %@ for %d point penalty",card.contents,secondCardFaceUp.contents,TWO_CARD_MISMATCH_PENALTY];
                                secondCardFaceUp.faceUp = !secondCardFaceUp.isFaceUp;
                                NSLog(@"#4 2nd card contents = %@, FU = %d",secondCardFaceUp.contents,secondCardFaceUp.faceUp);
                            }
                        } else { // just found 3rd FUP card
                            thirdCardFaceUp = otherCard; // save 3rd FUP card
                            if ((numberOfCardsMatching == 2) &&
                                [card match:@[secondCardFaceUp]] && [card match:@[thirdCardFaceUp]]) { // if all three cards match
                                numberOfCardsMatching++;
                                self.score += matchScore * THREE_CARD_MATCH_BONUS; // matchscore set based on last match which is OK
                                self.results = [NSString stringWithFormat:@"Matched %@, %@, and %@ for %d points",card.contents,secondCardFaceUp.contents,thirdCardFaceUp.contents,matchScore * THREE_CARD_MATCH_BONUS];
                                card.unplayable = YES;
                                thirdCardFaceUp.unplayable = YES;
                                secondCardFaceUp.unplayable = YES;
                            } else { // if here, 3 cards FUP but no 3 card match so it is a 2 card match
                                self.score -= (THREE_CARD_MISMATCH_PENALTY);
                                self.results = [NSString stringWithFormat:@"Mismatched %@, %@, and %@ for %d point penalty",card.contents,secondCardFaceUp.contents,thirdCardFaceUp.contents,THREE_CARD_MISMATCH_PENALTY];
                                if (secondCardFaceUp.isFaceUp) secondCardFaceUp.faceUp = !secondCardFaceUp.isFaceUp;
                                thirdCardFaceUp.faceUp = !thirdCardFaceUp.isFaceUp;
                            }
                        }
                    }  else { // not isFaceUp and !isUnPlayable
                        if ([self.results isEqualToString:@""]) self.results = [NSString stringWithFormat:@"Flipped up %@ (-%d points)",card.contents,FLIP_COST];
                    }
                    if (numberOfCardsMatching == 3) break;
                } // end of for loop
            } // end of 3 card play
            self.score -= FLIP_COST;
        } //end of card isFaceU
        card.faceUp = !card.isFaceUp;
    } // end of card and !cardIsUnplayable
}

@end
