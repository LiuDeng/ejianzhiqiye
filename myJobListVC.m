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
    NSMutableArray *recordArray;
    BOOL firstLoad;
    
    AVUser *curUsr;
    
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

    [self loadCompanyInfo];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)refreshTable
{
    [self headerRereshing];
}

- (void)loadCompanyInfo
{
    AVUser *usr=[AVUser currentUser];
    
    AVQuery *query=[AVQuery queryWithClassName:@"QiYeInfo"];
    [query whereKey:@"userObjectId" equalTo:usr.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count]>0) {
                AVObject *qiyeInfo = [objects objectAtIndex:0];
                
                if ([[qiyeInfo objectForKey:@"isAuthorized"] isEqualToString:@"已认证"])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"qiyeIsValidate"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self tableViewInit];
                    [self headerRereshing];
                }
                else if ([[qiyeInfo objectForKey:@"isAuthorized"] isEqualToString:@"未认证"])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"qiyeIsValidate"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self tableViewInit];
                    [self headerRereshing];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的企业还未认证" delegate:self cancelButtonTitle:@"稍后认证" otherButtonTitles:@"立即认证", nil];
                    alertView.tag = 100;
                    [alertView show];
                } else if ([[qiyeInfo objectForKey:@"isAuthorized"] isEqualToString:@"未处理"])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"qiyeIsValidate"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self tableViewInit];
                    [self headerRereshing];
                }
                else
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"qiyeIsValidate"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有创建企业信息" delegate:self cancelButtonTitle:@"稍后创建" otherButtonTitles:@"立即创建", nil];
                alertView.tag = 100;
                [alertView show];
            }
        }else{
            NSString *errorString=[NSString stringWithFormat:@"sorry，加载出错。错误原因：%@"  ,error.description];
            [MBProgressHUD showError:errorString toView:nil];
        }
        
    }];
    
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
    if (!recordArray) {
        recordArray=[[NSMutableArray alloc]init];
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
                [recordArray removeAllObjects];
            }
            
            for (AVObject *obj in objects) {
                
                [recordArray addObject:obj];
                
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
                
                [recordArray addObject:obj];
                
            }
            
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
            
            NSInteger n=[recordArray count];
            NSInteger m=[objects count];
            
            for (NSInteger k=n-m; k<[recordArray count];k++) {
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recordArray count];
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
    
    JianZhi *object=[recordArray objectAtIndex:row];
    
    cell.jobTitleLabel.text= [object objectForKey:@"jianZhiTitle"];
    cell.resumeNumLabel.text= [NSString stringWithFormat:@"共收到%@份简历",[object objectForKey:@"jianZhiQiYeResumeValue"]];
    cell.jobSalaryLabel.text=[NSString stringWithFormat:@"%@元/月",[object objectForKey:@"jianZhiWage"]];
    
    NSInteger n=[[object objectForKey:@"jianZhiRecruitment"] integerValue]-[[object objectForKey:@"jianZhiQiYeLuYongValue"] integerValue];
    if (n<0)
        n=0;

    cell.recruitInfoLabel.text= [NSString stringWithFormat:@"已录用%@人，还缺%ld人，浏览%@次",[object objectForKey:@"jianZhiQiYeLuYongValue"],(long)n,[object objectForKey:@"jianZhiBrowseTime"]];
    
    cell.typeLabel.text=[object objectForKey:@"jianZhiType"];
    
    [cell.BkgView setBackgroundColor:[UIColor colorForType:[object objectForKey:@"jianZhiType"]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JobDetailVC *detailVC=[[JobDetailVC alloc]initWithData:[recordArray objectAtIndex:indexPath.row]];
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
    JianZhi *object=[recordArray objectAtIndex:index];
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
