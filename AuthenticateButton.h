//
//  AuthenticateButton.h
//  ejianzhi
//
//  Created by 小哥 on 15/6/20.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticateButton : UIButton

@property (nonatomic, retain) UIImageView *ig;
@property (nonatomic, retain) UILabel *titlLabel;

- (AuthenticateButton *)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName andtitle:(NSString *)title andtitleColor:(UIColor *)color;

@end
