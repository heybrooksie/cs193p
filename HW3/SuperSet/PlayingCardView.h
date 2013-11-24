//
//  PlayingCardView.h
//  SuperSet
//
//  Created by Peter Brooks on 11/6/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic)           NSUInteger  rank;
@property (strong, nonatomic)   NSString    *suit;
@property (nonatomic)           BOOL        faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
