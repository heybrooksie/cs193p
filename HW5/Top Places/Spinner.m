//
//  Spinner.m
//  Top Places
//
//  Created by Peter Brooks on 12/23/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import "Spinner.h"

@implementation Spinner

+ (void) stop:(UIActivityIndicatorView *)spinner {
    [spinner stopAnimating];

}

+ (UIActivityIndicatorView *)start:(UIView *)view {
    UIActivityIndicatorView *spinner =[[UIActivityIndicatorView alloc]
                                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGFloat spinnerHeight = spinner.frame.size.height;
    spinner.center = CGPointMake(view.frame.size.width/2,(view.frame.size.height/2-spinnerHeight*2));
    spinner.hidesWhenStopped = YES;
    [view addSubview:spinner];
    [spinner startAnimating];
    return spinner;
}
@end
