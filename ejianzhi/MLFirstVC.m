//
//  MLFirstVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/19.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#import "MLFirstVC.h"
#import "SRAdvertisingView.h"
//#import "MLCell1.h"
#import "JobListTableViewCell.h"
#import "SRScanVC.h"
//#import "ResumeVC.h"
#import "JobDetailVC.h"
#import "MLJobListViewController.h"

#import "MJRefresh.h"
//
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"

//所依赖的ViewModel
#import "MLJianZhiViewModel.h"
#import "MLJobDetailViewModel.h"
#import "JianZhi.h"
#import "JobListTableViewController.h"
#import "MLMainPageViewModel.h"
#import <UIAlertView+Blocks.h>
#import "JobListWithDropDownListVCViewController.h"
#import "AJLocationManager.h"


#import <AVOSCloud/AVOSCloud.h>


#define IOS7 [[[UIDevice currentDevice] systemVersion]floatValue]>=7


#import "SearchViewController.h"

@interface MLFirstVC ()<ValueClickDelegate,UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    NSArray *collectionViewCellArray;
    SRAdvertisingView *_bannerView;
    UIScrollView *_buttonScrollView;
    UIView *_lineGrayView;
    UILabel *_recommendLabel;
    UIView *_bottomLineView;
    UIView *_headView;
}


@property (weak, nonatomic) IBOutlet UIScrollView *middleScrollView;

//@property (strong,nonatomic) MLJianZhiViewModel *jianzhiViewModel;

@property (strong,nonatomic) JobListTableViewController *joblistTableVC;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView;
@property (strong, nonatomic) IBOutlet UIView *tableHeadView2;
@property (weak, nonatomic) IBOutlet SRAdvertisingView *blankView;
@property (strong,nonatomic)MLMainPageViewModel *viewModel;


//不同类型的兼职Btn
//@property (weak, nonatomic) IBOutlet UIButton *morejobBtn;
//@property (weak, nonatomic) IBOutlet UIButton *homeTeacherBtn;
//@property (weak, nonatomic) IBOutlet UIButton *modelBtn;
//@property (weak, nonatomic) IBOutlet UIButton *itWorkBtn;

- (IBAction)itWorkBtnAction:(id)sender;
- (IBAction)modelBtnAction:(id)sender;
- (IBAction)homeTeacherBtnAction:(id)sender;
- (IBAction)moreBtnAction:(id)sender;

//cellView
@property (strong, nonatomic) IBOutlet UIView *modelView;
@property (strong, nonatomic) IBOutlet UIView *ItView;
@property (strong, nonatomic) IBOutlet UIView *homeTeachweView;
@property (strong, nonatomic) IBOutlet UIView *moreView;

//action
- (IBAction)findJobWithLocationAction:(id)sender;
- (IBAction)findJobWithCardAction:(id)sender;
- (IBAction)jobAsTeacherAction:(id)sender;
- (IBAction)jobAsAccountingAction:(id)sender;
- (IBAction)jobAsModelAction:(id)sender;
- (IBAction)jobAsOutseaStuAction:(id)sender;

@end

@implementation MLFirstVC
@synthesize tableHeadView=_tableHeadView;


-(instancetype)init
{
    if(self=[super init])
    {
        self.joblistTableVC=[[JobListTableViewController alloc]initWithAutoLoad:YES];
        self.joblistTableVC.isAutoLoad=NO;
    }
    return self;
}

- (void)creatHeadView{
    CGFloat bannerWidth=130*[[UIScreen mainScreen] bounds].size.width/320;
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,bannerWidth+102+12+37)];
       _bannerView=[[SRAdvertisingView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130*[[UIScreen mainScreen] bounds].size.width/320)];
    [_headView addSubview:_bannerView];
    
    
    [self creatScrollView];
    [self creatLineGrayView];
    [self creatRecommendLabel];
    [self creatBottomLineView];
    
}

