//
//  ViewHere are the features:
//  Top Places
//
//  Created by Peter Brooks on 12/9/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//
#import "ViewController.h"
#import "Spinner.h"
#import "CONSTANTS.h"

@interface ViewController ()    <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UIImage *image;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}
- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        if (self.imageURL) {
            UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc] init];
            spin = [Spinner start:self.view];   // start the spinner
            dispatch_queue_t fetchQ = dispatch_queue_create("getURL queue", NULL);
            dispatch_async(fetchQ, ^{
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Spinner stop:spin];
                    self.image = [UIImage imageWithData:imageData];
                    if (self.image) {
                        self.scrollView.zoomScale = 1.0;
                        self.imageView.image = self.image;
                        self.imageView.frame = self.scrollView.bounds;
                        CGFloat widthRatio  = self.scrollView.bounds.size.width  / self.imageView.bounds.size.width;
                        CGFloat heightRatio = self.scrollView.bounds.size.height / self.imageView.bounds.size.height;
                        if (widthRatio > heightRatio) {
                            self.scrollView.zoomScale = widthRatio;
                        } else {
                            self.scrollView.zoomScale = heightRatio;
                        }
                    }
                });
            });
        }
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - UISplitViewControllerDelegate

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
