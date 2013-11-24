//
//  SetCardView.h
//  SuperSet
//
//  Created by Peter Brooks on 11/9/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong,nonatomic)    NSNumber    *color;
@property (strong,nonatomic)    NSNumber    *symbol;
@property (strong,nonatomic)    NSNumber    *shade;
@property (strong,nonatomic)    NSNumber    *numberOfSymbols;
@property (nonatomic)           BOOL        faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;
@end
 