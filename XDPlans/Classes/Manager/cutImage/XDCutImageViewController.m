//
//  XDCutImageViewController.m
//  XDPlans
//
//  Created by xie yajie on 13-9-4.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "XDCutImageViewController.h"

@interface XDCutImageViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImage *_originalImage;
    UIImageView *_imageView;
    UIView *_imageCutView;
    
    CGRect _imageContentFrame;
    CGSize _maxCutBound;
    
    CGPoint _prevPoint;
    CGPoint _nextPoint;
}

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation XDCutImageViewController

@synthesize imagePicker = _imagePicker;

- (id)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        // Custom initialization
        _originalImage = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.e
    UIToolbar *topBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    topBar.tintColor = [UIColor colorWithRed:143 / 255.0 green:183 / 255.0 blue:198 / 255.0 alpha:1.0];
    [self.view addSubview:topBar];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"重选图片" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseAction:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction:)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"剪切" style:UIBarButtonItemStyleBordered target:self action:@selector(doneAction:)];
    [topBar setItems:[NSArray arrayWithObjects:backItem, flexibleItem, cancelItem, doneItem, nil] animated:YES];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, topBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 44)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.image = _originalImage;
    [self.view addSubview:_imageView];
    
    _imageContentFrame = [self convertSize:_originalImage.size toView:_imageView];
    
    _imageCutView = [[UIView alloc] initWithFrame:CGRectMake(_imageView.frame.size.width / 2 - KUSER_HEADERIMAGE_WIDTH, _imageView.frame.size.height / 2 - KUSER_HEADERIMAGE_HEIGHT, KUSER_HEADERIMAGE_WIDTH * 2, KUSER_HEADERIMAGE_HEIGHT * 2)];
    _imageCutView.backgroundColor = [UIColor clearColor];
    _imageCutView.layer.borderWidth = 1.0;
    _imageCutView.layer.borderColor = [[UIColor redColor] CGColor];
    [self.view addSubview:_imageCutView];
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

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _prevPoint = [touch locationInView:_imageCutView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _nextPoint = [touch locationInView:_imageCutView];
    
    CGFloat yMargin = _nextPoint.y - _prevPoint.y;
    CGFloat xMargin = _nextPoint.x - _prevPoint.x;
    
    if (yMargin * yMargin + xMargin * xMargin > 20 * 20)
    {
        CGRect rect = _imageCutView.frame;
        CGFloat toX = rect.origin.x + xMargin;
        if (toX < _imageContentFrame.origin.x) {
            toX = _imageContentFrame.origin.x;
        }
        else if (toX > _imageContentFrame.origin.x + _imageContentFrame.size.width - rect.size.width)
        {
            toX = _imageContentFrame.origin.x + _imageContentFrame.size.width - rect.size.width;
        }
        
        CGFloat toY = rect.origin.y + yMargin;
        if (toY < _imageContentFrame.origin.y) {
            toY = _imageContentFrame.origin.y;
        }
        else if (toY > _imageContentFrame.origin.y + _imageContentFrame.size.height - rect.size.height){
            toY = _imageContentFrame.origin.y + _imageContentFrame.size.height - rect.size.height;
        }
        
        _imageCutView.frame = CGRectMake(toX, toY, rect.size.width, rect.size.height);
        _prevPoint = _nextPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark - UIImagePicker delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];//获取图片
    _imageView.image = _originalImage;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary && _originalImage != nil)
    {
        [self.imagePicker dismissViewControllerAnimated:YES completion:^{
            _imageContentFrame = [self convertSize:_originalImage.size toView:_imageView];
        }];
    }
}


#pragma mark - private

//转换成在bgView页面中的frme(居中显示)
- (CGRect)convertSize:(CGSize)size toView:(UIView *)toView
{
    //计算出选择框的最大大小
    _maxCutBound = CGSizeMake(KUSER_HEADERIMAGE_WIDTH * 2, KUSER_HEADERIMAGE_HEIGHT * 2);
    CGSize toSize = size;
    CGFloat subScale = size.width / size.height;
    CGFloat toScale = toView.frame.size.width / toView.frame.size.height;
    if (subScale > toScale) {
        toSize = CGSizeMake(toView.frame.size.width, toView.frame.size.width / subScale);
    }
    else{
        toSize = CGSizeMake(toView.frame.size.height * subScale, toView.frame.size.height);
    }
    
    int toWidth = toSize.width;
    int toHeight = toSize.height;
     _maxCutBound = CGSizeMake(toWidth, toHeight);
    return CGRectMake(toView.frame.origin.x + (toView.frame.size.width - toWidth) / 2, toView.frame.origin.y + (toView.frame.size.height - toHeight) / 2, toWidth, toHeight);
}

#pragma mark - item action

- (void)chooseAction:(id)sender
{
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CUTFINISH object:nil];
    }];
}

- (void)doneAction:(id)sender
{
    CGRect cropRect = CGRectMake(fabsf(_imageContentFrame.origin.x - _imageCutView.frame.origin.x) / _imageContentFrame.size.width * _originalImage.size.width, fabsf(_imageContentFrame.origin.y - _imageCutView.frame.origin.y) / _imageContentFrame.size.height * _originalImage.size.height, _imageCutView.frame.size.width / _imageContentFrame.size.width * _originalImage.size.width, _imageCutView.frame.size.height / _imageContentFrame.size.height * _originalImage.size.height);
    CGImageRef tmp = CGImageCreateWithImageInRect([_originalImage CGImage], cropRect);
    __block UIImage *image = [UIImage imageWithCGImage:tmp scale:_originalImage.scale orientation:_originalImage.imageOrientation];
    CGImageRelease(tmp);
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CUTFINISH object:image];
    }];
}

@end
