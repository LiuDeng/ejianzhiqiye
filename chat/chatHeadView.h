//
//  chatHeadView.h
//  ejianzhi
//
//  Created by Mac on 15/7/11.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chatHeadView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userGender;
@property (weak, nonatomic) IBOutlet UILabel *userAge;
@property (weak, nonatomic) IBOutlet UILabel *userHeight;
@property (weak, nonatomic) IBOutlet UILabel *userSchool;
@property (weak, nonatomic) IBOutlet UILabel *userSpecial;
@end
