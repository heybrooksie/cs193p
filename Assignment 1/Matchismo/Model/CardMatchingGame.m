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
@property (readwrite,nonatomic) int incrementalScore;
@property (readwrite,nonatomic) BOOL doCardsMatch;
@property (strong, nonatomic) NSArray *currentCard; //of Card
@property (strong, nonatomic) NSArray *cardsThatMayMatchCurrentCard; //of Card
@property (strong,nonatomic) NSMutableArray *cards; //of Card
@property (nonatomic) int matchBonus; // change based on # of cards in game
@property (nonatomic) int mismatchPenalty; // change based on # of cards in game
@property (nonatomic) int cardsInGame2;
@property (nonatomic) int flipCost;

@end


@implementation CardMatchingGame

// beginning of syntheses


- (NSMutableArray *)cards
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

// beginning of syntheses

- (int)cardsInGame2
{
    //if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_cardsInGame2) _cardsInGame2 = 0;
    return _cardsInGame2;
}

- (int)matchBonus
{
    //if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_matchBonus) {
        switch (self.cardsInGame2) {
            case 2:
                self.matchBonus = 4;
                break;
            case 3:
                self.matchBonus = 4; // note score returns 8
                break;
            default:
                self.matchBonus = 0;
                break;
        }
    }
    return _matchBonus;
}

- (int)mismatchPenalty
{
    //if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_mismatchPenalty) {
        switch (self.cardsInGame2) {
            case 2:
                self.mismatchPenalty = 2;
                break;
            case 3:
                self.mismatchPenalty = 3;
                break;
            default:
                self.mismatchPenalty = 0;
                break;
        }
    }
    return _mismatchPenalty;
}

- (int)flipCost
{
    //if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_flipCost) _flipCost = 1;
    return _flipCost;
}

- (int)match
{
    //if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_score) _score = 0;
    return _score;
}

- (int)incrementalScore
{
    //if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_incrementalScore) _incrementalScore = 0;
    return _incrementalScore;
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

- (Card *)cardAtIndex:(NSUInteger)index
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index :(int)cardsInGame
{
    /*SPECIFICATIONS / RULES
     - Flip up one card.
     - For two match game, flip up 2nd card. If match, becomes unplayable, if no match, first card is flipped back down
     - For three match game, flip up 2nd card. If no match, flip first card back down. If 2nd card match, flip up 3rd card. If no 3 card match, flip down first 2 cards. If all match, make all unplayable.
     - For all flip ups including matches - score includes flip cost.
     */
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    self.cardsInGame2 = cardsInGame;                    //set bonuses and penalties
    Card *card = [self cardAtIndex:index];
    self.doCardsMatch = NO;
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            int matchScore = 0;
            self.incrementalScore = self.flipCost;
            NSMutableArray *cardsToMatchCurrentCard = [[NSMutableArray alloc] init]; // of Cards
            // this loop adds faceup cards to an array to that will be matched against the current card
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) [cardsToMatchCurrentCard addObject:otherCard];
            }
            // if here, all cards matched or there is a mismatch. If match, check if still more cards for user to flip up.
            if ([cardsToMatchCurrentCard count] >= 1) { // there is a card to match to current card
                matchScore = [card match:cardsToMatchCurrentCard];
                if (matchScore && ([cardsToMatchCurrentCard count] == (cardsInGame - 1))) { //match!
                    card.unplayable = YES;
                    for (Card *otherCard in cardsToMatchCurrentCard) otherCard.unplayable = YES;
                    self.doCardsMatch = YES;
                    self.incrementalScore = matchScore*self.matchBonus;
                    self.score += self.incrementalScore;
                } else { // either cards don't match or we have not finished.
                    if (!matchScore) { // no matcch
                        for (Card *otherCard in cardsToMatchCurrentCard) otherCard.faceUp = !otherCard.isFaceUp;
                        self.doCardsMatch = NO;
                        self.incrementalScore = -self.mismatchPenalty;
                        self.score += self.incrementalScore;
                    } else { // if here, keep on going (e.g. 2 card up that match in a 3 card game)
                        self.doCardsMatch = YES;
                    }
                }
            }
            self.cardsThatMayMatchCurrentCard = [cardsToMatchCurrentCard copy];
            self.currentCard = [NSArray arrayWithObject:card];
            if (self.incrementalScore == 0) self.incrementalScore = -self.flipCost;;
            self.score -= self.flipCost;
        }
        card.faceUp = !card.isFaceUp;       // this simply makes a facedown card to be faceup
    }
}

@end
