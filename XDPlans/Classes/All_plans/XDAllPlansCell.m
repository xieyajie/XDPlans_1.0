//
//  XDAllPlansCell.m
//  XDPlans
//
//  Created by xieyajie on 13-9-3.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDAllPlansCell.h"

#import "XDCircleProgressBar.h"

@interface XDAllPlansCell()

@end

@implementation XDAllPlansCell

@synthesize delegate = _delegate;

@synthesize index = _index;
//@synthesize finish;

@synthesize progressValue = _progressValue;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _actionButton.backgroundColor = [UIColor clearColor];
        _actionButton.frame = CGRectMake(0, 0, 40, 40 + 10);
        _actionButton.contentMode = UIViewContentModeScaleAspectFit;
        [_actionButton addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_actionButton];
        
        _contentTextView = [[UILabel alloc] initWithFrame:CGRectMake(_actionButton.frame.origin.x + _actionButton.frame.size.width, 5, 320 - 90, 40)];
        _contentTextView.numberOfLines = 0;
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.textColor = [UIColor blackColor];
        _contentTextView.font = [UIFont systemFontOfSize:16.0];
        [self.contentView addSubview:_contentTextView];
        
        _operateView = [[UIView alloc] initWithFrame:CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width, 0, self.frame.size.width - (_contentTextView.frame.origin.x + _contentTextView.frame.size.width), 40 + 10)];
        _operateView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_operateView];
        
        _progressBar = [[XDCircleProgressBar alloc] initWithFrame:CGRectMake(0, 0, 50, _operateView.frame.size.height)];
        _progressBar.backgroundColor = [UIColor clearColor];
        [_progressBar addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
        _progressBar.userInteractionEnabled = NO;
        [_operateView addSubview:_progressBar];
        
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(_progressBar.frame.origin.x + _progressBar.frame.size.width, 0, 50, _operateView.frame.size.height)];
        _deleteButton.backgroundColor = [UIColor redColor];
        [_deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton setImage:[UIImage imageNamed:@"plans_delete.png"] forState:UIControlStateNormal];
        
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(_deleteButton.frame.origin.x + _deleteButton.frame.size.width, 0, 50, _operateView.frame.size.height)];
        _editButton.backgroundColor = [UIColor greenColor];
        [_editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [_editButton setImage:[UIImage imageNamed:@"plans_edit.png"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEditing:(BOOL)editing
{
    [super setEditing:editing];
    
    if (editing) {
        [UIView animateWithDuration:.5 animations:^{
            _progressBar.userInteractionEnabled = YES;
            _progressBar.backgroundColor = [UIColor yellowColor];
            [_operateView addSubview:_deleteButton];
            [_operateView addSubview:_editButton];
            
            _contentTextView.frame = CGRectMake(_actionButton.frame.origin.x + _actionButton.frame.size.width, 5, 320 - 190, _actionButton.frame.size.height - 10);
            _operateView.frame = CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width, 0, self.frame.size.width - (_contentTextView.frame.origin.x + _contentTextView.frame.size.width), _actionButton.frame.size.height);
        }];
    }
    else{
        [UIView animateWithDuration:.5 animations:^{
            _progressBar.userInteractionEnabled = NO;
            _contentTextView.frame = CGRectMake(_actionButton.frame.origin.x + _actionButton.frame.size.width, 5, 320 - 90, _actionButton.frame.size.height - 10);
            _operateView.frame = CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width, 0, self.frame.size.width - (_contentTextView.frame.origin.x + _contentTextView.frame.size.width), _actionButton.frame.size.height);
        } completion:^(BOOL finish){
            _progressBar.backgroundColor = [UIColor clearColor];
            [_deleteButton removeFromSuperview];
            [_editButton removeFromSuperview];
        }];
    }
}

#pragma mark - get

#pragma mark - set

- (void)setIndex:(NSInteger)aIndex
{
    _index = aIndex;
}

- (void)setContent:(NSString *)aContent
{
    _content = aContent;
    _contentTextView.text = aContent;
    CGSize size = [aContent sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:CGSizeMake((320 - 110), 600) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height > 40 ? size.height : 40;
    
    if (height > 40) {
        _actionButton.frame = CGRectMake(0, 0, 40, height + 10);
        _contentTextView.frame = CGRectMake(_actionButton.frame.origin.x + _actionButton.frame.size.width, 5, 320 - 90, height);
        _operateView.frame = CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width, 0, self.frame.size.width - (_contentTextView.frame.origin.x + _contentTextView.frame.size.width), height + 10);
        
        _progressBar.frame = CGRectMake(0, 0, 50, _operateView.frame.size.height);
        _deleteButton.frame = CGRectMake(_progressBar.frame.origin.x + _progressBar.frame.size.width, 0, 50, _operateView.frame.size.height);
        _editButton.frame = CGRectMake(_deleteButton.frame.origin.x + _deleteButton.frame.size.width, 0, 50, _operateView.frame.size.height);
    }
}

- (void)setAction:(BOOL)aAction
{
    _action = aAction;
    if (aAction) {
        [_actionButton setImage:[UIImage imageNamed:@"plans_action.png"] forState:UIControlStateNormal];
        [_actionButton setTintColor:[UIColor redColor]];
    }
    else{
        [_actionButton setImage:[UIImage imageNamed:@"plans_unaction.png"] forState:UIControlStateNormal];
    }
}

//- (void)setFinish:(BOOL)aFinish
//{
//    if (aFinish) {
//        self.contentView.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0];
//    }
//    else{
//        self.contentView.backgroundColor = [UIColor whiteColor];
//    }
//}

- (void)setProgressValue:(CGFloat)value
{
    _progressValue = value;
    
    NSString *str = [NSString stringWithFormat:@"%.0f", value * 100];
    [_progressBar setPercent:[str integerValue] animated:YES];
}

#pragma mark - operate

- (void)actionClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(plansCellActionClick:)]) {
        [_delegate plansCellActionClick:self];
    }
}

- (void)finishAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(plansCellFinishAction:)]) {
        [_delegate plansCellFinishAction:self];
    }
}

- (void)deleteAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(plansCellDeleteAction:)]) {
        [_delegate plansCellDeleteAction:self];
    }
}

- (void)editAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(plansCellEditAction:)]) {
        [_delegate plansCellEditAction:self];
    }
}

#pragma mark - public

- (void)showDapAnimation
{
    if (self.editing) {
        [UIView animateWithDuration:.5f animations:^{
            _operateView.frame = CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width - 10, 0, self.frame.size.width - (_contentTextView.frame.origin.x + _contentTextView.frame.size.width - 10), _actionButton.frame.size.height);
        } completion:^(BOOL finish){
            _operateView.frame = CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width, 0, self.frame.size.width - (_contentTextView.frame.origin.x + _contentTextView.frame.size.width), _actionButton.frame.size.height);
        }];
    }
}



@end
