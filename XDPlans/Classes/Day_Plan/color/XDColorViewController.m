//
//  XDColorViewController.m
//  XDPlans
//
//  Created by xieyajie on 13-9-6.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDColorViewController.h"
#import "XDColorCell.h"

#define KPLANS_COLOR_DATA_KEY @"key"
#define KPLANS_COLOR_DATA_NAME @"name"
#define KPLANS_COLOR_DATA_REMARK @"remark"
#define KPLANS_COLOR_DATA_IMAGE @"image"
#define KPLANS_COLOR_DATA_RGB @"rgb"
#define KPLANS_COLOR_DATA_RED @"red"
#define KPLANS_COLOR_DATA_GREEN @"green"
#define KPLANS_COLOR_DATA_BLUE @"blue"

#define KPLANS_COLOR_CELL_IMAGEVIEW 100

@interface XDColorViewController ()
{
    NSDictionary *_dataSource;
    NSArray *_colorArray;
    UIBarButtonItem *_doneItem;
    
    NSInteger _selectedRow;
}

@end

@implementation XDColorViewController

@synthesize delegate = _delegate;

@synthesize callerObject = _callerObject;

@synthesize colorKey = _colorKey;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSString *path = [[NSBundle mainBundle] pathForResource:@"XDColor" ofType:@"plist"];
        _dataSource = [NSDictionary dictionaryWithContentsOfFile:path];
        _colorArray = [_dataSource allValues];
        
        _selectedRow = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
//    self.title = @"选择颜色";
 
    _doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = _doneItem;
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
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ColorCell";
    XDColorCell *cell = (XDColorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[XDColorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic = [_colorArray objectAtIndex:indexPath.row];
    cell.name = [dic objectForKey:KPLANS_COLOR_DATA_NAME];
    cell.remark = [dic objectForKey:KPLANS_COLOR_DATA_REMARK];
    NSDictionary *rgbDic = [dic objectForKey:KPLANS_COLOR_DATA_RGB];
    UIColor *color = [UIColor colorWithRed:[[rgbDic objectForKey:KPLANS_COLOR_DATA_RED] floatValue] / 255.0 green:[[rgbDic objectForKey:KPLANS_COLOR_DATA_GREEN] floatValue] / 255.0 blue:[[rgbDic objectForKey:KPLANS_COLOR_DATA_BLUE] floatValue] / 255.0 alpha:0.5];
    cell.contentView.backgroundColor = color;
    
    if (_selectedRow == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (_selectedRow != indexPath.row) {
        if (_selectedRow >= 0) {
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        _selectedRow = indexPath.row;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.title = [[_colorArray objectAtIndex:indexPath.row] objectForKey:KPLANS_COLOR_DATA_NAME];
    }
    else{
        _selectedRow = -1;
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.title = @"选择颜色";
    }
}

#pragma mark - setting

- (void)setColorKey:(NSString *)key
{
    _colorKey = key;
    _selectedRow = [_colorArray indexOfObject:[_dataSource objectForKey:key]];
    self.title = [[_colorArray objectAtIndex:_selectedRow] objectForKey:KPLANS_COLOR_DATA_NAME];
}

#pragma mark - item action

- (void)doneAction:(id)sender
{
    if (_selectedRow < 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有选择任何颜色" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSDictionary *rgbDic = [[_colorArray objectAtIndex:_selectedRow] objectForKey:KPLANS_COLOR_DATA_RGB];
    UIColor *color = [UIColor colorWithRed:[[rgbDic objectForKey:KPLANS_COLOR_DATA_RED] integerValue] / 255.0 green:[[rgbDic objectForKey:KPLANS_COLOR_DATA_GREEN] integerValue] / 255.0 blue:[[rgbDic objectForKey:KPLANS_COLOR_DATA_BLUE] integerValue] / 255.0 alpha:0.5];
    if (_delegate && [_delegate respondsToSelector:@selector(colorPickerSlectedColor:key:withCaller:)]) {
        [_delegate colorPickerSlectedColor:color key:[[_colorArray objectAtIndex:_selectedRow] objectForKey:KPLANS_COLOR_DATA_KEY] withCaller:_callerObject];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
