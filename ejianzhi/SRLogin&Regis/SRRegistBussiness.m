//
//  SRRegistBussiness.m
//  Health
//
//  Created by Mac on 6/4/14.
//  Copyright (c) 2014 RADI Team. All rights reserved.
//

#import "SRRegistBussiness.h"
#import "EaseMob.h"
@implementation SRRegistBussiness
@synthesize feedback;
@synthesize username;
@synthesize pwd;
@synthesize phone;

-(void)NewUserRegistInBackground:(NSString*)_username Pwd:(NSString*)_password Phone:(NSString *)_phone{
  

    
    
    AVUser *user = [AVUser user];
    user.username = _username;
    user.password = _password;
    [user setObject:_phone forKey:@"mobilePhoneNumber"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self RegistHasSucceed];
            //注册成功保存用户数据
            
            NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
            [mySettingData setObject:_username forKey:@"currentUserName"];
            [mySettingData synchronize];
            
            [user setObject:[NSNumber numberWithInteger:self.registerType] forKey:@"userType"];
            [user saveEventually];
            //环信号注册
            /////////////////////////////
            [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:user.objectId password:_password withCompletion:^(NSString *username, NSString *password, EMError *error) {
                NSLog(@"%@",user.objectId);
                NSLog(@"环信号注册成功");
            } onQueue:nil];
        }
        
//            [EaseMob  sharedInstance].chatManager asyncRegisterNewAccount:@"8005" password:@"111111" withCompletion:^(NSString *username, NSString *password, EMError *error) {
//                if (!error) {
//                    NSLog(@"注册成功");
//                    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:@"8005" password:@"111111" completion:^(NSDictionary *loginInfo, EMError *error) {
//                        if (!error && loginInfo) {
//                            NSLog(@"登陆成功");
//                        }
//                    } onQueue:nil];
//                }
// 
//            
            
            
            
            
            
            
            
            
/////////////////////////////
         else {
            [self RegistHasFailed:error];
        }
    }];
    
}

-(void) RegistHasFailed:(NSError*)error
{
    if (error.code==214)
        self.feedback=@"用户名已被注册";

    [self.registerDelegate registerComplete:NO];
}

-(void) RegistHasSucceed
{
    self.feedback=@"注册成功";
    [self.loginManager setLoginState:active];
    [self.registerDelegate registerComplete:YES];
}




@end
