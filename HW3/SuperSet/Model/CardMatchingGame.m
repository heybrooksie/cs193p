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

@property (readwrite,nonatomic) int             score;              // total score
@property (readwrite,nonatomic) int             incrementalScore;   // change in score when new card flipped up
@property (readwrite,nonatomic) BOOL            doCardsMatch;
@property (strong, nonatomic)   NSArray         *currentCard;       // of Card
@property (strong, nonatomic)   NSArray         *cardsThatMayMatchCurrentCard; // of Card
@property (strong,nonatomic)    NSMutableArray  *cards;             // of Card
@property (nonatomic)           int             NCardsMatchGame;    // e.g. 2 or 3
@property (nonatomic)           NSUInteger      matchBonus;
@property (nonatomic)           NSUInteger      mismatchPenalty;
@property (nonatomic)           NSUInteger      flipCost;
@property (strong,nonatomic)    Deck            *deck;              // deck itself

@end

@implementation CardMatchingGame

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck initWithMatchesInGame:(int)matchNcards usingMatchBonus:(NSUInteger)matchBonusIn usingMismatchPenalty:(NSUInteger)mismatchPenaltyIn usingFlipCost:(NSUInteger)flipCostIn; //designated initializer
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
        self.deck = deck;
        self.NCardsMatchGame = matchNcards;
        self.matchBonus =  matchBonusIn;
        self.mismatchPenalty = mismatchPenaltyIn;
        self.flipCost = flipCostIn;
        
    }
    return self;
}

// beginning of syntheses

- (NSMutableArray *)cards
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSUInteger)count
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return [self.cards count];
}

// end of syntheses

- (Card *)cardAtIndex:(NSUInteger)index
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)removeCardAtIndex:(NSUInteger)index
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    [self.cards removeObjectAtIndex:index];
}

- (NSUInteger)addCards:(NSUInteger)numberOfCards
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    // add the requested number of cards to the game. If no cards left in deck, break out of loop
    NSUInteger cardsAddedToGame = 0;        // number of cards that have been added to game
    int lastIndexInArray = [self count] - 1;    // last card array index # in the game, starts at 0 not 1
    for (int i = 1; i <= numberOfCards; i++) {
            Card *card = [self.deck drawRandomCard];
            if (card) {
                self.cards[lastIndexInArray + i] = card;
                cardsAddedToGame++;         // number of cards added (may reach end of deck)
            } else {
                break;                      // reached end of deck before all cards added
            }
    }
    return cardsAddedToGame;    // return # of cards actually added to deck, may be less than the request
}

- (void)flipCardAtIndex:(NSUInteger)index 
{
    /*SPECIFICATIONS / RULES
     - Flip up one card.
     - For two match game, flip up 2nd card. If match, becomes unplayable, if no match, first card is flipped back down
     - For three match game, flip up 2nd card. If no match, flip first card back down. If 2nd card match, flip up 3rd card. If no 3 card match, flip down first 2 cards. If all match, make all unplayable.
     - For all flip ups including matches - score includes flip cost.
     */
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
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
                if (matchScore && ([cardsToMatchCurrentCard count] == (self.NCardsMatchGame - 1))) { //match!
                    card.unplayable = YES;
                    for (Card *otherCard in cardsToMatchCurrentCard) otherCard.unplayable = YES;
                    self.doCardsMatch = YES;
                    self.incrementalScore = matchScore*self.matchBonus;
                    self.score += self.incrementalScore;
                } else {                    // either cards don't match or we have not finished.
                    if (!matchScore) {      // no matcch
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
