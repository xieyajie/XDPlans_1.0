//
//  XDSummaryView.h
//  XDPlans
//
//  Created by xieyajie on 13-9-26.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDSummaryViewDelegate;

@interface XDSummaryView : UIView

@property (nonatomic, unsafe_unretained) id<XDSummaryViewDelegate> delegate;

@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, strong) UILabel *faceTitleLabel;

@property (nonatomic) NSString *key;
@property (nonatomic) NSInteger index;

@end

@protocol XDSummaryViewDelegate <NSObject>

@required
- (void)summaryView:(XDSummaryView *)summaryView didSelectedAtIndex:(NSInteger)index;

@end
