//
//  ShareInfo.h
//  ejianzhi
//
//  Created by 小哥 on 15/6/16.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareInfo : NSObject
+(ShareInfo *)sharedSingleton;

@property (nonatomic, assign) BOOL isThirdLogin;

@end
