//
//  XDDayPlanViewController.m
//  XDPlans
//
//  Created by xie yajie on 13-9-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDDayPlanViewController.h"

#import "XDColorViewController.h"
#import "XDDayPlanCell.h"
#import "XDMoodPicker.h"

#import "WantPlan.h"
#import "DayPlan.h"
#import "XDManagerHelper.h"

#define KTODAY_DATA_TITLE @"title"
#define KTODAY_DATA_ICON_NORMAL @"icon_normal"
#define KTODAY_DATA_ICON_SELECTED @"icon_selected"
#define KTODAY_CELL_COLOR @"cell_color"
#define KTODAY_CELL_LAYOUTTYPE @"cell_layoutType"
#define KTODAY_CELL_IDENTIFIER @"cell_dentifier"

#define KSECTION_MOOD 0
#define KSECTION_WORKLOAD 1
#define KSECTION_FINISHFAITH 2
#define KSECTION_PLAN 3
#define KSECTION_SUMMARY 4
#define KSECTION_GRADE 5

static XDDayPlanViewController *todayPlan = nil;

@interface XDDayPlanViewController ()<XDTodayPlayCellDelegate, XDColorViewControllerDelegate, XDMoodPickerDelegate>
{
    NSMutableArray *_configurationSource;
    XDDateHelper *_dateHelper;
    NSString *_planContent;
    
    NSDate *_todayDate;
    UILabel *_ymwLabel;
    UILabel *_dayLabel;
    UILabel *_planContentLabel;
    
    UIButton *_moodButton;
    UITextField *_moodText;
    UITextView *_planText;
    UITextView *_summaryText;
}

@property (nonatomic, strong) NSMutableArray *sectionHeaderViews;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIBarButtonItem *saveItem;
@property (nonatomic, strong) UIBarButtonItem *hideKeyboardItem;

@property (nonatomic) BOOL canEdit;

@end

@implementation XDDayPlanViewController

@synthesize sectionHeaderViews = _sectionHeaderViews;
@synthesize headerView = _headerView;

@synthesize canEdit = _canEdit;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _configurationSource = [NSMutableArray array];
        [_configurationSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"心情", KTODAY_DATA_TITLE, @"menu_allPlans.png", KTODAY_DATA_ICON_NORMAL, @"menu_allPlansSelected.png", KTODAY_DATA_ICON_SELECTED, [NSNumber numberWithInteger:0], KTODAY_CELL_LAYOUTTYPE, [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0], KTODAY_CELL_COLOR, @"MoodCell", KTODAY_CELL_IDENTIFIER, nil]];
        [_configurationSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"今日工作量指数", KTODAY_DATA_TITLE, @"menu_allPlans.png", KTODAY_DATA_ICON_NORMAL, @"menu_allPlansSelected.png", KTODAY_DATA_ICON_SELECTED, [NSNumber numberWithInteger:0], KTODAY_CELL_LAYOUTTYPE, [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0], KTODAY_CELL_COLOR, @"WordloadCell", KTODAY_CELL_IDENTIFIER, nil]];
        [_configurationSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"完成信心指数", KTODAY_DATA_TITLE, @"menu_allPlans.png", KTODAY_DATA_ICON_NORMAL, @"menu_allPlansSelected.png", KTODAY_DATA_ICON_SELECTED, [NSNumber numberWithInteger:0], KTODAY_CELL_LAYOUTTYPE, [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0], KTODAY_CELL_COLOR, @"FinishCell", KTODAY_CELL_IDENTIFIER, nil]];
        [_configurationSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"今日安排", KTODAY_DATA_TITLE, @"menu_allPlans.png", KTODAY_DATA_ICON_NORMAL, @"menu_allPlansSelected.png", KTODAY_DATA_ICON_SELECTED, [NSNumber numberWithInteger:1], KTODAY_CELL_LAYOUTTYPE, [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0], KTODAY_CELL_COLOR, @"PlanCell", KTODAY_CELL_IDENTIFIER, nil]];
        [_configurationSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"今日总结", KTODAY_DATA_TITLE, @"menu_allPlans.png", KTODAY_DATA_ICON_NORMAL, @"menu_allPlansSelected.png", KTODAY_DATA_ICON_SELECTED, [NSNumber numberWithInteger:2], KTODAY_CELL_LAYOUTTYPE, [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0], KTODAY_CELL_COLOR, @"SummaryCell", KTODAY_CELL_IDENTIFIER, nil]];
        [_configurationSource addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"给自己今天的表现打个分吧", KTODAY_DATA_TITLE, @"menu_allPlans.png", KTODAY_DATA_ICON_NORMAL, @"menu_allPlansSelected.png", KTODAY_DATA_ICON_SELECTED, [NSNumber numberWithInteger:0], KTODAY_CELL_LAYOUTTYPE, [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0], KTODAY_CELL_COLOR, @"GrandCell", KTODAY_CELL_IDENTIFIER, nil]];
    }
    return self;
}

