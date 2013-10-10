//
//  XDPlanDetailViewController.m
//  XDPlans
//
//  Created by xieyajie on 13-9-6.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDPlanDetailViewController.h"

#import "XDPlanDetailCell.h"
#import "XDPlanScrollView.h"
#import "XDDayPlanViewController.h"

#import "DayPlan.h"
#import "WantPlan.h"
#import "XDManagerHelper.h"

@interface XDPlanDetailViewController ()
{
    NSMutableArray *_dayPlans;
    
    UIView *_tableHeaderView;
    BOOL _isAction;
    NSString *_planContent;
    
    XDManagerHelper *_managerHelper;
    NSMutableArray *_planViews;
}

@property (nonatomic, strong) UIView *tableHeaderView;

@end

@implementation XDPlanDetailViewController

@synthesize tableHeaderView = _tableHeaderView;

- (id)initWithStyle:(UITableViewStyle)style action:(BOOL)isAction
{
    self = [self initWithStyle:style];
    if (self) {
        _isAction = isAction;
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _managerHelper = [XDManagerHelper shareHelper];
        _planViews = [NSMutableArray array];
        _dayPlans = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    if (_isAction) {
        self.title = @"正在做的事";
    }
    else{
        self.title = @"事件流程";
    }
    
    self.tableView.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:221 / 255.0 blue:212 / 255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    headerView.backgroundColor = [UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0];
    [self.tableView addSubview:headerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [_dayPlans count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlanDetailCell";
    XDPlanDetailCell *cell = (XDPlanDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[XDPlanDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    DayPlan *dayPlan = [_dayPlans objectAtIndex:indexPath.row];
    if (dayPlan) {
        cell.dayStr = [NSString stringWithFormat:@"%i", [_managerHelper dayForDate:dayPlan.date]];
        cell.yearMonthStr = [_managerHelper year_monthForDate:dayPlan.date];
        cell.scrollView = [_planViews objectAtIndex:indexPath.row];
        
        if (indexPath.row == [_dayPlans count] - 1) {
            [cell hideLine];
        }
        else{
            [cell showLine];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDDayPlanViewController *dataPlanVC = nil;
    
    if (indexPath.row == 0 && _isAction) {
        dataPlanVC = [XDDayPlanViewController defaultToday];
        dataPlanVC.dayPlan = [_dayPlans objectAtIndex:0];
    }
    else{
        dataPlanVC = [[XDDayPlanViewController alloc] initWithStyle:UITableViewCellStyleDefault canEdit:NO];
    }
    
    dataPlanVC.actionPlan = _basePlan;
    [self.navigationController pushViewController:dataPlanVC animated:YES];
}

#pragma mark - get

- (UIView *)tableHeaderView
{
    if (_tableHeaderView == nil) {
        CGSize size = [_planContent sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake((320 - 20), 600) lineBreakMode:NSLineBreakByClipping];
        CGFloat height = size.height > 40 ? size.height : 40;
        
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, height + 50)];
        _tableHeaderView.backgroundColor = [UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0];
        _tableHeaderView.layer.shadowOffset = CGSizeMake(0, 5);
        _tableHeaderView.layer.shadowRadius = 2.0;
        _tableHeaderView.layer.shadowOpacity = 0.4;
        _tableHeaderView.layer.shadowColor = [[UIColor blackColor] CGColor];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _tableHeaderView.frame.size.width - 20, height)];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont boldSystemFontOfSize:15.0];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.text = [NSString stringWithFormat:@"想做的事：%@", _planContent];
        [_tableHeaderView addSubview:contentLabel];
        
//        UILabel *dateCount = [[UILabel alloc] initWithFrame:CGRectMake(10, _tableHeaderView.frame.size.height - 30, (_tableHeaderView.frame.size.width - 20) / 2, 20)];
//        dateCount.font = [UIFont systemFontOfSize:15.0];
//        dateCount.textColor = [UIColor grayColor];
//        dateCount.backgroundColor = [UIColor clearColor];
//        dateCount.text = @"已进行 2 天";
//        [_tableHeaderView addSubview:dateCount];
        
        UILabel *dateTime = [[UILabel alloc] initWithFrame:CGRectMake(_tableHeaderView.frame.size.width / 2, _tableHeaderView.frame.size.height - 30, (_tableHeaderView.frame.size.width - 20) / 2, 20)];
        dateTime.font = [UIFont systemFontOfSize:15.0];
        dateTime.textColor = [UIColor grayColor];
        dateTime.backgroundColor = [UIColor clearColor];
        dateTime.textAlignment = KTextAlignmentRight;
        dateTime.text = [NSString stringWithFormat:@"结束：%@", [[XDManagerHelper shareHelper] y_m_dForDate:_basePlan.finishDate]];
        [_tableHeaderView addSubview:dateTime];
    }
    
    return _tableHeaderView;
}

#pragma mark - set

- (void)setBasePlan:(WantPlan *)aPlan
{
    if (aPlan) {
        _basePlan = aPlan;
        
        [self configaturePlansSource];
        
        _planContent = _basePlan.content;
        [self.tableView setTableHeaderView:self.tableHeaderView];
    }
}

#pragma mark - data

- (void)configaturePlansSource
{
    [_dayPlans removeAllObjects];
    
    NSArray *todayPlans = [DayPlan MR_findByAttribute:@"date" withValue:[NSDate date]];
    if (todayPlans.count == 0) {
        if (_isAction) {
            DayPlan *todayPlan = [DayPlan MR_createEntity];
            todayPlan.date = [[XDManagerHelper shareHelper] convertDateToY_M_D:[NSDate date]];
            todayPlan.inWantPlans = _basePlan;
        }
    }
    
//    if (_isAction) {
//        DayPlan *todayPlan = [DayPlan MR_createEntity];
//        todayPlan.date = [[XDManagerHelper shareHelper] convertDateToY_M_D:[NSDate date]];
//        todayPlan.inWantPlans = _basePlan;
//    }
    
    [_dayPlans addObjectsFromArray:[DayPlan MR_findByAttribute:@"inWantPlans" withValue:_basePlan andOrderBy:@"date" ascending:NO]];
    
    [self configaturePlanViews];
}

- (void)configaturePlanViews
{
    for (int i = 0; i < [_dayPlans count]; i++) {
        XDPlanScrollView *detailView = [[XDPlanScrollView alloc] init];
        [detailView configurationViewWithPlan:[_dayPlans objectAtIndex:i]];
        [_planViews addObject:detailView];
    }
}

@end
