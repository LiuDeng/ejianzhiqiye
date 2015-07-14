//
//  resumeListVC.m
//  ejianzhi
//
//  Created by RAY on 15/4/29.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "resumeListVC.h"
#import "JianZhi.h"
#import "MBProgressHUD+Add.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "resumeListCell.h"
#import "UserDetail.h"
#import "DateUtil.h"
#import "MLResumePreviewVC.h"
#import "UIImageView+EMWebCache.h"
#import"ChatViewController.h"

@interface resumeListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL headerRefreshing;
    BOOL footerRefreshing;
    int skipTimes;
    NSMutableArray *recordArray;
    BOOL firstLoad;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation resumeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"简历列表";
    
    [self tableViewInit];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10, 10, 100, 100);
    button.backgroundColor=[UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)btnClick{
    ChatViewController *chat=[[ChatViewController alloc]init];
//chat.objectId=[]
    [self.navigationController pushViewController:chat animated:YES];
    

}

- (void)tableViewInit{
    if (!recordArray) {
        recordArray=[[NSMutableArray alloc]init];
    }
    
    skipTimes=0;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self refreshData];
}

-(void)refreshData{

    AVQuery *query=[AVQuery queryWithClassName:@"JianZhiShenQing"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = 10;
    query.skip=0;
    skipTimes=1;
    [query whereKey:@"jianZhi" equalTo:self.jobObject];
    [query includeKey:@"userDetail"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            
            if (headerRefreshing) {
                [recordArray removeAllObjects];
            }
            
            for (AVObject *obj in objects) {
                UserDetail *userDetials=[obj objectForKey:@"userDetail"];
                if (userDetials) {
                    [recordArray addObject:obj];
                }
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
}

- (void)footRefreshData{
    
    AVQuery *query=[AVQuery queryWithClassName:@"JianZhiShenQing"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 24*3600;
    query.limit = 10;
    query.skip=skipTimes*10;
    skipTimes++;
    
    [query whereKey:@"jianZhi" equalTo:self.jobObject];
    [query includeKey:@"userDetail"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            int p=0;
            for (AVObject *obj in objects) {
                UserDetail *userDetials=[obj objectForKey:@"userDetail"];
                if (userDetials) {
                    [recordArray addObject:obj];
                    p++;
                }
            }
            
            NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
            
            NSInteger n=[recordArray count];
            
            for (NSInteger k=n-p; k<[recordArray count];k++) {
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
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL nibsRegistered = NO;
    static NSString *Cellidentifier=@"resumeListCell";
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"resumeListCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:Cellidentifier];
    }
    
    NSInteger row=[indexPath row];
    
    resumeListCell *cell = [tableView dequeueReusableCellWithIdentifier:Cellidentifier forIndexPath:indexPath];

    
    UserDetail *object=[[recordArray objectAtIndex:row] objectForKey:@"userDetail"];
    
    if (object) {
        NSString *textString=[[NSString alloc]init];
        
        if ([object objectForKey:@"userRealName"]) {
            textString=[textString stringByAppendingString:[NSString stringWithFormat:@"%@  ",[object objectForKey:@"userRealName"]]];
        }
        if ([object objectForKey:@"userGender"]) {
            textString=[textString stringByAppendingString:[NSString stringWithFormat:@"%@  ",[object objectForKey:@"userGender"]]];
        }
        if ([object objectForKey:@"userBirthYear"]) {
            textString=[textString stringByAppendingString:[NSString stringWithFormat:@"%@  ",[DateUtil ageFromBirthToNow:[object objectForKey:@"userBirthYear"]]]];
        }
        if ([object objectForKey:@"userHeight"]) {
            textString=[textString stringByAppendingString:[NSString stringWithFormat:@"%@cm",[object objectForKey:@"userHeight"]]];
        }
        
        cell.resumeTitleLabel.text=textString;
        
        NSString *textString2=[[NSString alloc]init];
        
        if (object.userSchool) {
            textString2=[NSString stringWithFormat:@"%@  ",[textString2 stringByAppendingString:object.userSchool]];
        }
        if (object.userProfesssion) {
            textString2=[NSString stringWithFormat:@"%@",[textString2 stringByAppendingString:object.userProfesssion]];
        }
        
        cell.resumeSubTitleLabel.text=textString2;
        
        if (object.userLuYongValue) {
            cell.resumeThirdLabel.text=[NSString stringWithFormat:@"%@次兼职经历",object.userLuYongValue];
        }
        
        [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[[object objectForKey:@"userImageArray"]objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"avator"]];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserDetail *object=[[recordArray objectAtIndex:[indexPath row]] objectForKey:@"userDetail"];
    
    
    MLResumePreviewVC *previewVC=[[MLResumePreviewVC alloc]init];
    previewVC.hidesBottomBarWhenPushed=YES;
    previewVC.type=1;
    previewVC.userObjectId=[object objectForKey:@"userObjectId"];
    previewVC.fromEnterprise=YES;
    previewVC.shenqingObjectId=[[recordArray objectAtIndex:[indexPath row]] objectForKey:@"objectId"];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;

    [self.navigationController pushViewController:previewVC animated:YES];
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}



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

@end
