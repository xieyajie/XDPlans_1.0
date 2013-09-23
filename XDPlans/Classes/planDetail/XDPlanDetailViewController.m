//
//  XDPlanDetailViewController.m
//  XDPlans
//
//  Created by xieyajie on 13-9-6.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDPlanDetailViewController.h"

#import "XDPlanDetailCell.h"
#import "XDDataPlanViewController.h"
#import "XDManagerHelper.h"
#import "XDPlanLocalDefault.h"

@interface XDPlanDetailViewController ()
{
    UIView *_tableHeaderView;
    BOOL _isAction;
    
    XDManagerHelper *_managerHelper;
}

@property (nonatomic, strong) UIView *tableHeaderView;

@end

@implementation XDPlanDetailViewController

@synthesize tableHeaderView = _tableHeaderView;

@synthesize planContent = _planContent;

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.title = @"正在做的事";
    self.tableView.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:221 / 255.0 blue:212 / 255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 2;
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
    cell.dayStr = [NSString stringWithFormat:@"%i", [_managerHelper dayForDate:[NSDate date]]];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XDDataPlanViewController *dataPlanVC = [[XDDataPlanViewController alloc] initWithStyle:UITableViewCellStyleDefault canEdit:YES];
    dataPlanVC.planContent = self.planContent;
    [self.navigationController pushViewController:dataPlanVC animated:YES];
}

#pragma mark - get

- (UIView *)tableHeaderView
{
    if (_tableHeaderView == nil) {
        CGSize size = [_planContent sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake((320 - 20), 600) lineBreakMode:NSLineBreakByClipping];
        CGFloat height = size.height > 40 ? size.height : 40;
        
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, height + 50)];
        _tableHeaderView.backgroundColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _tableHeaderView.frame.size.width - 20, height)];
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont boldSystemFontOfSize:15.0];
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.text = [NSString stringWithFormat:@"想做的事：%@", _planContent];
        [_tableHeaderView addSubview:contentLabel];
        
        UILabel *dateCount = [[UILabel alloc] initWithFrame:CGRectMake(10, _tableHeaderView.frame.size.height - 30, (_tableHeaderView.frame.size.width - 20) / 2, 20)];
        dateCount.font = [UIFont systemFontOfSize:15.0];
        dateCount.textColor = [UIColor grayColor];
        dateCount.backgroundColor = [UIColor clearColor];
        dateCount.text = @"已进行 2 天";
        [_tableHeaderView addSubview:dateCount];
        
        UILabel *dateTime = [[UILabel alloc] initWithFrame:CGRectMake(_tableHeaderView.frame.size.width / 2, _tableHeaderView.frame.size.height - 30, (_tableHeaderView.frame.size.width - 20) / 2, 20)];
        dateTime.font = [UIFont systemFontOfSize:15.0];
        dateTime.textColor = [UIColor grayColor];
        dateTime.backgroundColor = [UIColor clearColor];
        dateTime.textAlignment = KTextAlignmentRight;
        dateTime.text = @"结束：2013/11/26";
        [_tableHeaderView addSubview:dateTime];
    }
    
    return _tableHeaderView;
}

#pragma mark - set

- (void)setPlanContent:(NSString *)content
{
    _planContent = content;
    [self.tableView setTableHeaderView:self.tableHeaderView];
}

@end
