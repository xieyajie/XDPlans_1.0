//
//  XDNewPlanViewController.m
//  XDPlans
//
//  Created by xieyajie on 13-9-15.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDNewPlanViewController.h"

#import "RichTextEditor.h"
#import "XDPlanLocalDefault.h"

@interface XDNewPlanViewController ()<UITextViewDelegate>
{
    UILabel *_numberLabel;
}

@property (nonatomic, strong) UITextView *textView;

@end

@implementation XDNewPlanViewController

@synthesize textView = _textView;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    topBar.tintColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
    [self.view addSubview:topBar];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:@"添加想做的事" style:UIBarButtonItemStylePlain target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleBordered target:self action:@selector(done:)];
    [topBar setItems:[NSArray arrayWithObjects:backItem, flexibleItem, titleItem, flexibleItem, doneItem, nil] animated:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:221 / 255.0 blue:212 / 255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 10 - 40, 64, 40, 20)];
    label.text = @" 个字";
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x - 40, 64, 40, 20)];
    _numberLabel.backgroundColor = [UIColor clearColor];
    _numberLabel.text = [NSString stringWithFormat:@"%i", KPLAN_CONTENT_MAXLENGHT];
    _numberLabel.textAlignment = KTextAlignmentRight;
    [self.view addSubview:_numberLabel];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(_numberLabel.frame.origin.x - 40, 64, 40, 20)];
    label2.text = @"剩余 ";
    label2.font = [UIFont systemFontOfSize:16.0];
    label2.textColor = [UIColor grayColor];
    label2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label2];
    
    [self.view addSubview:self.textView];
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - get

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 90, self.view.frame.size.width - 20, 100)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.layer.borderWidth = 1.0;
        _textView.layer.borderColor = [[UIColor grayColor] CGColor];
        _textView.font = [UIFont systemFontOfSize:17.0];
        _textView.delegate = self;
    }
    
    return _textView;
}

#pragma mark - items action

- (void)back:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)done:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_PLANNEWFINISH object:[self.textView text]];
    [self dismissModalViewControllerAnimated:YES];
}

@end
