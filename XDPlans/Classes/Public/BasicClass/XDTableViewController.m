//
//  XDTableViewController.m
//  XDHoHo
//
//  Created by xieyajie on 13-12-2.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import "XDTableViewController.h"

#import "UINavigationItem+Category.h"

@interface XDTableViewController ()

@end

@implementation XDTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configurationNavigationBar];
    self.tableView.backgroundColor = [UIColor whiteColor];
//    self.tableView.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:242 / 255.0 alpha:1.0];
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - public

- (void)setTitle:(NSString *)title
{
    [self.navigationItem setCustomTitle:title];
}

- (void)setBackItem
{
    [self.navigationItem setBackItemWithTarget:self action:@selector(back:)];
}

- (void)back:(id)sender
{
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else if ([self respondsToSelector:@selector(dismissModalViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)configurationNavigationBar
{
    
}

@end
