//
//  XDColorViewController.h
//  XDPlans
//
//  Created by xieyajie on 13-9-6.
//  Copyright (c) 2013年 XD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XDColorViewControllerDelegate <NSObject>

@required
- (void)colorPickerSlectedColor:(UIColor *)color key:(NSString *)key withCaller:(id)caller;

@end

@interface XDColorViewController : UITableViewController

@property (nonatomic, unsafe_unretained) id<XDColorViewControllerDelegate> delegate;

@property (nonatomic, strong) id callerObject;

@property (nonatomic, strong) NSString *colorKey;

@end
