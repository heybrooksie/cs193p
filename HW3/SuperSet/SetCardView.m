//
//  SetCardView.m
//  SuperSet
//
//  Created by Peter Brooks on 11/9/13.
//  Copyright (c) 2013 Peter Brooks. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SetCardView.h"
#import "CONSTANTS.h"

@interface SetCardView()
@property (nonatomic) CGFloat faceCardScaleFactor;
@property (nonatomic) CGFloat figureWidth;
@property (nonatomic) CGFloat figureHeight;
@end


@implementation SetCardView

#pragma mark - Properties

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
#define SYMBOL_HEIGHT_SCALE_FACTOR .2    // height of figure as a % of view height
#define SYMBOL_WIDTH_SCALE_FACTOR .65      // width of figure as a % of view width


- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (CGFloat)figureWidth
{
    if (!_figureWidth) _figureWidth = self.bounds.size.width*SYMBOL_WIDTH_SCALE_FACTOR;
    return _figureWidth;
}

- (CGFloat)figureHeight
{
    if (!_figureHeight) _figureHeight = self.bounds.size.height*SYMBOL_HEIGHT_SCALE_FACTOR;
    return _figureHeight;
}

- (void)setColor:(NSNumber *)color{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSNumber *)symbol{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setNumberOfSymbols:(NSNumber *)numberOfSymbols{
    _numberOfSymbols = numberOfSymbols;
    [self setNeedsDisplay];
}

- (void)setShade:(NSNumber *)shade{
    _shade = shade;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_RADIUS 12.0

- (void)drawRect:(CGRect)rect {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    // draw card outline
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    [roundedRect addClip];
    /*if (self.faceUp == NO) {
        [[UIColor whiteColor] setFill];
    } else {
        [[UIColor grayColor] setFill];
    }*/
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    // draw card symbols
    [self drawSymbols];
}

- (void)drawSymbols {
    [[self getUIColorFromColorCode:self.color] setStroke];  // set line color
    [[self getUIColorFromShadeCode:self.shade usingLineColor:(UIColor *)[self getUIColorFromColorCode:self.color]] setFill];    // set fill color
    /* height of first figure = center - (1/2 * height of # of figures) - (1/2 height of # of intervals)
     intervals are 1/2 figure height and there are 1 less intervals than # of figures*/
    UIBezierPath *aPath = [self drawSymbol:self.symbol]; // draw one figure
    UIBezierPath *bPath = [self drawShadingFromShadeCode:self.shade usingPathWidth:(self.bounds.size.width*SYMBOL_WIDTH_SCALE_FACTOR) usingPathHeight:self.bounds.size.height*SYMBOL_HEIGHT_SCALE_FACTOR];// draw one shading
    CGFloat i = [self.numberOfSymbols floatValue];
    CGFloat drawHeightPosition = (self.bounds.size.height/2.0-self.figureHeight/2.0*i - self.figureHeight/4.0*(i-1.0));
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    // I did this loop to draw multiple symbols, I see most people used a transform
    for (int i=1; i<=[self.numberOfSymbols intValue]; i++) {    // for each figure
        CGContextSaveGState(aRef);
        CGContextTranslateCTM(aRef,self.bounds.size.width/2.0-self.figureWidth/2.0, drawHeightPosition );  // get the figure position
        [aPath fill];   //aPath is figure
        [aPath stroke];
        [aPath addClip];
        [bPath fill];   //bPath is shading
        [bPath stroke];
        CGContextRestoreGState(aRef);
        drawHeightPosition = drawHeightPosition + self.figureHeight + self.figureHeight/2.0; // calc the new figure position from first figure position
    }
}

- (UIBezierPath *)drawSymbol:(NSNumber *)cardSymbol {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    switch ([cardSymbol intValue]) {
        case diamond: {
            aPath = [self drawDiamond];
            break;
        }
        case oval: {
            aPath = [self drawOval];
            break;
        }
        case squiqqle: {
            aPath = [self drawSquiggle];
            break;
        }
        default: { // should never happen
            break;
        }
    }
    return aPath;
}
#define SQIGGLE_SCALE_X .85 
#define SQIGGLE_SCALE_Y .8 
#define SIZE_OF_OVAL_CURVE 10

// THANKS to KULJA for drawing sqiggles
-(UIBezierPath *)drawSquiggle {
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    //aPath.lineWidth = LINE_WIDTH;
    CGPoint middle = CGPointMake(self.figureWidth/2, self.figureHeight/2);
    CGPoint start = CGPointMake(middle.x + (middle.x * SQIGGLE_SCALE_X), middle.y - (middle.y * SQIGGLE_SCALE_Y));
    [aPath moveToPoint:start];
    [aPath addQuadCurveToPoint:CGPointMake(start.x, middle.y + (middle.y * SQIGGLE_SCALE_Y)) controlPoint:CGPointMake(start.x + SIZE_OF_OVAL_CURVE, middle.y)];
    [aPath addCurveToPoint:CGPointMake(middle.x - (middle.x * SQIGGLE_SCALE_X), middle.y + (middle.y * SQIGGLE_SCALE_Y)) controlPoint1:CGPointMake(middle.x, middle.y + (middle.y * SQIGGLE_SCALE_Y) + (middle.y * SQIGGLE_SCALE_Y)) controlPoint2:CGPointMake(middle.x, middle.y)];
    [aPath addQuadCurveToPoint:CGPointMake(middle.x - (middle.x * SQIGGLE_SCALE_X), start.y) controlPoint:CGPointMake(middle.x - (middle.x * SQIGGLE_SCALE_X) - SIZE_OF_OVAL_CURVE, middle.y)];
    [aPath addCurveToPoint:CGPointMake(start.x, start.y) controlPoint1:CGPointMake(middle.x, middle.y - (middle.y * SQIGGLE_SCALE_Y) - (middle.y * SQIGGLE_SCALE_Y)) controlPoint2:CGPointMake(middle.x, middle.y)];
    [aPath closePath];
    return aPath;
}

-(UIBezierPath *)drawDiamond {
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    //aPath.lineWidth = LINE_WIDTH;
    [aPath moveToPoint:CGPointMake(self.figureWidth/2, 0)];
    [aPath addLineToPoint:CGPointMake(self.figureWidth,self.figureHeight/2)];
    [aPath addLineToPoint:CGPointMake(self.figureWidth/2,self.figureHeight)];
    [aPath addLineToPoint:CGPointMake(0,self.figureHeight/2)];
    [aPath closePath];
    return aPath;
}

#define DEGREES_TO_RADIANS(degrees) (M_PI * degrees)/ 180

-(UIBezierPath *)drawOval {
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    //aPath.lineWidth = LINE_WIDTH;
    CGFloat sideRadius = self.figureHeight/2.0; // .5 of height
    [aPath moveToPoint:CGPointMake(sideRadius,0)];
    [aPath addLineToPoint:CGPointMake(self.figureWidth-sideRadius, 0.0)];
    [aPath addArcWithCenter:CGPointMake(self.figureWidth-sideRadius,self.figureHeight/2.0) radius:sideRadius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(90) clockwise:YES];
    [aPath addLineToPoint:CGPointMake(sideRadius,self.figureHeight)];
    [aPath addArcWithCenter:CGPointMake(sideRadius, self.figureHeight/2.0) radius:sideRadius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
    [aPath closePath];
    return aPath;
}

#define STRIPE_WIDTH 1.0
#define STRIPE_GAP 3.0

// THANKS to DOMINIC HEALE for drawing stripes shading
-(UIBezierPath *)drawShadingFromShadeCode:(NSNumber *)shadeCode usingPathWidth:(CGFloat)width usingPathHeight:(CGFloat)height {
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    if ([shadeCode intValue] == striped) {
        [bPath moveToPoint:CGPointMake(-height/2,height/2)];
        bPath.lineWidth = height;
        float pattern[2]  = {STRIPE_WIDTH, STRIPE_GAP};
        bPath.lineWidth = height;
        [bPath setLineDash:pattern count:2.0 phase:2.0];
        [bPath addLineToPoint:CGPointMake(width+height/2,height/2)];
    }
    return bPath;
}

- (void)pushContextAndRotateUpsideDown
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (UIColor *)getUIColorFromColorCode:(NSNumber *)cardColor {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    UIColor *cardUIColor;
    switch ([cardColor intValue]) {
        case red: {
            cardUIColor = [UIColor redColor];
            break;
        }
        case green: {
            cardUIColor = [UIColor greenColor];
            break;
        }
        case purple: {
            cardUIColor = [UIColor purpleColor];
            break;
        }
        default: { // should never happen
            cardUIColor = [UIColor blackColor];
            break;
        }
    }
    return cardUIColor;
}


- (UIColor *)getUIColorFromShadeCode:(NSNumber *)cardShade usingLineColor:(UIColor *)lineColor {
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    UIColor *cardUIShade;
    switch ([cardShade intValue]) {
        case solid: {
            cardUIShade = lineColor;
            break;
        }
        case striped: {
            cardUIShade = [UIColor clearColor];
            break;
        }
        case open: {
            cardUIShade = [UIColor clearColor];
            break;
        }
        default: { // should never happen
            cardUIShade = [UIColor grayColor];
            break;
        }
    }
    return cardUIShade;
}

#pragma mark - Gesture Handlers

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if (LOG_MESSAGES) NSLog(@"START %s", __PRETTY_FUNCTION__);
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1;
    }
}


@end