+ (id)defaultToday
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        todayPlan = [[XDDayPlanViewController alloc] initWithStyle:UITableViewStylePlain canEdit:YES];
    });
    
    todayPlan.canEdit = YES;
    
    return todayPlan;
}

- (id)initWithStyle:(UITableViewStyle)style canEdit:(BOOL)canEdit
{
    self = [self initWithStyle:style];
    if (self) {
        _canEdit = canEdit;
        _dateHelper = [XDDateHelper defaultHelper];
        
        _actionPlan = [[XDManagerHelper shareHelper] actionPlan];
        _planContent = @"暂无";
        if (_actionPlan) {
            _planContent = _actionPlan.content;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    if (_canEdit) {
        self.title = @"今日计划";
    }
    else{
        self.title = @"计划详情";
    }
    
    [self.navigationItem setRightBarButtonItem:self.saveItem animated:YES];
    self.view.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:221 / 255.0 blue:212 / 255.0 alpha:1.0];
    _todayDate = [NSDate date];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    headerView.backgroundColor = [UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0];
    [self.tableView addSubview:headerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *oldStr = [_dateHelper ymdForDate:_todayDate];
    NSString *newStr = [_dateHelper ymdForDate:[NSDate date]];
    if (![oldStr isEqualToString:newStr]) {
        
        _ymwLabel.text = [NSString stringWithFormat:@"%@  %@", [_dateHelper year_monthForDate:_todayDate], [_dateHelper weekForDate:_todayDate]];
        _dayLabel.text = [NSString stringWithFormat:@"%i", [_dateHelper dayForDate:_todayDate]];
    }
}

#pragma mark - get

- (UIView *)headerView
{
    if (_headerView == nil) {
        CGFloat viewHeight = 80.0;
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, viewHeight)];
        _headerView.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
        
        _ymwLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _headerView.frame.size.width, 20)];
        _ymwLabel.backgroundColor = [UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0];
        _ymwLabel.font = [UIFont systemFontOfSize:14.0];
        _ymwLabel.textColor = [UIColor whiteColor];
        _ymwLabel.text = [NSString stringWithFormat:@"%@  %@", [_dateHelper year_monthForDate:_todayDate], [_dateHelper weekForDate:_todayDate]];
        [_headerView addSubview:_ymwLabel];
        
        //dateView
        UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 70, 60)];
        dateView.backgroundColor = [UIColor clearColor];
        [_headerView addSubview:dateView];
        
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dateView.frame.size.width, dateView.frame.size.height)];
        _dayLabel.backgroundColor = [UIColor clearColor];
        _dayLabel.textAlignment = KTextAlignmentCenter;
        _dayLabel.font = [UIFont boldSystemFontOfSize:35.0];
        _dayLabel.textColor = [UIColor colorWithRed:91 / 255.0 green:142 / 255.0 blue:161 / 255.0 alpha:1.0];
        _dayLabel.text = [NSString stringWithFormat:@"%i", [_dateHelper dayForDate:_todayDate]];
        [dateView addSubview:_dayLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(dateView.frame.size.width - 1, 0, 1, dateView.frame.size.height)];
        line.backgroundColor = [UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0];
        [dateView addSubview:line];
        
        //planContentView
        _planContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateView.frame.origin.x + dateView.frame.size.width + 10, 20, _headerView.frame.size.width - dateView.frame.size.width - 10, dateView.frame.size.height)];
        _planContentLabel.font = [UIFont boldSystemFontOfSize:15.0];
        _planContentLabel.numberOfLines = 0;
        _planContentLabel.backgroundColor = [UIColor clearColor];
        _planContentLabel.textColor = [UIColor grayColor];
        _planContentLabel.text = [NSString stringWithFormat:@"想做的事：%@", _planContent];
        [_headerView addSubview:_planContentLabel];
    }
    
    return _headerView;
}

