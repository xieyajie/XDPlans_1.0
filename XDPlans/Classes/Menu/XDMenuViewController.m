//
//  XDMenuViewController.m
//  XDPlans
//
//  Created by xie yajie on 13-9-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDMenuViewController.h"

#import "JASidePanelController.h"
#import "XDAccountLoginViewController.h"
#import "XDDayPlanViewController.h"
#import "XDAllPlansViewController.h"
#import "XDActionPlanViewController.h"
#import "XDSettingViewController.h"
#import "XDMenuCell.h"

#import "XDPlanLocalDefault.h"

#define KMENU_TITLE @"title"
#define KMENU_NORMOLICON @"icon_normal"
#define KMENU_SELECTEDICON @"icon_selected"

@interface XDMenuViewController ()
{
    NSMutableArray *_dataSource;
    UIView *_headerView;
    UIButton *_headerButton;
    UILabel *_nameLabel;
    
    NSInteger _selectedRow;
}

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UINavigationController *accountNC;
@property (nonatomic, strong) UINavigationController *allPlansNC;
@property (nonatomic, strong) UINavigationController *actionPlanNC;
@property (nonatomic, strong) UINavigationController *todayPlanNC;
@property (nonatomic, strong) UINavigationController *settingNC;

@end

@implementation XDMenuViewController

@synthesize headerView = _headerView;

@synthesize accountNC = _accountNC;
@synthesize allPlansNC = _allPlansNC;
@synthesize actionPlanNC = _actionPlanNC;
@synthesize todayPlanNC = _todayPlanNC;
@synthesize settingNC = _settingNC;


- (id)initWithStyle:(UITableViewStyle)style selectedIndex:(NSInteger)index
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"想做的事", KMENU_TITLE, @"menu_allPlans.png", KMENU_NORMOLICON, @"menu_allPlansSelected.png", KMENU_SELECTEDICON, nil]];
        [_dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"正在进行", KMENU_TITLE, @"menu_actionPlan.png", KMENU_NORMOLICON, @"menu_actionPlanSelected.png", KMENU_SELECTEDICON, nil]];
        [_dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"今日计划", KMENU_TITLE, @"menu_todayPlan.png", KMENU_NORMOLICON, @"menu_todayPlanSelected.png", KMENU_SELECTEDICON, nil]];
        [_dataSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"设置", KMENU_TITLE, @"menu_setting.png", KMENU_NORMOLICON, @"menu_settingSelected.png", KMENU_SELECTEDICON, nil]];
        
        _selectedRow = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    self.tableView.backgroundColor = [UIColor colorWithRed:99 / 255.0 green:102 / 255.0 blue:110 / 255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed:) name:KNOTIFICATION_LOGIN object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mrk - get

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 150)];
        _headerView.backgroundColor = [UIColor clearColor];
        
        _headerButton = [[UIButton alloc] initWithFrame:CGRectMake((_headerView.frame.size.width * KSIDESLIP_PERCENT - KUSER_HEADERIMAGE_WIDTH) / 2, 20, KUSER_HEADERIMAGE_WIDTH, KUSER_HEADERIMAGE_HEIGHT)];
        [_headerButton addTarget:self action:@selector(tapHeaderView:) forControlEvents:UIControlEventTouchUpInside];
        [_headerButton setImage:[UIImage imageNamed:@"userLogoutDefault.png"] forState:UIControlStateNormal];
        _headerButton.layer.cornerRadius = KUSER_HEADERIMAGE_WIDTH / 2;
        _headerButton.layer.masksToBounds = YES;
        _headerButton.layer.borderWidth = 2.0f;
        _headerButton.layer.borderColor = [[UIColor colorWithRed:139 / 255.0 green:142 / 255.0 blue:147 / 255.0 alpha:1.0] CGColor];
        [_headerView addSubview:_headerButton];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _headerButton.frame.origin.y + 80 + 15, _headerView.frame.size.width * KSIDESLIP_PERCENT - 10, 20)];
        _nameLabel.textAlignment = KTextAlignmentCenter;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor colorWithRed:139 / 255.0 green:142 / 255.0 blue:147 / 255.0 alpha:1.0];
        _nameLabel.text = @"未登录";
        [_headerView addSubview:_nameLabel];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView:)];
        [_headerView addGestureRecognizer:tap];
    }
    
    return _headerView;
}

