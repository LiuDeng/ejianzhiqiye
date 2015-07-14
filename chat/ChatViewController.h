/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import <UIKit/UIKit.h>
#import "EMChatManagerDefs.h"

@protocol ChatViewControllerDelegate <NSObject>

- (NSString *)avatarWithChatter:(NSString *)chatter;
- (NSString *)nickNameWithChatter:(NSString *)chatter;

@end

@interface ChatViewController : UIViewController
@property (strong, nonatomic, readonly) NSString *chatter;
@property (nonatomic) BOOL isInvisible;
@property (nonatomic, assign) id <ChatViewControllerDelegate> delelgate;
//环信
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

@property (strong ,nonatomic)NSString *detailInfo;

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type;

- (void)reloadData;

- (void)hideImagePicker;

@end
