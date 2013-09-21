//
//  XDColorViewController.m
//  XDPlans
//
//  Created by xieyajie on 13-9-6.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDColorViewController.h"

#define KPLANS_COLOR_DATA_NAME @"name"
#define KPLANS_COLOR_DATA_IMAGE @"image"
#define KPLANS_COLOR_DATA_RGB @"rgb"
#define KPLANS_COLOR_DATA_RED @"red"
#define KPLANS_COLOR_DATA_GREEN @"green"
#define KPLANS_COLOR_DATA_BLUE @"blue"

#define KPLANS_COLOR_CELL_IMAGEVIEW 100

@interface XDColorViewController ()
{
    NSArray *_dataSource;
    UIBarButtonItem *_doneItem;
    
    NSInteger _selectedRow;
}

@end

@implementation XDColorViewController

@synthesize delegate = _delegate;

@synthesize callerObject = _callerObject;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        NSString *path = [[NSBundle mainBundle] pathForResource:@"XDColor" ofType:@"plist"];
        _dataSource = [NSArray arrayWithContentsOfFile:path];
        
        _selectedRow = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.title = @"选择颜色";
 
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 180.0)];
        imageView.tag = KPLANS_COLOR_CELL_IMAGEVIEW;
        [cell.contentView addSubview:imageView];
    }
    
    UIImageView *colorView = (UIImageView *)[cell viewWithTag:KPLANS_COLOR_CELL_IMAGEVIEW];
    if (colorView == nil) {
        colorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 180.0)];
        colorView.tag = KPLANS_COLOR_CELL_IMAGEVIEW;
        [cell.contentView addSubview:colorView];
    }
    
    colorView.image = [UIImage imageNamed:[[_dataSource objectAtIndex:indexPath.row] objectForKey:KPLANS_COLOR_DATA_IMAGE]];
    
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
        self.title = [[_dataSource objectAtIndex:indexPath.row] objectForKey:KPLANS_COLOR_DATA_NAME];
    }
    else{
        _selectedRow = -1;
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.title = @"选择颜色";
    }
}

#pragma mark - item action

- (void)doneAction:(id)sender
{
    if (_selectedRow < 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有选择任何颜色" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    NSDictionary *rgbDic = [[_dataSource objectAtIndex:_selectedRow] objectForKey:KPLANS_COLOR_DATA_RGB];
    UIColor *color = [UIColor colorWithRed:[[rgbDic objectForKey:KPLANS_COLOR_DATA_RED] integerValue] / 255.0 green:[[rgbDic objectForKey:KPLANS_COLOR_DATA_GREEN] integerValue] / 255.0 blue:[[rgbDic objectForKey:KPLANS_COLOR_DATA_BLUE] integerValue] / 255.0 alpha:0.5];
    if (_delegate && [_delegate respondsToSelector:@selector(colorPickerSlectedColor:withCaller:)]) {
        [_delegate colorPickerSlectedColor:color withCaller:_callerObject];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
