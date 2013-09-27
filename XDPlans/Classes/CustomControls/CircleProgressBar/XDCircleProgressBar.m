//
//  XDCircleProgressBar.m
//  XDPlans
//
//  Created by xieyajie on 13-9-27.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDCircleProgressBar.h"

@implementation XDCircleProgressBar

@synthesize color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGFloat floatPercent = _oldPercent / 100.0;
    floatPercent = MIN(1, MAX(0, floatPercent));
    CGFloat delta = toRadians(360 * floatPercent);
    
    CGContextSetFillColorWithColor(ctx, self.color.CGColor);
    CGContextSetLineWidth(ctx, 1);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRelativeArc(path, NULL, center.x, center.y, _innerRadius, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, _outerRadius, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y - _innerRadius);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CFRelease(path);
}

-(void)layoutSubviews
{
    _percentLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _innerRadius = self.frame.size.width / 2 - 15;
    _outerRadius = self.frame.size.width / 2 - 10;
    
    [super layoutSubviews];
}


#pragma mark - subviews

- (void)setup
{
    _animating = NO;
    _percentValue = 0.0;
    _oldPercent = 0.0;
    
    _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_percentLabel setFont:[UIFont fontWithName:@"Futura-CondensedMedium" size:10]];
    [_percentLabel setTextColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0]];
    [_percentLabel setTextAlignment:KTextAlignmentCenter];
    [_percentLabel setBackgroundColor:[UIColor clearColor]];
    _percentLabel.adjustsFontSizeToFitWidth = YES;
    _percentLabel.text = @"0%";
    [self addSubview:_percentLabel];
}

#pragma mark - Drawing/Animation methods

-(void)delayedDraw:(NSNumber *)newPercentage
{
    _animating = YES;
    int perc = [newPercentage intValue];
    if (perc < _percentValue)
    {
        perc++;
    }
    else {
        perc--;
    }
    _oldPercent = perc;
    [self setNeedsLayout];
    
    if (perc != _percentValue)
    {
        [self performSelector:@selector(delayedDraw:) withObject:[NSNumber numberWithInteger:perc] afterDelay:.001];
    }
    else
    {
        _animating = NO;
    }
}

#pragma mark - getting

- (UIColor *)color
{
    if (_oldPercent > 0 && _oldPercent < 26) {
        return [UIColor purpleColor];
    }
    
    if (_oldPercent > 25 && _oldPercent < 51) {
        return [UIColor cyanColor];
    }
    
    if (_oldPercent > 50 && _oldPercent < 76) {
        return [UIColor greenColor];
    }
    
    if (_oldPercent > 75 && _oldPercent < 101) {
        return [UIColor redColor];
    }
    
    return [UIColor colorWithRed:99/256.0 green:183/256.0 blue:70/256.0 alpha:.5];
}

#pragma mark - setting

- (void)setPercentValue:(NSInteger)value
{
    [self setPercent:value animated:NO];
}

#pragma mark - public

- (void)setPercent:(NSInteger)percent animated:(BOOL)animated
{
     percent = MIN(100, MAX(0, percent));
    
    if (_percentValue != percent) {
        _percentValue = percent;
        _percentLabel.text = [NSString stringWithFormat:@"%i%%", _percentValue];
        
        if (animated) {
            [self performSelector:@selector(delayedDraw:) withObject:[NSNumber numberWithInteger:_oldPercent] afterDelay:.001];
        }
        else {
            _oldPercent = _percentValue;
            [self setNeedsLayout];
        }
    }
}

@end
