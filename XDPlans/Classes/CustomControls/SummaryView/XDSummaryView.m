//
//  XDSummaryView.m
//  XDPlans
//
//  Created by xieyajie on 13-9-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDSummaryView.h"

@implementation XDSummaryView

@synthesize delegate = _delegate;

@synthesize faceButton = _faceButton;
@synthesize faceTitleLabel = _faceTitleLabel;

@synthesize key = _key;
@synthesize index = _index;

//- (id)init
//{
//    self = [self initWithFrame:CGRectZero];
//    if (self) {
//        //
//    }
//    
//    return self;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _faceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 3 * 2)];
        _faceButton.contentMode = UIViewContentModeScaleAspectFit;
        _faceButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _faceButton.backgroundColor = [UIColor clearColor];
        [_faceButton addTarget:self action:@selector(faceAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_faceButton];
        
        _faceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _faceButton.frame.origin.y + _faceButton.frame.size.height, self.frame.size.width, self.frame.size.height / 3)];
        _faceTitleLabel.backgroundColor = [UIColor clearColor];
        _faceTitleLabel.textAlignment = KTextAlignmentCenter;
        _faceTitleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_faceTitleLabel];
        
        self.layer.borderColor = [[UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0] CGColor];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _faceButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 3 * 2);
    _faceTitleLabel.frame = CGRectMake(0, _faceButton.frame.origin.y + _faceButton.frame.size.height, self.frame.size.width, self.frame.size.height / 3);
}

- (void)faceAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(summaryView:didSelectedAtIndex:)]) {
        [_delegate summaryView:self didSelectedAtIndex:_index];
    }
    else{
        self.layer.borderColor = [[UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0] CGColor];
        self.layer.borderWidth = 2.0;
        
        self.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    }
}

@end