- (UINavigationController *)accountNC
{
    if (_accountNC == nil) {
        XDAccountLoginViewController *accountVC = [[XDAccountLoginViewController alloc] initWithStyle:UITableViewStylePlain];
        _accountNC = [[UINavigationController alloc] initWithRootViewController:accountVC];
        _accountNC.navigationBar.tintColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
    }
    
    return _accountNC;
}

- (UINavigationController *)allPlansNC
{
    if (_allPlansNC == nil) {
        XDAllPlansViewController *allPlansVC = [[XDAllPlansViewController alloc] init];
        _allPlansNC = [[UINavigationController alloc] initWithRootViewController:allPlansVC];
        _allPlansNC.navigationBar.tintColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
    }
    
    return _allPlansNC;
}

- (UINavigationController *)actionPlanNC
{
    if (_actionPlanNC == nil) {
        XDActionPlanViewController *actionVC = [[XDActionPlanViewController alloc] init];
        _actionPlanNC = [[UINavigationController alloc] initWithRootViewController:actionVC];
        _actionPlanNC.navigationBar.tintColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
    }
    
    return _actionPlanNC;
}

- (UINavigationController *)todayPlanNC
{
    if (_todayPlanNC == nil) {
        XDTodayPlanViewController *todayPlanVC = [[XDTodayPlanViewController alloc] initWithStyle:UITableViewStylePlain];
        _todayPlanNC = [[UINavigationController alloc] initWithRootViewController:todayPlanVC];
        _todayPlanNC.navigationBar.tintColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
    }
    
    return _todayPlanNC;
}

- (UINavigationController *)settingNC
{
    if (_settingNC == nil) {
        XDSettingViewController *settingVC = [[XDSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _settingNC = [[UINavigationController alloc] initWithRootViewController:settingVC];
        _settingNC.navigationBar.tintColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
    }
    
    return _settingNC;
}

#pragma mark - notification

- (void)loginSucceed:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[UIImage class]]) {
        UIImage *image = (UIImage *)object;
        if (image == nil) {
            image = [UIImage imageNamed:@"userLoginDefault.png"];
        }
        [_headerButton setImage:image forState:UIControlStateNormal];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    XDMenuCell *cell = (XDMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[XDMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.availableSize = CGSizeMake(self.tableView.frame.size.width * KSIDESLIP_PERCENT, KSIDESLIP_CELL_HEIGHT);
    }
    
    NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
    if (dic != nil && [dic count] > 0) {
        cell.normalIcon = [UIImage imageNamed:[dic objectForKey:KMENU_NORMOLICON]];
        cell.highlightedIcon = [UIImage imageNamed:[dic objectForKey:KMENU_SELECTEDICON]];
        cell.titleLabel.text = [dic objectForKey:KMENU_TITLE];
        
        if (_selectedRow == indexPath.row) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KSIDESLIP_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedRow != indexPath.row) {
        _selectedRow = indexPath.row;
        
        NSString *title = [[_dataSource objectAtIndex:indexPath.row] objectForKey:KMENU_TITLE];
        if ([title isEqualToString:@"想做的事"]) {
            
            self.sidePanelController.centerPanel = self.allPlansNC;
        }
        else if([title isEqualToString:@"正在进行"])
        {
            self.sidePanelController.centerPanel = self.actionPlanNC;
        }
        else if ([title isEqualToString:@"今日计划"])
        {
            
            self.sidePanelController.centerPanel = self.todayPlanNC;
        }
        else if ([title isEqualToString:@"设置"])
        {
            self.sidePanelController.centerPanel = self.settingNC;
        }
    }
}

#pragma mark - GestureRecognizer

- (void)tapHeaderView:(UITapGestureRecognizer *)tap
{
    [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0] animated:YES];
    _selectedRow = -1;
    
    self.sidePanelController.centerPanel = self.accountNC;
}

- (UINavigationController *)navigationForIndex:(NSInteger)index
{
    NSString *title = [[_dataSource objectAtIndex:_selectedRow] objectForKey:KMENU_TITLE];
    if ([title isEqualToString:@"想做的事"]) {
        return self.allPlansNC;
    }
    else if([title isEqualToString:@"正在进行"])
    {
        return self.actionPlanNC;
    }
    else if ([title isEqualToString:@"今日计划"])
    {
        
        return self.todayPlanNC;
    }
    else if ([title isEqualToString:@"设置"])
    {
        return self.settingNC;
    }
    
    return nil;
}

@end
