//
//  XDAccountLoginViewControllers.m
//  XDPlans
//
//  Created by xieyajie on 13-9-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#define KACCOUNT_TAG_USERNAME 100
#define KACCOUNT_TAG_EMAIL 99
#define KACCOUNT_TAG_PASSWORD 98

#import <QuartzCore/QuartzCore.h>
#import "XDAccountLoginViewController.h"

#import "XDCutImageViewController.h"
#import "XDManagerHelper.h"
#import "XDPlanLocalDefault.h"

@interface XDAccountLoginViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIButton *_headerButton;
    
    UITextField *_nameField;
    UITextField *_emailField;
    UITextField *_passwordField;
    
    UIImage *_headerImage;
}

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation XDAccountLoginViewController

@synthesize imagePicker = _imagePicker;

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
    
    self.title = @"注册 / 登陆";
    self.view.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:221 / 255.0 blue:212 / 255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _headerImage = [UIImage imageNamed:@"userLoginDefault.png"];
    
    //tableHeaderView
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    _headerButton = [[UIButton alloc] initWithFrame:CGRectMake((headerView.frame.size.width - KUSER_HEADERIMAGE_WIDTH) / 2, (headerView.frame.size.height - KUSER_HEADERIMAGE_HEIGHT) / 2, KUSER_HEADERIMAGE_WIDTH, KUSER_HEADERIMAGE_HEIGHT)];
    [_headerButton setImage:[UIImage imageNamed:@"userLogoutDefault.png"] forState:UIControlStateNormal];
    _headerButton.layer.cornerRadius = KUSER_HEADERIMAGE_WIDTH / 2;
    _headerButton.layer.masksToBounds = YES;
    _headerButton.layer.borderWidth = 2.0f;
    _headerButton.layer.borderColor = [[UIColor colorWithRed:139 / 255.0 green:142 / 255.0 blue:147 / 255.0 alpha:1.0] CGColor];
    [_headerButton addTarget:self action:@selector(chooseHeaderImage:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:_headerButton];
    [self.tableView setTableHeaderView:headerView];
    
    //tableFootView
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame = CGRectMake((160 - 100) / 2, 10, 100, 40);
    [registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    registerButton.layer.cornerRadius = 10.0;
    registerButton.layer.masksToBounds = YES;
    registerButton.layer.borderWidth = 2.0f;
    registerButton.layer.borderColor = [[UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0] CGColor];
    registerButton.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [footView addSubview:registerButton];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(160 + 60 / 2, 10, 100, 40);
    [loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    loginButton.layer.cornerRadius = 10.0;
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.borderWidth = 2.0f;
    loginButton.layer.borderColor = [[UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0] CGColor];
    loginButton.backgroundColor = [UIColor colorWithRed:123 / 255.0 green:171 / 255.0 blue:188 / 255.0 alpha:1.0];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [footView addSubview:loginButton];
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, footView.frame.size.width, 40)];
    footLabel.backgroundColor = [UIColor clearColor];
    footLabel.font = [UIFont boldSystemFontOfSize:12.0];
    footLabel.textAlignment = KTextAlignmentCenter;
    footLabel.textColor = [UIColor grayColor];
    footLabel.text = @"欢迎使用 XDPlans ,该产品由XDStudio出品";
    [footView addSubview:footLabel];
    
    [self.tableView setTableFooterView:footView];
    
    [self initTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cutImageFinish:) name:KNOTIFICATION_CUTFINISH object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;//过渡类型,有四种
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//打开相册
        _imagePicker.allowsEditing = NO;//禁止对图片进行编辑
    }
    
    return _imagePicker;
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view removeFromSuperview];
    
            break;
        }
    }
    
    switch (100 - indexPath.row) {
        case KACCOUNT_TAG_USERNAME:
            [cell.contentView addSubview:_nameField];
            break;
        case KACCOUNT_TAG_EMAIL:
            [cell.contentView addSubview:_emailField];
            break;
        case KACCOUNT_TAG_PASSWORD:
            [cell.contentView addSubview:_passwordField];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIImagePicker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _headerImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary && _headerImage != nil)
    {
        [self.imagePicker dismissViewControllerAnimated:YES completion:^{
            if (_headerImage.size.width > KUSER_HEADERIMAGE_WIDTH * 2 || _headerImage.size.height > KUSER_HEADERIMAGE_HEIGHT * 2)
            {
                XDCutImageViewController *cutVC = [[XDCutImageViewController alloc] initWithImage:_headerImage];
                [self.navigationController presentViewController:cutVC animated:YES completion:^{
                }];
            }
            else{
                [_headerButton setImage:_headerImage forState:UIControlStateNormal];
            }
        }];
    }
}

#pragma mark - notification

- (void)cutImageFinish:(NSNotification *)notification
{
    id object = notification.object;
    if (object != nil && [object isKindOfClass:[UIImage class]]) {
        _headerImage = (UIImage *)object;
        [_headerButton setImage:_headerImage forState:UIControlStateNormal];
    }
}


#pragma mark - button/item action

- (void)chooseHeaderImage:(id)sender
{
    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)registerAction:(id)sender
{
    if ([self checkUserInfo]) {
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGIN object:_headerImage];
    }
}

- (void)loginAction:(id)sender
{
    if ([self checkUserInfo]) {
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGIN object:_headerImage];
    }
}

#pragma mark - private

- (void)initTextField
{
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, self.tableView.frame.size.width - 40, 40)];
    _nameField.delegate = self;
    _nameField.tag = KACCOUNT_TAG_USERNAME;
    _nameField.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nameField.leftViewMode = UITextFieldViewModeAlways;
    _nameField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_contacts.png"]];
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.placeholder = @"用户名（5-20位）";
    _nameField.returnKeyType = UIReturnKeyDone;
    
    _emailField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, self.tableView.frame.size.width - 40, 40)];
    _emailField.delegate = self;
    _emailField.tag = KACCOUNT_TAG_EMAIL;
    _emailField.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    _emailField.borderStyle = UITextBorderStyleRoundedRect;
    _emailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _emailField.leftViewMode = UITextFieldViewModeAlways;
    _emailField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_email.png"]];
    _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailField.placeholder = @"常用邮箱";
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.returnKeyType = UIReturnKeyDone;
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, self.tableView.frame.size.width - 40, 40)];
    _passwordField.delegate = self;
    _passwordField.tag = KACCOUNT_TAG_PASSWORD;
    _passwordField.secureTextEntry = YES;
    _passwordField.backgroundColor = [UIColor colorWithRed:247 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0];
    _passwordField.borderStyle = UITextBorderStyleRoundedRect;
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"account_password.png"]];
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.placeholder = @"密码（5-20位）";
    _passwordField.returnKeyType = UIReturnKeyDone;
}

- (BOOL)checkUserInfo
{
    UIAlertView *alertView = nil;
    NSString *message = @"";
    BOOL result = YES;
    
    //长度
    if (_nameField.text.length < 5 || _nameField.text.length > 20) {
        message = @"用户名需要5-20位";
        result = NO;
    }
    else if(_emailField.text.length == 0)
    {
        message = @"邮箱不能为空";
        result = NO;
    }
    else if (_passwordField.text.length < 5 || _passwordField.text.length > 20)
    {
        message = @"密码需要5-20位";
        result = NO;
    }
    
    if (!result) {
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return result;
    }
    
    //格式
    result = [XDManagerHelper isEmail:_emailField.text];
    if (!result) {
        message = @"邮箱格式错误";
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return result;
    }
    
    return YES;
}

@end
