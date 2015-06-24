//
//  AuthenticateButton.m
//  ejianzhi
//
//  Created by 小哥 on 15/6/20.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "AuthenticateButton.h"

@implementation AuthenticateButton

-(void)awakeFromNib
{
    _ig = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 70, 70)];
    [self addSubview:_ig];
    
    _titlLabel = [[UILabel alloc] initWithFrame:CGRectMake(70+30+30, 43, 200, 44)];
    _titlLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titlLabel];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _ig = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 70, 70)];
        [self addSubview:_ig];
        
        _titlLabel = [[UILabel alloc] initWithFrame:CGRectMake(70+30+30, 43, frame.size.width-70+30+30, 44)];
        _titlLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titlLabel];
    }
    return self;
}

-(AuthenticateButton *)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName andtitle:(NSString *)title andtitleColor:(UIColor *)color
{
    if (self = [super initWithFrame:frame])
    {
        _ig = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, 70, 70)];
        _ig.image = [UIImage imageNamed:imageName];
        [self addSubview:_ig];
        
        _titlLabel = [[UILabel alloc] initWithFrame:CGRectMake(70+30+30, 43, frame.size.width-70+30+30, 44)];
        _titlLabel.backgroundColor = [UIColor clearColor];
        _titlLabel.text = title;
        _titlLabel.textColor = color;
        [self addSubview:_titlLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