-(void)creatScrollView{
    
    CGFloat scrollViewWidth=102;
    _buttonScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 130*[[UIScreen mainScreen] bounds].size.width/320, SCREENWIDTH,scrollViewWidth)];
    [_headView addSubview:_buttonScrollView];
        NSArray *imageArray=@[@"internIcon.png",@"hmTeacherIcon.png",@"distribterIcon.png",@"moreFirstPage.png"];
    NSArray *titleArray=@[@"实习",@"家教",@"派单",@"更多"];
    for(NSInteger i=0;i<4;i++){
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width=60;
        CGFloat height=102;
        CGFloat space=(SCREENWIDTH-width*4)/5;
        button.frame=CGRectMake(space*(i+1)+width*i,(height-width)/4, width, width);
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        button.tag=100+i;
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *label=[[UILabel alloc]init];
        label.frame=CGRectMake(space*(i+1)+width*i,width+(height-width)/4+5, width, 21);
        label.text=titleArray[i];
        label.textAlignment=NSTextAlignmentCenter;
        label.textColor=[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
        [_buttonScrollView addSubview:button];
         [_buttonScrollView addSubview:label];
    }
}

-(void)btnClick:(UIButton*)button{

    switch (button.tag){
        case 100:{
            [self itWorkBtnAction:button];
        }
            break;
        case 101:{
            [self homeTeacherBtnAction:button];
        }
            break;
        case 102:{
            [self modelBtnAction:button];
            
        }
            break;
        case 103:{
            [self moreBtnAction:button];
        }
            break;
            
    }
}
-(void)creatLineGrayView{
    _lineGrayView=[[UIView alloc]initWithFrame:CGRectMake(0, _bannerView.frame.size.height+_buttonScrollView.frame.size.height, SCREENWIDTH, 12)];
    _lineGrayView.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [_headView addSubview:_lineGrayView];

}

- (void)creatRecommendLabel{
    _recommendLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, _lineGrayView.frame.origin.y+12, 74, 22)];
    _recommendLabel.text=@"推荐兼职";
    _recommendLabel.font=[UIFont fontWithName:nil size:16];
    _recommendLabel.textColor=[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1];
    [_headView addSubview:_recommendLabel];
    
}

- (void)creatBottomLineView{
    _bottomLineView=[[UIView alloc]initWithFrame:CGRectMake(0, _recommendLabel.frame.origin.y+24, SCREENWIDTH, 1)];
    _bottomLineView.backgroundColor=[UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:0.5];
    [_headView addSubview:_bottomLineView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatHeadView];
    [self creatTitleLabel];
    [self creatLocationButton];
    [self creatRightButtonItem];
    
    
    self.viewModel=[[MLMainPageViewModel alloc]init];
    [self addChildViewController:self.joblistTableVC];
    //collectiveViewCell
    collectionViewCellArray=[NSArray arrayWithObjects:self.modelView,self.ItView,self.homeTeachweView,self.moreView,nil];
    [self addViewToScrollView];
    [self addHeaderAndFooterToTableView];
    [self.view addSubview: self.joblistTableVC.tableView];
    [self performSelector:@selector(advertisementInit) withObject:nil afterDelay:1.0f];
    //监听城市信息
    RAC(self.navigationItem.leftBarButtonItem,title)=RACObserve(self.viewModel, cityName);
    [self.viewModel startLocatingToGetCity];
    [self searchCity];
    self.joblistTableVC.isFisrtView=YES;
    
    
}

