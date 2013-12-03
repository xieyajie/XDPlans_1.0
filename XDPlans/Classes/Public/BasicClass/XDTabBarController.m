//
//  XDTabBarController.m
//  New
//
//  Created by yajie xie on 12-9-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDTabBarController.h"

#import "XDTableViewController.h"

#define KTabBarHeight 44

@interface XDTabBarController ()
{
    BOOL _tabBarHidden;
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *tabBar;

@property (nonatomic, strong) NSMutableArray *itemButtons;

@end

@implementation XDTabBarController

@synthesize currentSelectedIndex = _currentSelectedIndex;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _slideBg = [[UIView alloc] init];//选中时阴影层
        _slideBg.backgroundColor = [UIColor colorWithRed:109 / 255.0 green:60 / 255.0 blue:35 / 255.0 alpha:1.0];
        
        _currentSelectedIndex = -1;
        _tabBarHidden = NO;
    }
    return self;
}

- (void)loadView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, applicationFrame.size.width, applicationFrame.size.height)];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [view setBackgroundColor:[UIColor whiteColor]];
    self.view = view;
    
    [view addSubview:self.contentView];
    [view addSubview:self.tabBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGSize viewSize = self.view.frame.size;
    [self.tabBar setFrame:CGRectMake(0, viewSize.height - KTabBarHeight, viewSize.width, KTabBarHeight)];
    [self.contentView setFrame:CGRectMake(0, 0, viewSize.width, viewSize.height - KTabBarHeight)];
    
    [self selectedTabItem:[self.itemButtons objectAtIndex:0]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - getting

- (UIView *)contentView
{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    
    return _contentView;
}

- (UIView *)tabBar
{
    if (_tabBar == nil) {
        _tabBar = [[UIView alloc] initWithFrame: CGRectZero];
        _tabBar.backgroundColor = [UIColor colorWithRed:165 / 255.0 green:92 / 255.0 blue:50 / 255.0 alpha:1.0];
    }
    
    return _tabBar;
}

#pragma mark - setting

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = viewControllers;
        
        [self configurationTabbarItems];
    }
    else {
        _viewControllers = nil;
    }

}

#pragma mark - custom methods

- (void)configurationTabbarItems
{
    //创建按钮
    int viewCount = self.viewControllers.count > 5 ? 5 : self.viewControllers.count;
    self.itemButtons = [NSMutableArray arrayWithCapacity:viewCount];
    CGFloat width = 320.0 / viewCount;
    CGFloat height = KTabBarHeight;
    for (int i = 0; i < viewCount; i++)
    {
        UIViewController *viewController = [self.viewControllers objectAtIndex:i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        btn.tag = i;
        [btn setImage:viewController.tabBarItem.finishedUnselectedImage forState:UIControlStateNormal];
        [btn setImage:viewController.tabBarItem.finishedSelectedImage forState:UIControlStateSelected];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, 20, 0, 0)];
        
        [btn setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:255 / 255.0 green:254 / 255.0 blue:174 / 255.0 alpha:1.0] forState:UIControlStateSelected];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(25, -18, 0, 0)];
        
        [btn addTarget:self action:@selector(selectedTabItem:) forControlEvents: UIControlEventTouchUpInside];
        
        [self.itemButtons addObject:btn];
        [self.tabBar addSubview:btn];
    }
    
    [self.tabBar addSubview: _slideBg];
}

//切换滑块位置
- (void)slideTabItemBg:(UIButton *)button
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.20];
	[UIView setAnimationDelegate:self];
	_slideBg.frame = button.frame;
    [self.tabBar sendSubviewToBack:_slideBg];
    
	[UIView commitAnimations];
	CAKeyframeAnimation * animation; 
	animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"]; 
	animation.duration = 0.50; 
	animation.delegate = self;
	animation.removedOnCompletion = YES;
	animation.fillMode = kCAFillModeForwards;
	NSMutableArray *values = [NSMutableArray array];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]]; 
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]]; 
	[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
	animation.values = values;
	[button.layer addAnimation:animation forKey:nil];
}


- (void)selectedTabItem: (UIButton *)button
{
    if (self.currentSelectedIndex != button.tag)
    {
        if (self.currentSelectedIndex > -1) {
            UIButton *oldButton = [self.itemButtons objectAtIndex:self.currentSelectedIndex];
            oldButton.selected = NO;
            UIViewController *oldViewController = [self.viewControllers objectAtIndex: self.currentSelectedIndex];
            [oldViewController.view removeFromSuperview];
            [oldViewController removeFromParentViewController];
        }
        
        self.currentSelectedIndex = button.tag;
        button.selected = YES;
        
        UIViewController *viewController = [self.viewControllers objectAtIndex:button.tag];
        [self addChildViewController:viewController];
        viewController.view.frame = self.contentView.bounds;
        [self.view addSubview: viewController.view];
        [self.view bringSubviewToFront: self.tabBar];
        
        [self performSelector:@selector(slideTabItemBg:) withObject:button];
	}
}

#pragma mark - public

- (void)tabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (_tabBarHidden == hidden) {
        return;
    }
    
    _tabBarHidden = hidden;
    
    void (^block)() = ^{
        CGSize viewSize = self.view.frame.size;
        CGRect contentViewFrame = [self.contentView frame];
        CGRect tabBarFrame = [self.tabBar frame];
        
        if (hidden)
        {
            [self.tabBar setFrame:CGRectMake(CGRectGetMinX(tabBarFrame), viewSize.height, CGRectGetWidth(tabBarFrame), CGRectGetHeight(tabBarFrame))];
            [self.contentView setFrame:CGRectMake(CGRectGetMinX(contentViewFrame), CGRectGetMinY(contentViewFrame), CGRectGetWidth(contentViewFrame), viewSize.height)];
        }
        else {
            [self.tabBar setFrame:CGRectMake(CGRectGetMinX(tabBarFrame), viewSize.height - CGRectGetHeight(tabBarFrame), CGRectGetWidth(tabBarFrame), CGRectGetHeight(tabBarFrame))];
            [self.contentView setFrame:CGRectMake(CGRectGetMinX(contentViewFrame), CGRectGetMinY(contentViewFrame), CGRectGetWidth(contentViewFrame), viewSize.height - KTabBarHeight)];
        }
        
        UIViewController *viewController = [self.viewControllers objectAtIndex:self.currentSelectedIndex];
        viewController.view.frame = self.contentView.bounds;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.24 animations:^{
            block();
        }];
    } else {
        block();
    }
}

- (void)tabBarHidden:(BOOL)hidden
{
    [self tabBarHidden:hidden animated:NO];
}

@end
