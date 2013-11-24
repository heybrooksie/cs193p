//
//  PlayingCardCollectionViewCell.h
//  SuperSet
//
//  Created by Peter Brooks on 11/6/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
