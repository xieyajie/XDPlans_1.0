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
#import "XDPlanLocalDefault.h"

#define KPLANS_INDEX @"index"
#define KPLANS_CONTENT @"content"
#define KPLANS_ACTION @"action"

@interface XDAllPlansViewController ()<UIAlertViewDelegate>
{
    NSMutableDictionary *_dataSource;

    UIBarButtonItem *_createItem;
    UIBarButtonItem *_moveItem;
    
    UILongPressGestureRecognizer *_longPress;
}

@end

@implementation XDAllPlansViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableDictionary dictionary];
        
        //test
        NSMutableDictionary *eventDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], KPLANS_INDEX, @"爬山", KPLANS_CONTENT, [NSNumber numberWithBool:NO], KPLANS_ACTION, nil];
        [_dataSource setObject:eventDic1 forKey:[NSString stringWithFormat:@"%i", 0]];
        
        NSMutableDictionary *eventDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], KPLANS_INDEX, @"睡觉", KPLANS_CONTENT, [NSNumber numberWithBool:YES], KPLANS_ACTION, nil];
        [_dataSource setObject:eventDic2 forKey:[NSString stringWithFormat:@"%i", 1]];
        
        NSMutableDictionary *eventDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0], KPLANS_INDEX, @"游乐园", KPLANS_CONTENT, [NSNumber numberWithBool:NO], KPLANS_ACTION, nil];
        [_dataSource setObject:eventDic3 forKey:[NSString stringWithFormat:@"%i", 2]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.title = @"想做的事";
    [self layoutNavigationBar];
    
    self.view.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:221 / 255.0 blue:212 / 255.0 alpha:1.0];
    self.tableView.separatorColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.tableView addGestureRecognizer:_longPress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPlanFinish:) name:KNOTIFICATION_PLANNEWFINISH object:nil];
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

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
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
    return YES;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [_dataSource objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];
    NSString *content = [dic objectForKey:KPLANS_CONTENT];
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake((320 - 110), 600) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height > 40 ? size.height : 40;
    return height + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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

#pragma mark - layout subviews

- (void)layoutNavigationBar
{
    if (_createItem == nil) {
        _createItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createEvent:)];
    }
    
    self.navigationItem.rightBarButtonItem = _createItem;
}

#pragma mrk - item/button action

- (void)createEvent:(id)sender
{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加想做的事" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
//    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
//    
//    [alertView show];
    
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