- (UIBarButtonItem *)hideKeyboardItem
{
    if (_hideKeyboardItem == nil) {
        _hideKeyboardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plans_hideKeyboard.png"] style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboardAction:)];
    }
    
    return _hideKeyboardItem;
}

- (UIBarButtonItem *)saveItem
{
    if (_saveItem == nil) {
        _saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    }
    
    return _saveItem;
}

- (NSMutableArray *)sectionHeaderViews
{
    if (_sectionHeaderViews == nil) {
        _sectionHeaderViews = [[NSMutableArray alloc] init];
        
        for (int i= 0; i < [_configurationSource count]; i++) {
            NSDictionary *dic = [_configurationSource objectAtIndex:i];
            UIColor *color = [dic objectForKey:KTODAY_CELL_COLOR];
            if (color == nil || ![color isKindOfClass:[UIColor class]]) {
                color = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
            }
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25.0)];
            view.backgroundColor = color;
            view.layer.shadowOffset = CGSizeMake(1, 1);
            view.layer.shadowRadius = 2.0;
            view.layer.shadowOpacity = 1.0;
            view.layer.shadowColor = [[UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0] CGColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.frame.size.width - 20 - 30, view.frame.size.height)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
            label.font = [UIFont boldSystemFontOfSize:15.0];
            label.text = [dic objectForKey:KTODAY_DATA_TITLE];
            [view addSubview:label];
            
            if (_canEdit) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width - 40, 0, 30, view.frame.size.height)];
                button.tag = [XDManagerHelper tagCompileWithInteger:i];
                [button setImage:[UIImage imageNamed:@"plans_enabled_yes.png"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"plans_enabled_no.png"] forState:UIControlStateSelected];
                [button addTarget:self action:@selector(sectionEnabledAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
            }
            
            [_sectionHeaderViews addObject:view];
        }
    }
    
    return _sectionHeaderViews;
}

#pragma mark - set

- (void)setActionPlan:(WantPlan *)plan
{
    _actionPlan = plan;
    if (_actionPlan) {
        _planContent = _actionPlan.content;
        _planContentLabel.text = [NSString stringWithFormat:@"想做的事：%@", _planContent];
    }
}

- (void)setDayPlan:(DayPlan *)plan
{
    _dayPlan = plan;
}

#pragma mark - notification keyboard

- (void)showKeyboard:(NSNotification *)notification
{
    [self.navigationItem setRightBarButtonItem:self.hideKeyboardItem animated:YES];
}

