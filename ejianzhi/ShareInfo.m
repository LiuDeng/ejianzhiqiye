//
//  ShareInfo.m
//  ejianzhi
//
//  Created by 小哥 on 15/6/16.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "ShareInfo.h"
static ShareInfo *sharedSingleton = nil;
@implementation ShareInfo
+(ShareInfo *)sharedSingleton{
    @synchronized(self)
    {
        if (!sharedSingleton){
            sharedSingleton = [[ShareInfo alloc] init];
            
        }
        
    }
    
    return sharedSingleton;
}
@end
