//
//  XDSettingViewController.m
//  XDPlans
//
//  Created by xieyajie on 13-9-4.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDSettingViewController.h"

#import <QuartzCore/QuartzCore.h>

#define KSETTING_SECTION_TITLE @"headerTitle"
#define KSETTING_SECTION_SOURCE @"source"
#define KSETTING_CELL_TITLE @"title"
#define KSETTING_CELL_SELECTOR @"selector"
#define KSETTING_CELL_ICON @"icon"

#define KSETTING_TAG_SWITCH 100
#define KSETTING_TAG_TEXTFIELD 99

@interface XDSettingViewController ()
{
    NSDictionary *_dataSource;
    
    CGFloat _marginWidth;
}

@end

@implementation XDSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _marginWidth = 0;
        if (style == UITableViewStyleGrouped) {
            CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
            if (version < 7.0) {
                _marginWidth = 10;
            }
        }
        
        [self configationData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.title = @"设置";
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:221 / 255.0 blue:212 / 255.0 alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithRed:209 / 255.0 green:207 / 255.0 blue:199 / 255.0 alpha:1.0];
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
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [NSString stringWithFormat:@"%i", section];
    return [[[_dataSource objectForKey:key] objectForKey:KSETTING_SECTION_SOURCE] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [NSString stringWithFormat:@"%i", section];
    return [[_dataSource objectForKey:key] objectForKey:KSETTING_SECTION_TITLE];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionKey = [NSString stringWithFormat:@"%i",indexPath.section];
    NSString *rowKey = [NSString stringWithFormat:@"%i", indexPath.row];
    NSDictionary *rowDic = [[[_dataSource objectForKey:sectionKey] objectForKey:KSETTING_SECTION_SOURCE] objectForKey:rowKey];
    NSString *title = [rowDic objectForKey:KSETTING_CELL_TITLE];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        static NSString *TTSCellIdentifier = @"Tile_Title_Switch_Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:TTSCellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TTSCellIdentifier];
//            cell.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.backgroundColor = [UIColor redColor];
            datePicker.datePickerMode = UIDatePickerModeTime;
//            UIView *v = [[[[datePicker subviews] objectAtIndex:0] subviews] objectAtIndex:0];
//            v.alpha = 0.5;
//            [v setBackgroundColor:[UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0]];
            
            UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
            toolBar.tintColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
            UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:nil action:nil];
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(doneTime:)];
            [toolBar setItems:[NSArray arrayWithObjects:flexibleItem, cancelItem, doneItem, nil] animated:YES];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(_marginWidth + size.width + 20, (cell.frame.size.height - 37.0) / 2, 115, 37)];
            textField.tag = KSETTING_TAG_TEXTFIELD;
            textField.backgroundColor = [UIColor clearColor];
            textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textField.inputView = datePicker;
            textField.inputAccessoryView = toolBar;
            [cell.contentView addSubview:textField];
            
            UISwitch *sth = [[UISwitch alloc] initWithFrame:CGRectMake(320 - _marginWidth * 2 - 10 - 80, (cell.frame.size.height - 30.0) / 2, 80, 30.0)];
            sth.tag = KSETTING_TAG_SWITCH;
            [cell.contentView addSubview:sth];
        }
    }
    else if (indexPath.section == 1)
    {
        static NSString *TSCellIdentifier = @"Tile_Switch_Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:TSCellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TSCellIdentifier];
//            cell.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UISwitch *sth = [[UISwitch alloc] initWithFrame:CGRectMake(320 - _marginWidth * 2 - 10 - 80, (cell.frame.size.height - 30.0) / 2, 80, 30.0)];
            sth.tag = KSETTING_TAG_SWITCH;
            [cell.contentView addSubview:sth];
        }

    }
    else if (indexPath.section == 2) {
        static NSString *ITCellIdentifier = @"Image_Title_Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:ITCellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ITCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
//            cell.backgroundColor = [UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0];
        }
    }
    
    if (rowDic != nil) {
        cell.textLabel.text = [rowDic objectForKey:KSETTING_CELL_TITLE];
        cell.imageView.image = [UIImage imageNamed:[rowDic objectForKey:KSETTING_CELL_ICON]];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    }
}


#pragma mark - data source

- (void)configationData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"XDSetting" ofType:@"plist"];
    _dataSource = [NSDictionary dictionaryWithContentsOfFile:path];
}

#pragma mark - item/button action

- (void)doneTime:(id)sender
{
    
}

@end