-(void)creatRightButtonItem{
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"搜索icon副本.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarTapped)];
    self.navigationItem.rightBarButtonItem=rightItem;

}
- (void)creatLocationButton{
    UIImage *image=[UIImage imageNamed:@"Locationicon"];
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.imageEdgeInsets=UIEdgeInsetsMake(0, -24, 0, 0);
    locationBtn.titleEdgeInsets=UIEdgeInsetsMake(0 ,-18, 0, 0);
    [locationBtn setImage:image forState:UIControlStateNormal];
    locationBtn.tintColor=[UIColor whiteColor];
    [locationBtn setTitle:@"北京" forState:UIControlStateNormal];
    locationBtn.titleLabel.font=[UIFont fontWithName:nil size:15];
    locationBtn.frame =CGRectMake(0, 0, 60, 40);
    [locationBtn addTarget: self action: @selector(Location) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem* locationBtnItem=[[UIBarButtonItem alloc]initWithCustomView:locationBtn];
    self.navigationItem.leftBarButtonItem=locationBtnItem;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
}

- (void)creatTitleLabel{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    label.font=[UIFont fontWithName:nil size:18];
    label.textColor=[UIColor whiteColor];
    label.text=@"e兼职";
    self.navigationItem.titleView=label;
}

-(void)searchBarTapped
{
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)addViewToScrollView
{
    CGFloat edgewidth=2.0;
    CGFloat width = 90.0f;
    CGFloat marginwidth=(MainScreenWidth-(4*edgewidth)-4*width)/3;
    int count=(int)[collectionViewCellArray count];
    for (int i=0; i<[collectionViewCellArray count]; i++) {
        UIView *view=[collectionViewCellArray objectAtIndex:i];
        if(i==0){
            view.frame=CGRectMake(edgewidth,0,width,view.frame.size.height);
        }else
        {
            view.frame=CGRectMake((edgewidth+(width+marginwidth)*(i)),0,width, view.frame.size.height);
        }
        [self.middleScrollView addSubview:view];
    }
    self.middleScrollView.contentSize=CGSizeMake((width+marginwidth)*count,102);
    //    self.middleScrollView.pagingEnabled=YES;
}


-(void)addHeaderAndFooterToTableView
{
    //添加表头
   
    [_tableHeadView2 setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 172+152*[[UIScreen mainScreen] bounds].size.width/320)];
        self.joblistTableVC.tableView.tableHeaderView=_headView;
    //[self.joblistTableVC.tableView setTableHeaderView:_tableHeadView2];
    //添加表尾
    [self.joblistTableVC addFooterRefresher];
    [self.joblistTableVC addHeaderRefresher];
}



/**
 *  位置定位
 *  逻辑是进入首页先自动定位 如果失败再让用户手选，和美团一样
 */
- (void)Location{
    //显示位置信息，用户位置信息
    RIButtonItem *cancelButtonItem = [RIButtonItem itemWithLabel:@"知道了" action:^{
        NSLog(@"Press Button Cancel");
    }];
    RIButtonItem *otherButtonItem = [RIButtonItem itemWithLabel:@"确定" action:^{
        NSLog(@"Press Button OK");
        //初始化城市列表
    }];
    
    
    NSString *message=[NSString stringWithFormat:@"目前仅支持北京地区，其他地区敬请期待",self.viewModel.cityName];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message: message cancelButtonItem:cancelButtonItem otherButtonItems:nil];
    [alert show];
}


#pragma --mark 分享功能
- (void)shareJob{
    RIButtonItem *cancelButtonItem = [RIButtonItem itemWithLabel:@"知道了" action:^{
        NSLog(@"Press Button OK");
        //初始化城市列表
    }];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"抱歉，社交分享正在女里开发中...精彩敬请期待" cancelButtonItem:cancelButtonItem otherButtonItems: nil];
    [alert show];
    
}

//*********************Banner********************//
#pragma --mark BannerView Method
-(void)advertisementInit{
    
    NSMutableArray *urlArray=[[NSMutableArray alloc]init];
    NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
    NSArray *bannerData=[mysettings objectForKey:@"BannerData"];
    if(bannerData==nil) return;
    for (NSDictionary *dict in bannerData) {
        NSString *imageUrl=[dict objectForKey:@"BannerImageUrl"];
        [urlArray addObject:imageUrl];
    }
    SRAdvertisingView *bannerView=[[SRAdvertisingView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 130*[[UIScreen mainScreen] bounds].size.width/320) imageArray:urlArray interval:3.0];
    
    bannerView.vDelegate=self;
    //[self.blankView addSubview:bannerView];
    [_bannerView addSubview:bannerView];
}


/**
 *  banner 点击事件
 *
 *  @param vid <#vid description#>
 */
