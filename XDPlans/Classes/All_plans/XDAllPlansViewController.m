//
//  XDAllPlansViewController.m
//  XDPlans
//
//  Created by xie yajie on 13-9-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDAllPlansViewController.h"

#import "XDAllPlansCell.h"
#import "XDNewPlanViewController.h"
#import "XDPlanDetailViewController.h"

#import "REMenu.h"
#import "XDPlanLocalDefault.h"

#define KPLANS_INDEX @"index"
#define KPLANS_CONTENT @"content"
#define KPLANS_ACTION @"action"
#define KPLANS_FINISH @"finish"

@interface XDAllPlansViewController ()<UIAlertViewDelegate>
{
    NSMutableDictionary *_actionSource;
    NSMutableDictionary *_dataSource;

    UIBarButtonItem *_menuItem;
    UIBarButtonItem *_createItem;
    UIBarButtonItem *_moveItem;
    UIView *_tableHeaderView;
    
    UILongPressGestureRecognizer *_longPress;
}

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) REMenu *menu;

@end

@implementation XDAllPlansViewController

@synthesize tableHeaderView = _tableHeaderView;
@synthesize menu = _menu;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableDictionary dictionary];
        
        //test
        _actionSource = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], KPLANS_INDEX, @"写一个自己的项目", KPLANS_CONTENT, [NSNumber numberWithBool:YES], KPLANS_ACTION, nil];
        [_dataSource setObject:_actionSource forKey:[NSString stringWithFormat:@"%i", 0]];
        
        NSMutableDictionary *eventDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], KPLANS_INDEX, @"爬山爬山爬山爬山爬山爬山爬山爬山爬山爬山爬山", KPLANS_CONTENT, [NSNumber numberWithBool:NO], KPLANS_ACTION, [NSNumber numberWithBool:NO], KPLANS_FINISH, nil];
        [_dataSource setObject:eventDic1 forKey:[NSString stringWithFormat:@"%i", 1]];
        
        NSMutableDictionary *eventDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], KPLANS_INDEX, @"睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉睡觉", KPLANS_CONTENT, [NSNumber numberWithBool:NO], KPLANS_ACTION, [NSNumber numberWithBool:NO], KPLANS_FINISH, nil];
        [_dataSource setObject:eventDic2 forKey:[NSString stringWithFormat:@"%i", 2]];
        
        NSMutableDictionary *eventDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], KPLANS_INDEX, @"游乐园", KPLANS_CONTENT, [NSNumber numberWithBool:NO], KPLANS_ACTION, [NSNumber numberWithBool:NO], KPLANS_FINISH, nil];
        [_dataSource setObject:eventDic3 forKey:[NSString stringWithFormat:@"%i", 3]];
        
        NSMutableDictionary *eventDic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], KPLANS_INDEX, @"泰语", KPLANS_CONTENT, [NSNumber numberWithBool:NO], KPLANS_ACTION, [NSNumber numberWithBool:YES], KPLANS_FINISH, nil];
        [_dataSource setObject:eventDic4 forKey:[NSString stringWithFormat:@"%i", 4]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.title = @"想做的事";
    [self layoutNavigationBar];
    
//    self.tableView.separatorColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
//    self.tableView.backgroundColor = [UIColor colorWithRed:234 / 255.0 green:234 / 255.0 blue:234 / 255.0 alpha:1.0];
//    [self.tableView setTableHeaderView:self.tableHeaderView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:leftSwipe];
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.tableView addGestureRecognizer:_longPress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPlanFinish:) name:KNOTIFICATION_PLANNEWFINISH object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableHeaderView
{
    if (_tableHeaderView == nil) {
        static NSString *CellIdentifier = @"ActionCell";
        XDAllPlansCell *cell = [[XDAllPlansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.content = [_actionSource objectForKey:KPLANS_CONTENT];
        cell.action = [[_actionSource objectForKey:KPLANS_ACTION] boolValue];
        cell.progressValue = 0.6;
        
        NSString *content = [_actionSource objectForKey:KPLANS_CONTENT];
        CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake((320 - 110), 600) lineBreakMode:NSLineBreakByClipping];
        CGFloat height = size.height > 40 ? size.height : 40;
        height += 20;
        
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableHeaderView.frame.size.width, height)];
        _tableHeaderView.backgroundColor = [UIColor colorWithRed:195 / 255.0 green:221 / 255.0 blue:223 / 255.0 alpha:1.0];
        [_tableHeaderView addSubview:cell];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionPlan:)];
        [_tableHeaderView addGestureRecognizer:tap];
    }
    
    return _tableHeaderView;
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
    static NSString *CellIdentifier = @"Cell";
    XDAllPlansCell *cell = (XDAllPlansCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[XDAllPlansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic = [_dataSource objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];
    cell.index = indexPath.row + 1;
    cell.content = [dic objectForKey:KPLANS_CONTENT];
    cell.action = [[dic objectForKey:KPLANS_ACTION] boolValue];
//    cell.finish = [[dic objectForKey:KPLANS_FINISH] boolValue];
    cell.progressValue = 0.4 * indexPath.row;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (toIndexPath.row == 0) {
        return;
    }
    
    NSString *fromKey = [NSString stringWithFormat:@"%i", fromIndexPath.row];
    NSString *toKey = [NSString stringWithFormat:@"%i", toIndexPath.row];
    NSMutableDictionary *fromDic = [_dataSource objectForKey:fromKey];
    NSMutableDictionary *toDic = [_dataSource objectForKey:toKey];
    
    [fromDic setObject:[NSNumber numberWithInteger:toIndexPath.row] forKey:KPLANS_INDEX];
    [toDic setObject:[NSNumber numberWithInteger:fromIndexPath.row] forKey:KPLANS_INDEX];
    
    [_dataSource setObject:fromDic forKey:toKey];
    [_dataSource setObject:toDic forKey:fromKey];
    
    XDAllPlansCell *fromCell = (XDAllPlansCell *)[tableView cellForRowAtIndexPath:fromIndexPath];
    XDAllPlansCell *toCell = (XDAllPlansCell *)[tableView cellForRowAtIndexPath:toIndexPath];
    fromCell.index = toIndexPath.row + 1;
    toCell.index = fromIndexPath.row + 1;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_dataSource objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];
    NSString *content = [dic objectForKey:KPLANS_CONTENT];
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake((320 - 110), 600) lineBreakMode:NSLineBreakByClipping];
    CGFloat height = size.height > 40 ? size.height : 40;
    return height + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_dataSource objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];
    NSString *content = [dic objectForKey:KPLANS_CONTENT];
    XDPlanDetailViewController *planDetailVC = [[XDPlanDetailViewController alloc] initWithStyle:UITableViewStylePlain action:NO];
    planDetailVC.planContent = content;
    [self.navigationController pushViewController:planDetailVC animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (textField.text.length > 0) {
            [self addEventToSource:textField.text];
            [self insertEventToTableViewWithRow:0];
        }
    }
}

