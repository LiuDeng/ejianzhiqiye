//
//  EvaluateViewController.h
//  ejianzhi
//
//  Created by 小哥 on 15/7/16.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateViewController : UIViewController
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userAge;
@property (strong, nonatomic) NSString *userHeight;
@property (strong, nonatomic) NSString *userGender;
@property (strong, nonatomic) NSString *userSchool;
@property (strong, nonatomic) NSString *userMajor;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *expectJob;

@property (strong, nonatomic) UILabel *userNameLabel;
@property (strong, nonatomic) UILabel *userAgeLabel;
@property (strong, nonatomic) UILabel *userHeightLabel;
@property (strong, nonatomic) UILabel *userGenderLabel;
@property (strong, nonatomic) UILabel *userSchoolLabel;
@property (strong, nonatomic) UILabel *userMajorLabel;

@end
