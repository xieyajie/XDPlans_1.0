//
//  XDAllPlansViewController.m
//  XDPlans
//
//  Created by xie yajie on 13-9-1.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDAllPlansViewController.h"

#import "XDAllPlansCell.h"
#import "XDPostPlanViewController.h"
#import "XDPlanDetailViewController.h"
#import "XDManagerHelper.h"

#import "REMenu.h"
#import "WantPlan.h"

#define KPLANS_ALERTVIEW_TAG_CLOSE 100
#define KPLANS_ALERTVIEW_TAG_OPEN 99

@interface XDAllPlansViewController ()<UIAlertViewDelegate, XDAllPlansCellDelegate>
{
    NSMutableArray *_wantPlans;
    WantPlan *_actionPlan;

    UIBarButtonItem *_menuItem;
    UIBarButtonItem *_createItem;
    UIView *_tableHeaderView;
    
    NSInteger _selectedRow;
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
        _wantPlans = [NSMutableArray array];
        _actionPlan = [[XDManagerHelper shareHelper] actionPlan];
        if (_actionPlan != nil) {
            [_wantPlans addObject:_actionPlan];
        }

        [_wantPlans addObjectsFromArray:[WantPlan MR_findByAttribute:@"action" withValue:[NSNumber numberWithBool:NO]]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.title = @"想做的事";
    [self layoutNavigationBar];
    
//    if ([_wantPlans count] == 0) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
//        view.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:221 / 255.0 blue:212 / 255.0 alpha:1.0];
//        UILabel *noneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, view.frame.size.width - 40, 60)];
//        noneLabel.numberOfLines = 0;
//        noneLabel.font = [UIFont boldSystemFontOfSize:17.0];
//        noneLabel.textColor = [UIColor lightGrayColor];
//        noneLabel.backgroundColor = [UIColor clearColor];
//        noneLabel.text = @"什么也没有，点击这里或者右上角的“+”，赶快添加一些你想做的是吧！";
//        [view addSubview:noneLabel];
//        
//        [self.view addSubview:view];
//    }
    
    _selectedRow = -1;
    self.tableView.rowHeight = 50.0;
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:leftSwipe];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPlanFinish:) name:KNOTIFICATION_PLANNEWFINISH object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editPlanFinish:) name:KNOTIFICATION_PLANEDITFINISH object:nil];
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
    return [_wantPlans count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    XDAllPlansCell *cell = (XDAllPlansCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[XDAllPlansCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setEditing:NO];
    
    WantPlan *plan = [_wantPlans objectAtIndex:indexPath.row];
    cell.index = indexPath.row + 1;
    cell.content = plan.content;
    cell.action = [plan.action boolValue];
    cell.progressValue = 0.2 * (indexPath.row + 1);
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WantPlan *plan = [_wantPlans objectAtIndex:indexPath.row];
    NSString *content = plan.content;
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake((320 - 110), 600) lineBreakMode:NSLineBreakByClipping];
    CGFloat height = size.height > 40 ? size.height : 40;
    return height + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedRow > -1) {
        XDAllPlansCell *cell = (XDAllPlansCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]];
        
        [cell setEditing:NO];
        _selectedRow = -1;
        
        return;
    }
    
    WantPlan *plan = [_wantPlans objectAtIndex:indexPath.row];
    NSString *content = plan.content;
    XDPlanDetailViewController *planDetailVC = [[XDPlanDetailViewController alloc] initWithStyle:UITableViewStylePlain action:NO];
    planDetailVC.planContent = content;
    [self.navigationController pushViewController:planDetailVC animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex)
    {
        XDAllPlansCell *cell = (XDAllPlansCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]];
        
        if (alertView.tag == KPLANS_ALERTVIEW_TAG_CLOSE) {
            _actionPlan.action = [NSNumber numberWithBool:NO];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
            cell.action = NO;
            _actionPlan = nil;
        }
        else if (alertView.tag == KPLANS_ALERTVIEW_TAG_OPEN)
        {
            _actionPlan.action = [NSNumber numberWithBool:NO];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            XDAllPlansCell *oldCell = (XDAllPlansCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            oldCell.action = NO;
            
            _actionPlan = [_wantPlans objectAtIndex:_selectedRow];
            _actionPlan.action = [NSNumber numberWithBool:YES];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            cell.action = YES;
            
            if (index != 0) {
                [_wantPlans replaceObjectAtIndex:0 withObject:_actionPlan];
                
                [self.tableView beginUpdates];
                [self.tableView moveRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0] toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [self.tableView endUpdates];
            }

        }
    }
}

#pragma mark - XDAllPlansCellDelegate

