//
//  MLJobDetailViewModel.m
//  EJianZhi
//
//  Created by Mac on 3/23/15.
//  Copyright (c) 2015 &#40635;&#36771;&#24037;&#20316;&#23460;. All rights reserved.
//

#import "MLJobDetailViewModel.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "MLMapManager.h"
#import "AJLocationManager.h"
#import "MapViewController.h"

@interface MLJobDetailViewModel()

@property (weak,nonatomic) MLMapManager *mapManager;
@property (weak,nonatomic) AJLocationManager *locationManager;
@property (strong,nonatomic)UIViewController *presentedViewController;
@end

@implementation MLJobDetailViewModel

- (MLMapManager*)mapManager
{
    if (_mapManager==nil) {
        _mapManager=[MLMapManager shareInstance];
    }
    return _mapManager;
}


-(AJLocationManager*)locationManager
{
   if(_locationManager==nil)
   {
       _locationManager=[AJLocationManager shareLocation];
   }
    return _locationManager;
}


- (instancetype)init
{
    self=[super init];
    if (self==nil) return nil;
//    //监听兼职变化,有变化更新ViewModel
    [self initRACFunction];
    return self;
}


/**
 *  初始化类内监听设置
 */
- (void)initRACFunction
{
    //    //监听兼职变化,有变化更新ViewModel
    @weakify(self)
    [RACObserve(self, jianZhi) subscribeNext:^(id x) {
        @strongify(self)
        if (x!=nil &&[x isKindOfClass:[JianZhi class]]) {
            [self mappingJianZhiModel:x];
        }
    }];
}

/**
 *  初始化实例
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithData:(JianZhi *) data
{
    self=[super init];
    if (self==nil) return nil;
    self.jianZhi=data;
    [self initRACFunction];
    return self;
}

- (NSString*)setQiYeName:(NSString*)name
{
    return [NSString stringWithFormat:@"发布企业:%@",name];
}


- (NSString *)setEvaluationTextWithResumeNum:(NSNumber *)jianliNum
                                 ReceiveNum:(NSNumber *)rRate
                            SatisfactionRate:(NSNumber *)sRate
{
    return [NSString stringWithFormat:@"收到简历%@份，满意度%@%%，共服务%@个同学",[jianliNum stringValue],[sRate stringValue],[rRate stringValue]];

}


- (NSString *)setCommentTextWithNum:(NSNumber *)commentsNum
{
    return [NSString stringWithFormat:@"共有来自宇宙的%@个同学吐槽",[commentsNum stringValue]];
}

/**
 *  将JianZhi Model转换为ViewModel 显示的内容
 *
 *  @param data data isClass JianZhi
 */
-(void)mappingJianZhiModel:(JianZhi *)data
{
//
    self.jobTitle=data.jianZhiTitle;
    self.jobWages=[data.jianZhiWage stringValue];
    self.jobWagesType=[NSString stringWithFormat:@"/%@",data.jianZhiWageType];
    self.jobXiangQing=[data.jianZhiContent stringByAppendingString:[NSString  stringWithFormat:@"\n \n %@",data.jianZhiRequirement]];
    self.jobTeShuYaoQiu=data.jianzhiTeShuYaoQiu;
    self.jobQiYeName=[self setQiYeName:data.jianZhiQiYeName];
    self.jobAddress=data.jianZhiAddress;
   
    
    self.jobEvaluation=[self setEvaluationTextWithResumeNum:data.jianZhiQiYeResumeValue ReceiveNum:data.jianZhiQiYeLuYongValue SatisfactionRate:data.jianZhiQiYeManYiDu];
    self.worktime=[self formatWorkTimeToArray:data.jianZhiWorkTime];
    self.jobPhone=data.jianZhiContactPhone;
    self.jobContactName=data.jianZhiContactName;
    self.jobRequiredNum=[NSString stringWithFormat:@"%d",([data.jianZhiRecruitment intValue]-[data.jianZhiQiYeLuYongValue intValue])];
#warning 需要请求评论数据
    self.jobCommentsText=[self setCommentTextWithNum:@(10)];
    
    CLLocationCoordinate2D destination=CLLocationCoordinate2DMake(data.jianZhiPoint.latitude, data.jianZhiPoint.longitude);
    [self getAddressRoute:destination];
    
    self.typeImage=[self getJobTypeImage];
}