#pragma mark - notification

- (void)newPlanFinish:(NSNotification *)notification
{
    id object = [notification object];
    if ([object isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)object;
        
        if (str.length > 0) {
            [self addEventToSource:str];
            [self insertEventToTableViewWithRow:0];
        }
    }
}

#pragma mark - GestureRecognizer

- (void)leftSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.state == UIGestureRecognizerStateEnded) {
        //
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)press
{
    if (press.state == UIGestureRecognizerStateEnded) {
        [self.tableView removeGestureRecognizer:_longPress];
        
        if (_moveItem == nil) {
            _moveItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(stopMove:)];
        }
        self.navigationItem.rightBarButtonItem = _moveItem;
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)tapActionPlan:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        XDPlanDetailViewController *planDetailVC = [[XDPlanDetailViewController alloc] initWithStyle:UITableViewStylePlain action:NO];
        planDetailVC.planContent = [_actionSource objectForKey:KPLANS_CONTENT];
        [self.navigationController pushViewController:planDetailVC animated:YES];
    }
}

#pragma mark - layout subviews

- (void)layoutNavigationBar
{
    if (_menuItem == nil) {
        _menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(menuAction:)];
    }
    self.navigationItem.leftBarButtonItem = _menuItem;
    
    if (_createItem == nil) {
        _createItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createEvent:)];
    }
    
    self.navigationItem.rightBarButtonItem = _createItem;
}

