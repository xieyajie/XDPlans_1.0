//
//  XDPostPlanViewController.m
//  XDPlans
//
//  Created by xieyajie on 13-9-15.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDPostPlanViewController.h"

#import "WantPlan.h"
#import "RichTextEditor.h"
#import "XDDatePicker.h"
#import "XDManagerHelper.h"

@interface XDPostPlanViewController ()<UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UILabel *_numberLabel;
    XDDatePicker *_datePicker;
    
    BOOL _isNew;
    WantPlan *_editPlan;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIButton *dateView;

@property (nonatomic, strong)  NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) UIBarButtonItem *titleItem;
@property (nonatomic, strong) UIBarButtonItem *doneItem;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation XDPostPlanViewController

@synthesize tableView = _tableView;
@synthesize contentTextView = _contentTextView;
@synthesize dateView = _dateView;

@synthesize dateFormatter = _dateFormatter;
@synthesize selectedDate = _selectedDate;

@synthesize titleItem = _titleItem;
@synthesize doneItem = _doneItem;
@synthesize dateLabel = _dateLabel;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _datePicker = [[XDDatePicker alloc] init];
        _selectedDate = nil;
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return self;
}

- (id)initWithCreateNew
{
    self = [self init];
    if (self) {
        _isNew = YES;
        _editPlan = nil;
    }
    
    return self;
}

- (id)initWithEditPlan:(WantPlan *)plan
{
    self = [self init];
    if (self) {
        _isNew = NO;
        _editPlan = plan;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];;
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeybord:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeybord:) name:UIKeyboardWillHideNotification object:nil];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:221 / 255.0 blue:212 / 255.0 alpha:1.0];
    
    UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    topBar.tintColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
    [self.view addSubview:topBar];
    
    if (!_isNew) {
        self.titleItem.title = @"修改内容";
        self.doneItem.title = @"完成";
        
        if (_editPlan) {
            _selectedDate = _editPlan.finishDate;
            self.contentTextView.text = _editPlan.content;
            if(self.dateView)
            {
                _dateLabel.text = [_dateFormatter stringFromDate:_selectedDate];
            }
        }
    }
    else{
        self.titleItem.title = @"创建想做的事";
        self.doneItem.title = @"添加";
    }
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    [topBar setItems:[NSArray arrayWithObjects:backItem, flexibleItem, _titleItem, flexibleItem, _doneItem, nil] animated:YES];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:221 / 255.0 blue:212 / 255.0 alpha:1.0];
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 10 - 40, 10, 40, 20)];
    label.text = @" 个字";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:label];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x - 30, 10, 30, 20)];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.text = [NSString stringWithFormat:@"%i", KPLAN_CONTENT_MAXLENGHT];
    _numberLabel.textAlignment = KTextAlignmentRight;
    _numberLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [tableHeaderView addSubview:_numberLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(_numberLabel.frame.origin.x - 30, 10, 40, 20)];
    label2.text = @"剩余 ";
    label2.font = [UIFont systemFontOfSize:14.0];
    label2.textColor = [UIColor grayColor];
    label2.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:label2];
    
    [self.tableView setTableHeaderView:tableHeaderView];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    [self.contentTextView removeFromSuperview];
    [self.dateView removeFromSuperview];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.contentTextView];
    }
    else if (indexPath.row == 1)
    {
        [cell.contentView addSubview:self.dateView];
    }
    
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 180;
            break;
        case 1:
            return 60;
            break;
            
        default:
            return 0;
            break;
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_contentTextView resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger number = [textView.text length];
    if (number > KPLAN_CONTENT_MAXLENGHT) {
        textView.text = [textView.text substringToIndex:KPLAN_CONTENT_MAXLENGHT];
    }
    else{
        _numberLabel.text = [NSString stringWithFormat:@"%i", (KPLAN_CONTENT_MAXLENGHT - textView.text.length)];
    }
}

#pragma mark - notification

- (void)showKeybord:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    _tableView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44 - keyboardSize.height);
}

- (void)hideKeybord:(NSNotification *)notification
{
    _tableView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
}

#pragma mark - get

- (UIBarButtonItem *)titleItem
{
    if (_titleItem == nil) {
        _titleItem = [[UIBarButtonItem alloc] initWithTitle:@"添加想做的事" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    
    return _titleItem;
}

- (UIBarButtonItem *)doneItem
{
    if (_doneItem == nil) {
        _doneItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    }
    
    return _doneItem;
}

- (UITextView *)contentTextView
{
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 170)];
        _contentTextView.backgroundColor = [UIColor whiteColor];
        _contentTextView.layer.borderWidth = 1.0;
        _contentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _contentTextView.font = [UIFont systemFontOfSize:17.0];
        _contentTextView.delegate = self;
    }
    
    return _contentTextView;
}

- (UIButton *)dateView
{
    if (_dateView == nil) {
        _dateView = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
        _dateView.layer.cornerRadius = 10;
        _dateView.layer.masksToBounds = YES;
        _dateView.layer.borderWidth = 1.0;
        _dateView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        _dateView.backgroundColor = [UIColor whiteColor];
        [_dateView addTarget:self action:@selector(dateAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, _dateView.frame.size.height)];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"结束时间：";
        title.font = [UIFont boldSystemFontOfSize:16.0];
        [_dateView addSubview:title];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.origin.x + title.frame.size.width, 0, _dateView.frame.size.width - (title.frame.origin.x + title.frame.size.width + 10), _dateView.frame.size.height)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor grayColor];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        _dateLabel.textAlignment = KTextAlignmentRight;
        _dateLabel.text = @"点击设置时间";
        [_dateView addSubview:_dateLabel];
    }
    
    return _dateView;
}

#pragma mark - set

- (void)setContent:(NSString *)str
{
    self.contentTextView.text = str;
}

- (void)setEndDate:(NSDate *)date
{
    _selectedDate = date;
    if(self.dateView)
    {
        _dateLabel.text = [_dateFormatter stringFromDate:date];
    }
}

#pragma mark - items action

- (void)dateAction:(id)sender
{
    [_contentTextView resignFirstResponder];

    _datePicker.cancelClicked = ^(){
        
    };
    
    __weak XDPostPlanViewController *weakSelf = self;
    _datePicker.sureClicked = ^(NSDate *date){
        weakSelf.selectedDate = [date copy];
        weakSelf.dateLabel.text = [weakSelf.dateFormatter stringFromDate:date];
    };
    [_datePicker selectedDate:_selectedDate];
    [_datePicker showInView:self.view];
}

- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)done:(id)sender
{
    if (self.contentTextView.text.length <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，请添加内容" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([_dateLabel.text isEqualToString:@"点击设置时间"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起，请设置结束时间" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if (_isNew) {
        WantPlan *newPlan = [WantPlan MR_createEntity];
        newPlan.action = [NSNumber numberWithBool:NO];
        newPlan.finish = [NSNumber numberWithBool:NO];
        newPlan.startDate = [NSDate date];
        newPlan.finishDate = _selectedDate;
        newPlan.content = self.contentTextView.text;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PLANNEWFINISH object:newPlan];
    }
    else{
        _editPlan.content = self.contentTextView.text;
        _editPlan.finishDate = _selectedDate;
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PLANEDITFINISH object:nil];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
