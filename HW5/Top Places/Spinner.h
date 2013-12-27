//
//  Spinner.h
//  Top Places
//
//  Created by Peter Brooks on 12/23/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Spinner : NSObject

+ (UIActivityIndicatorView *)start:(UIView *)view;
+ (void) stop:(UIActivityIndicatorView *)spinner;

@end