- (void)buttonClick:(int)vid{
    
    NSMutableArray *urlArray=[[NSMutableArray alloc]init];
    NSUserDefaults *mysettings=[NSUserDefaults standardUserDefaults];
    NSArray *bannerData=[mysettings objectForKey:@"BannerData"];
    NSDictionary *dict=[bannerData objectAtIndex:vid];
    NSLog(@"BannerTouch:%@",[dict objectForKey:@"BannerType"]);
    UIViewController *webVC=[[UIViewController alloc]init];

    UIWebView *webView=[[UIWebView alloc] init];
    webVC.view=webView;
    webView.delegate=self;
    NSString *Url = [NSString stringWithFormat:@"%@",[dict objectForKey:@"BannerParam"]];
    
    NSURL *URL =[NSURL URLWithString:Url];// 貌似tel:// 或者 tel: 都行
    webVC.hidesBottomBarWhenPushed=YES;
    webVC.edgesForExtendedLayout=UIRectEdgeNone;
    //记得添加到view上
    [self.navigationController pushViewController:webVC animated:YES];
//    [webVC.view addSubview:webview];
    [webView loadRequest:[NSURLRequest requestWithURL:URL]];
}



//-(void)setupCamera
//{
//    if(IOS7)
//    {
//        SRScanVC * scanVC = [[SRScanVC alloc]init];
//        scanVC.scanDelegate=self;
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//        backItem.title = @"";
//        backItem.tintColor=[UIColor whiteColor];
//        self.navigationItem.backBarButtonItem = backItem;
//        scanVC.hidesBottomBarWhenPushed=YES;
//
//        [self.navigationController pushViewController:scanVC animated:YES];
//
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma --mark  选择附近的兼职 按钮事件
- (IBAction)findJobWithLocationAction:(id)sender {
    JobListWithDropDownListVCViewController *nearByList=[[JobListWithDropDownListVCViewController alloc]init];
    nearByList.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nearByList animated:YES];
    
}

- (IBAction)findJobWithCardAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsTeacherAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsAccountingAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsModelAction:(id)sender {
    [self showListView];
}

- (IBAction)jobAsOutseaStuAction:(id)sender {
    [self showListView];
}



#pragma --mark  ListViewInit Method

-(void)showListView
{
    JobListWithDropDownListVCViewController *nearByList=[[JobListWithDropDownListVCViewController alloc]init];
    nearByList.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:nearByList animated:YES];
}



- (void)searchCity
{
    NSUserDefaults *mySettingData = [NSUserDefaults standardUserDefaults];
    
    //获得用户位置信息
    [[AJLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        [mySettingData setObject:NSStringFromCGPoint(CGPointMake(locationCorrrdinate.longitude, locationCorrrdinate.latitude)) forKey:@"currentCoordinate"];
        [mySettingData synchronize];
        
    } error:^(NSError *error) {
    }];
}

- (IBAction)itWorkBtnAction:(id)sender {
    JobListWithDropDownListVCViewController *joblistWithDrowList=[[JobListWithDropDownListVCViewController alloc]init];
    
    [joblistWithDrowList setCurrentType:@"实习"];
    [self.navigationController pushViewController:joblistWithDrowList animated:YES];
}

- (IBAction)modelBtnAction:(id)sender {
    JobListWithDropDownListVCViewController *joblistWithDrowList=[[JobListWithDropDownListVCViewController alloc]init];
    
    [joblistWithDrowList setCurrentType:@"派单"];
    [self.navigationController pushViewController:joblistWithDrowList animated:YES];
}

- (IBAction)homeTeacherBtnAction:(id)sender {
    JobListWithDropDownListVCViewController *joblistWithDrowList=[[JobListWithDropDownListVCViewController alloc]init];
    
    [joblistWithDrowList setCurrentType:@"家教"];
    [self.navigationController pushViewController:joblistWithDrowList animated:YES];
}

- (IBAction)moreBtnAction:(id)sender {
    JobListWithDropDownListVCViewController *joblistWithDrowList=[[JobListWithDropDownListVCViewController alloc]init];
    [self.navigationController pushViewController:joblistWithDrowList animated:YES];
}

#pragma --mark UIWebViewDelegate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showHUDAddedTo:webView animated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:webView animated:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:webView animated:YES];
    [MBProgressHUD showError:@"加载出错" toView:webView];
}



@end