-(UIImage*)getJobTypeImage
{
    NSArray *imageArray=@[@"protait1",@"protait2",@"protait3",@"protait4",@"protait5"];
    
    int j=(int)(4.0*rand()/(RAND_MAX+1.0));
    NSString *name=[imageArray objectAtIndex:j];

    return [UIImage imageNamed:name];
}


-(NSString*)getAddressRoute:(CLLocationCoordinate2D) point
{
    //异步调用getAddressRoute
    //业务逻辑：1、判断用户距离 如果太近距离低于1km，调用onfoot接口
    //2、如果大于1km 调用坐公交的借口
    NSNumber *distance=[self.mapManager calDistanceMeterWithPointA:point PointB:self.locationManager.lastCoordinate];
    if ([distance intValue]<1000) {
        [self.mapManager findRouteOnFootFrom:point To:self.locationManager.lastCoordinate];
    }else if([distance intValue]<500000)
    {
        [self.mapManager findRouteByBusFrom:point To:self.locationManager.lastCoordinate];
    }else
    {
      return @"囧~您与工作的距离太远，建议慎重选择~";
    }
    
    RAC(self,jobAddressNavi)=RACObserve(self.mapManager,routePlannedString);
    return nil;
}

/**
 *  控制页面跳转
 *
 *  @param viewController <#viewController description#>
 *
 */
- (void)presentShowJobInMapInterfaceFromViewController:(UIViewController*) viewController{
    
    MapViewController *mapViewController=[[MapViewController alloc]init];
    mapViewController.hidesBottomBarWhenPushed=YES;
    [mapViewController setDataArray:@[self.jianZhi]];
    [viewController.navigationController pushViewController:mapViewController animated:YES];
    self.presentedViewController=viewController;
}

/**
 *  解析workTime
 *
 *  @param workTime workTime description
 *
 *  @return return value description
 */
- (NSArray *)formatWorkTimeToArray:(NSString *)workTime
{
//    bool array[21];
    NSArray *workTimeArray = [workTime componentsSeparatedByString:@","];
//    for (int i = 0; i < [workTimeArray count]; i++) {
//        NSLog(@"string:%@", [workTimeArray objectAtIndex:i]);
//        int num=[[workTimeArray objectAtIndex:i]integerValue];
//        if (num>0 && num <21) worktime[num]=true;
//    }
    return workTimeArray;
}



/**
 *  添加收藏
 */
- (void)addFavirateAction
{
    AVUser *currentUser=[AVUser currentUser];
    if (currentUser!=nil) {
    
        //FIXME: 子类化后修改
        AVObject *shoucang = [AVObject objectWithClassName:@"JianZhiShouCang"];
        [shoucang setObject:self.jianZhi.objectId forKey:@"jianZhi"];
        [shoucang setObject:self.jianZhi.qiYeInfoId forKey:@"qiYeInfo"];
        [shoucang setObject:currentUser.objectId forKey:@"userDetail"];
        [shoucang saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded==YES) {
                TTAlert(@"收藏成功");
                //FIXME: 做一些跟新ui的操作 设置信号
                
                
            }else
            {
                TTAlert(@"收藏失败");
            }
        }];
        
        
    
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"你还未登录，请先登录再收藏" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}


- (void)applyThisJob
{
    
    
    AVUser *currentUser=[AVUser currentUser];
    if (currentUser!=nil) {
        
    //FIXME: 子类化后修改
        AVObject *shoucang = [AVObject objectWithClassName:@"JianZhiShenQing"];
        [shoucang setObject:self.jianZhi.objectId forKey:@"jianZhi"];
        [shoucang setObject:self.jianZhi.qiYeInfoId forKey:@"qiYeInfo"];
        [shoucang setObject:currentUser.objectId forKey:@"userDetail"];
        [shoucang saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded==YES) {
                TTAlert(@"收藏成功");
                //做一些跟新ui的操作 设置信号
                
            }else
            {
                NSLog(@"%@",error.description);
                TTAlert(@"收藏失败");
            }
        }];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"你还未登录，请先登录再申请" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}



#warning 完善显示信息

#warning 提交浏览次数

#warning 添加其他


@end