//
//  HelpViewController.h
//  ejianzhi
//
//  Created by 小哥 on 15/6/27.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HelpViewControllerDelegate <NSObject>

- (void)hideHelpViewController;

@end

@interface HelpViewController : UIViewController
@property (nonatomic, weak) id<HelpViewControllerDelegate> delegate;
@end
