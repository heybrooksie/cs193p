//
//  Card.h
//  Matchismo
//
//  Created by Peter Brooks on 9/24/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic)                   NSString    *contents; // what's on the card
// state of card
@property (nonatomic, getter = isFaceUp)        BOOL        faceUp;
@property (nonatomic, getter = isUnplayable)    BOOL        unplayable;

- (int)match:(NSArray *)otherCards; // returns 0 if no match else a # based on match difficulty

@end