- (void)plansCellActionClick:(XDAllPlansCell *)cell
{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    _selectedRow = index.row;
    
    UIAlertView *alert = nil;
    if (cell.action) {
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"你确定要关闭该事件？若你关闭该事件，今天的已有计划将删除掉。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = KPLANS_ALERTVIEW_TAG_CLOSE;
        [alert show];
    }
    else {
        if (_actionPlan == nil) {
            //开启该事件
            _actionPlan = [_wantPlans objectAtIndex:index.row];
            _actionPlan.action = [NSNumber numberWithBool:YES];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            cell.action = YES;
            
            if (index != 0) {
                [_wantPlans replaceObjectAtIndex:0 withObject:_actionPlan];
                
                [self.tableView beginUpdates];
                [self.tableView moveRowAtIndexPath:index toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [self.tableView endUpdates];
            }
        }
        else{
            alert = [[UIAlertView alloc] initWithTitle:@"你已经有正在进行的事情了" message:@"若想开启另外的事件，将自动关闭正在进行的事件,今天的已有计划将删除掉。\n贪多嚼不烂，专心做一件事情吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = KPLANS_ALERTVIEW_TAG_OPEN;
            [alert show];
        }
    }
}

- (void)plansCellFinishAction:(XDAllPlansCell *)cell
{
//    cell.progressValue = 1.0;
}

- (void)plansCellDeleteAction:(XDAllPlansCell *)cell
{
    NSLog(@"Delete");
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (cell.action) {
        _actionPlan = nil;
    }
    
    [self deletePlanFromSource:indexPath.row];
    [self deletePlanToTableViewWithRow:indexPath.row];
    [cell setEditing:NO];
}

- (void)plansCellEditAction:(XDAllPlansCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WantPlan *plan = [_wantPlans objectAtIndex:indexPath.row];
    _selectedRow = indexPath.row;
    
    XDPostPlanViewController *editPlanVC = [[XDPostPlanViewController alloc] initWithEditPlan:plan];
    [self.navigationController presentViewController:editPlanVC animated:YES completion:nil];
}

#pragma mark - notification

- (void)newPlanFinish:(NSNotification *)notification
{
    id object = [notification object];
    if ([object isKindOfClass:[WantPlan class]]) {
        WantPlan *plan = (WantPlan *)object;
        
        NSInteger insertRow = [_wantPlans count];
        [self addPlanToSource:plan];
        [self insertPlanToTableViewWithRow:insertRow];
    }
}

- (void)editPlanFinish:(NSNotification *)notification
{
    [self updateTableViewWithRow:_selectedRow];
}

#pragma mark - GestureRecognizer

- (void)leftSwipe:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.state == UIGestureRecognizerStateEnded) {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:[swipe locationInView:self.tableView]];
        XDAllPlansCell *cell = (XDAllPlansCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.editing == YES) {
            [cell showDapAnimation];
            return;
        }
        
        if(_selectedRow > -1)
        {
            XDAllPlansCell *oldCell = (XDAllPlansCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]];
            [oldCell setEditing:NO];
        }
        
        _selectedRow = indexPath.row;
        [cell setEditing:YES];
    }
}

- (void)tapActionPlan:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded) {
        XDPlanDetailViewController *planDetailVC = [[XDPlanDetailViewController alloc] initWithStyle:UITableViewStylePlain action:NO];
        planDetailVC.planContent = _actionPlan.content;
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
                                                              self.title = @"想做的事";
                                                              [_menuItem setImage:[UIImage imageNamed:@"menu_allPlans.png"]];
                                                              self.navigationItem.rightBarButtonItem = _createItem;
                                                          }];
        
        REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"正在进行的事"
                                                           subtitle:@"贪多嚼不烂哦，专心做一件事情吧"
                                                              image:[UIImage imageNamed:@"menu_actionPlan.png"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 NSLog(@"Item: %@", item);
                                                                 self.title = @"正在进行的事";
                                                                 [_menuItem setImage:[UIImage imageNamed:@"menu_actionPlan.png"]];
                                                                 self.navigationItem.rightBarButtonItem = nil;
                                                             }];
        
        REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"今天的计划"
                                                            subtitle:@"想做些什么呢？坚持进行下去吧"
                                                               image:[UIImage imageNamed:@"menu_todayPlan.png"]
                                                    highlightedImage:nil
                                                              action:^(REMenuItem *item) {
                                                                  NSLog(@"Item: %@", item);
                                                                  self.title = @"今天的计划";
                                                                  [_menuItem setImage:[UIImage imageNamed:@"menu_todayPlan.png"]];
                                                                  self.navigationItem.rightBarButtonItem = nil;
                                                              }];
        
        REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"设置"
                                                              image:[UIImage imageNamed:@"menu_setting.png"]
                                                   highlightedImage:nil
                                                             action:^(REMenuItem *item) {
                                                                 NSLog(@"Item: %@", item);
                                                                 self.title = @"设置";
                                                                 [_menuItem setImage:[UIImage imageNamed:@"menu_setting.png"]];
                                                                 self.navigationItem.rightBarButtonItem = nil;
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

#pragma mark - item/button action

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
    NSInteger count = [_wantPlans count] + 1;
    if (count > KPLAN_MAXEVENTCOUNT) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"对不起" message:@"你已经添加了20件想做的事，完成这些再添加吧" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    XDPostPlanViewController *newPlanVC = [[XDPostPlanViewController alloc] initWithCreateNew];
    [self.navigationController presentViewController:newPlanVC animated:YES completion:nil];
}

#pragma mark - manager

- (void)addPlanToSource:(WantPlan *)plan
{
    [_wantPlans addObject:plan];
}

- (void)deletePlanFromSource:(NSInteger)row
{
    WantPlan *deletePlan = [_wantPlans objectAtIndex:row];
    [deletePlan MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [_wantPlans removeObjectAtIndex:row];
}

- (void)insertPlanToTableViewWithRow:(NSInteger)row
{
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

- (void)deletePlanToTableViewWithRow:(NSInteger)row
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
}

- (void)updateTableViewWithRow:(NSInteger)row
{
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:row inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end
