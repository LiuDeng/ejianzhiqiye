//
//  myJobListVC.m
//  ejianzhi
//
//  Created by RAY on 15/4/28.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "myJobListVC.h"
#import "myJobListCell.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "JianZhi.h"
#import "QiYeInfo.h"
#import "resumeListVC.h"
#import "JianZhi.h"
#import "JobDetailVC.h"
#import "UIColor+ColorFromArray.h"
#import "AppDelegate.h"
#import "CompanyInfoViewController.h"
#import "CompanyInfoViewModel.h"

#import "PublishJobVC.h"

@interface myJobListVC ()<UITableViewDataSource,UITableViewDelegate,resumeDelegate, UIAlertViewDelegate>
{
    BOOL headerRefreshing;
    BOOL footerRefreshing;
    int skipTimes;
    NSMutableArray *_recordArray;
    BOOL firstLoad;
    AVUser *curUsr;
    UIBarButtonItem *_leftButtonItem;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) QiYeInfo *qiyeInfo;
@end

@implementation myJobListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:PubListJianzhiNotif object:nil];
    self.title=@"我发布的兼职";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布职位" style:UIBarButtonItemStylePlain target:self action:@selector(addNewJob)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"qiyeIsValidate"] intValue] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的企业还未认证" delegate:self cancelButtonTitle:@"稍后认证" otherButtonTitles:@"立即认证", nil];
        alertView.tag = 100;
        [alertView show];
    }
    
    [self tableViewInit];
    [self headerRereshing];
//    [self loadCompanyInfo];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)refreshTable
{
    [self headerRereshing];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 0)
        {
        }
        else if (buttonIndex == 1)
        {
            AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            appDelegate.qiyeTabViewController.selectedIndex = 2;
            if ([AVUser currentUser].objectId!=nil) {
                CompanyInfoViewController *companyInfoVC=[[CompanyInfoViewController alloc]initWithData:[AVUser currentUser].objectId];
                companyInfoVC.fromEnterprise=YES;
                
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
                backItem.title = @"";
                self.navigationItem.backBarButtonItem = backItem;
                
                companyInfoVC.hidesBottomBarWhenPushed=YES;
                companyInfoVC.edgesForExtendedLayout=UIRectEdgeNone;
                [self.navigationController pushViewController:companyInfoVC animated:YES];
                
            }else{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"您尚未登录哦" message:nil delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"现在登录", nil];
                [alert show];
            }
        }
    }
    
}

- (void)addNewJob{
    
//    int qiyeIsValidate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"qiyeIsValidate"] intValue];
//    if (qiyeIsValidate == 1)
//    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AVQuery *userQuery=[AVUser query];
        AVUser *usr=[AVUser currentUser];
        [userQuery whereKey:@"objectId" equalTo:usr.objectId];
        
        AVQuery *innerQuery=[AVQuery queryWithClassName:@"QiYeInfo"];
        
        [innerQuery whereKey:@"qiYeUser" matchesQuery:userQuery];
        
        [innerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (!error&&[objects count]>0) {
                
                PublishJobVC *addJobVC=[[PublishJobVC alloc]init];
                
                addJobVC.curUsr=[objects objectAtIndex:0];
                
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
                backItem.title = @"";
                self.navigationItem.backBarButtonItem = backItem;
                
                addJobVC.hidesBottomBarWhenPushed=YES;
                
                [self.navigationController pushViewController:addJobVC animated:YES];
            }
        }];
//    }
//    else
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的企业还未认证" delegate:self cancelButtonTitle:@"稍后认证" otherButtonTitles:@"立即认证", nil];
//        alertView.tag = 100;
//        [alertView show];
//    }
}

- (void)tableViewInit{
    if (!_recordArray) {
        _recordArray=[[NSMutableArray alloc]init];
    }
    
    skipTimes=0;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    [self refreshData];
}

-(void)refreshData{
    
    AVQuery *userQuery=[AVUser query];
    AVUser *usr=[AVUser currentUser];
    [userQuery whereKey:@"objectId" equalTo:usr.objectId];
    
    AVQuery *innerQuery=[AVQuery queryWithClassName:@"QiYeInfo"];

    [innerQuery whereKey:@"qiYeUser" matchesQuery:userQuery];

    
    AVQuery *query=[AVQuery queryWithClassName:@"JianZhi"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = 10;
    query.skip=0;
    skipTimes=1;
    [query whereKey:@"jianZhiQiYe" matchesQuery:innerQuery];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            
            if (headerRefreshing) {
                [_recordArray removeAllObjects];
            }
            
            for (AVObject *obj in objects) {
                
                [_recordArray addObject:obj];
                
            }
            
            [self.tableView reloadData];
            
            if (headerRefreshing) {
                [self.tableView headerEndRefreshing];
                headerRefreshing=NO;
            }
            
        } else {
            
            if (footerRefreshing) {
                [self.tableView footerEndRefreshing];
                footerRefreshing=NO;
            }
            
            [MBProgressHUD showError:@"服务器开小差了，请刷新试试" toView:self.view];
            
        }
    }];
    query=nil;
    userQuery=nil;
    innerQuery=nil;
}

