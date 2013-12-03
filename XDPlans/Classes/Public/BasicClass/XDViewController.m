//
//  XDViewController.m
//  XDUI
//
//  Created by xieyajie on 13-10-14.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDViewController.h"

#import "UINavigationItem+Category.h"

@interface XDViewController ()
{
    CGFloat _version;
}

@end

@implementation XDViewController

@synthesize originY = _originY;
@synthesize sizeHeight = _sizeHeight;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _version = [[[UIDevice currentDevice] systemVersion] floatValue];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:227 / 255.0 blue:213 / 255.0 alpha:1.0];
    
    _originY = 0;
    _sizeHeight = [[UIScreen mainScreen] bounds].size.height - 20;
    
    if (!self.navigationController.navigationBarHidden) {
        _sizeHeight -= self.navigationController.navigationBar.frame.size.height;
    }
    else{
        _originY = 20;
    }
    
    if(_version >= 7.0)
    {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.wantsFullScreenLayout = NO;
//        self.extendedLayoutIncludesOpaqueBars = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setting

//navigationBar title
- (void)setTitle:(NSString *)title
{
    [self.navigationItem setCustomTitle:title];
}

- (void)setBackItem
{
    [self.navigationItem setBackItemWithTarget:self action:kSELECTOR_BACK];
}

#pragma mark - navigationbar item

- (void)back:(id)sender
{
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else if ([self respondsToSelector:@selector(dismissModalViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - getting

- (CGFloat)originY
{
    return _originY;
}

- (CGFloat)sizeHeight
{
    return _sizeHeight;
}

@end
