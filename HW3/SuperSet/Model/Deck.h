//
//  Deck.h
//  Matchismo
//
//  Created by Peter Brooks on 9/24/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL) atTop;
- (Card *)drawRandomCard;



@end
