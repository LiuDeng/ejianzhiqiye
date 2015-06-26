//
//  JobListTableViewCell.m
//  EJianZhi
//
//  Created by Mac on 1/24/15.
//  Copyright (c) 2015 麻辣工作室. All rights reserved.
//

#import "JobListTableViewCell.h"

@implementation JobListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.IconView.type=WithOutBadge;
    self.IconView.backgroundColor=GreenFillColor;
    //设置圆角
    [self.IconView.layer setMasksToBounds:YES];
    [self.IconView.layer setCornerRadius:10.0f];
    
//    self.distanceLabelWithinUnitLabel.layer.masksToBounds=YES;
//    self.distanceLabelWithinUnitLabel.backgroundColor = [UIColor lightGrayColor];
//    self.distanceLabelWithinUnitLabel.layer.cornerRadius = 10;
    [self.priceLabel sizeToFit];
    self.updateTimeLabel.textColor=[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1];
     self.keyConditionLabel.textColor=[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    self.distanceView.layer.masksToBounds=YES;
    self.distanceView.layer.cornerRadius=12;
    self.distanceView.backgroundColor=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    self.distanceLabel.textColor=[UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1];
    self.bottomLineView.backgroundColor=[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    self.keyConditionLabel.textColor=[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    self.titleLabel.textColor=[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    self.priceLabel.textColor=[UIColor colorWithRed:227/255.0 green:75/255.0 blue:92/255.0 alpha:1];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setInsuranceImageShow:(BOOL)ishidden
{
    self.Icon1ImageView.hidden=ishidden;
}


- (void)setWeekendImageShow:(BOOL)ishidden
{
    self.Icon2ImageView.hidden=ishidden;
    
}
- (void)setotherImageShow:(BOOL)ishidden
{
    
    self.Icon3ImageView.hidden=ishidden;
    
}

- (void)setIconBackgroundColor:(UIColor*)color
{
    if(color==nil) self.IconView.backgroundColor=GreenFillColor;
    else self.IconView.backgroundColor=color;
}

@end
