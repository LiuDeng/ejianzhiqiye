//
//  AppDelegate.h
//  EJianZhi
//
//  Created by RAY on 14/12/23.c
//  Copyright (c) 2014年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQKeyboardManager.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MLTabbarVC.h"
#import "MLTabbar1.h"

enum PUSHTYPE {
    qiyeValidate = 1,
    studentValidate = 2,
    notification = 3,
    jobdetail = 4,
    wap
};

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)MLTabbarVC *mainTabViewController;
@property (strong,nonatomic)MLTabbar1 *qiyeTabViewController;
@end