#pragma mark - get

- (REMenu *)menu
{
    if (_menu == nil) {
        REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"想做的事"
                                                        subtitle:@"有很多想做的事情，先来几件排个队"
                                                           image:[UIImage imageNamed:@"menu_allPlans.png"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                          }];
        
        REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"正在进行的事"
                                                           subtitle:@"贪多嚼不烂哦，专心做一件事情吧"
                                                              image:[UIImage imageNamed:@"menu_actionPlan.png"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 NSLog(@"Item: %@", item);
                                                             }];
        
        REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"今天的计划"
                                                            subtitle:@"想做些什么呢？坚持进行下去吧"
                                                               image:[UIImage imageNamed:@"menu_todayPlan.png"]
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                  NSLog(@"Item: %@", item);
                                                              }];
        
        REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"设置"
                                                              image:[UIImage imageNamed:@"menu_setting.png"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 NSLog(@"Item: %@", item);
                                                             }];
        
        homeItem.tag = 0;
        exploreItem.tag = 1;
        activityItem.tag = 2;
        profileItem.tag = 3;
        
        _menu = [[REMenu alloc] initWithItems:@[homeItem, exploreItem, activityItem, profileItem]];
        _menu.cornerRadius = 4;
        _menu.shadowColor = [UIColor blackColor];
        _menu.shadowOffset = CGSizeMake(0, 1);
        _menu.shadowOpacity = 1;
        _menu.imageOffset = CGSizeMake(5, -1);
    }
    
    return _menu;
}

#pragma mrk - item/button action

- (void)menuAction:(id)sender
{
    if (self.menu.isOpen)
    {
        return [self.menu close];
    }
    
    [self.menu showFromNavigationController:self.navigationController];

}

- (void)createEvent:(id)sender
{
    NSInteger count = [_dataSource count] + 1;
    if (count > KPLAN_MAXEVENTCOUNT) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"你已经添加了20件想做的事，完成这些再添加吧" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    XDNewPlanViewController *newPlanVC = [[XDNewPlanViewController alloc] init];
    [self.navigationController presentModalViewController:newPlanVC animated:YES];
}

- (void)stopMove:(id)sender
{
    self.navigationItem.rightBarButtonItem = _createItem;
    [self.tableView setEditing:NO animated:YES];
    [self.tableView addGestureRecognizer:_longPress];
}

#pragma mark - manager

- (void)addEventToSource:(NSString *)string
{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:_dataSource];
    
    [_dataSource removeAllObjects];
    NSMutableDictionary *eventDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], KPLANS_INDEX, string, KPLANS_CONTENT, [NSNumber numberWithBool:NO], KPLANS_ACTION, nil];
    [_dataSource setObject:eventDic forKey:[NSString stringWithFormat:@"%i", 0]];
    
    for (NSString *key in dic) {
        NSInteger index = [key integerValue];
        index++;
        
        NSMutableDictionary *event = [dic objectForKey:key];
        NSString *newKey = [NSString stringWithFormat:@"%i", index];
        NSNumber *newIndex = [NSNumber numberWithInteger:index];
        [event setObject:newIndex forKey:KPLANS_INDEX];
        
        [_dataSource setObject:event forKey:newKey];
    }
}

- (void)deleteEventFromSource:(NSInteger)row
{
    
}

- (void)insertEventToTableViewWithRow:(NSInteger)row
{
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    [self updateVisibleCell];
}

- (void)deleteEventToTableViewWithRow:(NSInteger)row
{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)updateVisibleCell
{
    NSArray *cells = [self.tableView visibleCells];
    
    for (XDAllPlansCell *cell in cells) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSDictionary *dic = [_dataSource objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];
        cell.index = [[dic objectForKey:KPLANS_INDEX] integerValue] + 1;
    }
}

@end
