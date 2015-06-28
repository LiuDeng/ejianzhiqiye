//
//  MLTabbarVC.h
//  EJianZhi
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLFirstVC.h"
#import "MLChatVC.h"
#import "MLForthVC.h"
@interface MLTabbarVC : UITabBarController
+(MLTabbarVC*)shareInstance;
@property (strong,nonatomic)MLFirstVC *firstVC;
//@property (strong,nonatomic)MLSecondVC *secondVC;
@property (strong,nonatomic)MLChatVC *chatVC;
@property (strong,nonatomic)MLForthVC *forthVC;
@end