- (void)hideKeyboard:(NSNotification *)notification
{
    [self.navigationItem setRightBarButtonItem:self.saveItem animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_configurationSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_configurationSource objectAtIndex:indexPath.section];
    NSString *CellIdentifier = [dic objectForKey:KTODAY_CELL_IDENTIFIER];
    XDDayPlanCell *cell = (XDDayPlanCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[XDDayPlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section) {
            case KSECTION_MOOD:
                [cell configurationMood];
                cell.delegate = self;
                _moodButton = cell.moodButton;
                _moodText = cell.textField;
                break;
            case KSECTION_WORKLOAD:
                [cell configurationWordload];
                cell.delegate = self;
                break;
            case KSECTION_FINISHFAITH:
                [cell configurationFinishFaith];
                cell.delegate = self;
                break;
            case KSECTION_PLAN:
                [cell configurationPlan];
                _planText = cell.textView;
                break;
            case KSECTION_SUMMARY:
                [cell configurationSummary];
                _summaryText = cell.textView;
                break;
            case KSECTION_GRADE:
                [cell configurationGrand];
                break;
                
            default:
                break;
        }
    }
    
    if (!_canEdit) {
        cell.userInteractionEnabled = NO;
        
        switch (indexPath.section) {
            case KSECTION_MOOD:
                cell.moodImageName = nil;
                cell.moodText = @"天气不错";
                break;
            case KSECTION_WORKLOAD:
                cell.color = [UIColor greenColor];
                cell.exponent = 3;
                break;
            case KSECTION_FINISHFAITH:
                cell.color = [UIColor redColor];
                cell.exponent = 5;
                break;
            case KSECTION_PLAN:
                cell.planContent = @"123";
                break;
            case KSECTION_SUMMARY:
                cell.summaryContent = @"456";
                break;
            case KSECTION_GRADE:
                cell.summaryKey = @"verygood";
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.sectionHeaderViews objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger type = [[[_configurationSource objectAtIndex:indexPath.section] objectForKey:KTODAY_CELL_LAYOUTTYPE] integerValue];
    if (type == 0) {
        return KTODAY_CELL_HEIGHT_NORMAL;
    }
    
    return KTODAY_CELL_HEIGHT_CONTENT;
}

#pragma mark - XDTodayPlayCellDelegate

- (void)planCellSelectedMoodPicker:(XDDayPlanCell *)planCell
{
    XDMoodPicker *moodPicker = [[XDMoodPicker alloc] initWithTitle:@"选择表情" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    moodPicker.moodDelegate = self;
    [moodPicker showInView:self.view];
}

- (void)planCellSelectedColorPicker:(XDDayPlanCell *)planCell
{
    XDColorViewController *colorVC = [[XDColorViewController alloc] initWithStyle:UITableViewStylePlain];
    colorVC.colorKey = planCell.colorKey;
    colorVC.callerObject = planCell;
    colorVC.delegate = self;
    [self.navigationController pushViewController:colorVC animated:YES];
}

#pragma mark - XDColorViewControllerDelegate

- (void)colorPickerSlectedColor:(UIColor *)color key:(NSString *)key withCaller:(id)caller
{
    XDDayPlanCell *planCell = (XDDayPlanCell *)caller;
    if (![planCell.colorKey isEqualToString:key]) {
        planCell.colorKey = key;
        [planCell updateWithColor:color];
    }
}

#pragma mark - XDMoodPickerDelegate

- (void)moodPicker:(XDMoodPicker *)moodPicker selectedImage:(UIImage *)image
{
    if (image != nil) {
        [_moodButton setImage:image forState:UIControlStateNormal];
    }
}

#pragma mark - item action

- (void)hideKeyboardAction:(id)sender
{
    [_moodText resignFirstResponder];
    [_planText resignFirstResponder];
    [_summaryText resignFirstResponder];
}

- (void)saveAction:(id)sender
{
    [self hideKeyboardAction:sender];
    
    XDDayPlanCell *moodCell = (XDDayPlanCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:KSECTION_MOOD]];
    _dayPlan.moodImage = moodCell.moodImageName;
    _dayPlan.moodText = _moodText.text;
    
    XDDayPlanCell *workCell = (XDDayPlanCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:KSECTION_WORKLOAD]];
    _dayPlan.workColor = workCell.colorKey;
    _dayPlan.workLoad = [NSNumber numberWithInteger:workCell.exponent];
    
    XDDayPlanCell *finishCell = (XDDayPlanCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:KSECTION_FINISHFAITH]];
    _dayPlan.finishColor = finishCell.colorKey;
    _dayPlan.finishConfidence = [NSNumber numberWithInteger:finishCell.exponent];
    
    _dayPlan.content = _planText.text;
    _dayPlan.summary = _summaryText.text;
    
    XDDayPlanCell *scoreCell = (XDDayPlanCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:KSECTION_GRADE]];
    _dayPlan.scoreKey = scoreCell.summaryKey;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)sectionEnabledAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    BOOL selected = button.selected;
    button.selected = !selected;
    NSInteger section = [XDManagerHelper tagDecompileWithInteger:button.tag];
    XDDayPlanCell *cell = (XDDayPlanCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    cell.userInteractionEnabled = selected;
}

@end