- (void)footRefreshData{
    
    AVQuery *userQuery=[AVUser query];
    AVUser *usr=[AVUser currentUser];
    [userQuery whereKey:@"objectId" equalTo:usr.objectId];
    
    AVQuery *innerQuery=[AVQuery queryWithClassName:@"QiYeInfo"];
    
    [innerQuery whereKey:@"qiYeUser" matchesQuery:userQuery];
    
    AVQuery *query=[AVQuery queryWithClassName:@"JianZhi"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = 10;
    query.skip=skipTimes*10;
    skipTimes++;

    [query whereKey:@"jianZhiQiYe" matchesQuery:innerQuery];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            
            for (AVObject *obj in objects) {
                
                [_recordArray addObject:obj];
                
            }
            
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
            
            NSInteger n=[_recordArray count];
            NSInteger m=[objects count];
            
            for (NSInteger k=n-m; k<[_recordArray count];k++) {
                NSIndexPath *newPath = [NSIndexPath indexPathForRow:k inSection:0];
                [insertIndexPaths addObject:newPath];
            }
            
            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView footerEndRefreshing];
            
            footerRefreshing=NO;
            
        } else {
            
            if (footerRefreshing) {
                [self.tableView footerEndRefreshing];
                footerRefreshing=NO;
            }
            
            [MBProgressHUD showError:@"服务器开小差了，请刷新试试" toView:self.view];
            
        }
    }];
    query=nil;
}

- (void)footerRereshing{
    footerRefreshing=YES;
    [self footRefreshData];
}

- (void)headerRereshing{
    headerRefreshing=YES;
    skipTimes=0;
    [self refreshData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row]; //获取当前行
    JianZhi *object=[_recordArray objectAtIndex:row];
    [object deleteInBackground];
    [ _recordArray removeObjectAtIndex:row]; //在数据中删除当前对象
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade]; //数组执行删除 操作
    
    //[object saveInBackground];
       }

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return YES;

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_recordArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL nibsRegistered = NO;
    static NSString *Cellidentifier=@"myJobListCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"myJobListCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    
    NSInteger row=[indexPath row];
    
    myJobListCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];
    cell.resumeDelegate=self;
    cell.index=row;
    JianZhi *object=[_recordArray objectAtIndex:row];
    
    cell.jobTitleLabel.text= [object objectForKey:@"jianZhiTitle"];
    cell.resumeNumLabel.text= [NSString stringWithFormat:@"共收到%@份简历",[object objectForKey:@"jianZhiQiYeResumeValue"]];
    cell.jobSalaryLabel.text=[NSString stringWithFormat:@"%@元/%@",[object objectForKey:@"jianZhiWage"],[object objectForKey:@"jianZhiWageType"]];
    
    NSInteger n=[[object objectForKey:@"jianZhiRecruitment"] integerValue]-[[object objectForKey:@"jianZhiQiYeLuYongValue"] integerValue];
    if (n<0)
        n=0;

    cell.recruitInfoLabel.text= [NSString stringWithFormat:@"已录用%@人，还缺%ld人，浏览%@次",[object objectForKey:@"jianZhiQiYeLuYongValue"],(long)n,[object objectForKey:@"jianZhiBrowseTime"]];
    
    cell.typeLabel.text=[object objectForKey:@"jianZhiType"];
    
    [cell.BkgView setBackgroundColor:[UIColor colorForType:[object objectForKey:@"jianZhiType"]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JobDetailVC *detailVC=[[JobDetailVC alloc]initWithData:[_recordArray objectAtIndex:indexPath.row]];
    detailVC.hidesBottomBarWhenPushed=YES;
    detailVC.fromEnterprise=YES;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

- (void)showRelativeResume:(NSInteger)index{
    JianZhi *object=[_recordArray objectAtIndex:index];
    resumeListVC *resumeVC=[[resumeListVC alloc]init];
    resumeVC.jobObject=object;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

    resumeVC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:resumeVC animated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PubListJianzhiNotif object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
