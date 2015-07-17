//
//  JobDetailVC.m
//  EJianZhi
//
//  Created by RAY on 15/1/30.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//
#define CollectionViewMiniLineSpace 3.0f
#define CollectionViewMiniInterItemsSpace 3.0f
#define CollectionViewItemsWidth ((MainScreenWidth-(7*CollectionViewMiniInterItemsSpace))/7)
#import "JobDetailVC.h"
#import "freeselectViewCell.h"

#import "FVCustomAlertView.h"
#import "MapViewController.h"
//#import "ASDepthModalViewController.h"
#import "MLJobDetailViewModel.h"
#import "SRMapViewVC.h"

#import "CompanyInfoViewController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "ChatViewController.h"
#import "UIColor+ColorFromArray.h"
#define GreenFillColor [UIColor colorWithRed: 0.22 green: 0.69 blue: 0.58 alpha: 1]
#import "PullServerManager.h"
#import "JianZhi.h"
#import <CoreLocation/CoreLocation.h>
#import"MLMapManager.h"
#import "AJLocationManager.h"
#import "DateUtil.h"
static NSString *selectFreecellIdentifier = @"freeselectViewCell";


@interface JobDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray  *addedPicArray;
    NSArray  *selectfreetimepicArray;
    NSArray  *selectfreetimetitleArray;
    CGFloat freecellwidth;
    bool selectFreeData[21];
    
    //界面的适配
    UIScrollView *_underScrollView;
    UIView *_upView;
    UIView *_middleView;
    UILabel *_leftLabel;
    UILabel *_innerLabel;
    UILabel *_jobTitleLabel;
    UILabel *_moneyLabel;
    UILabel *_moneyTypeLabel;
    UILabel *_areaLabel;
    UILabel *_settleTypeLabel;
    UILabel *_pushTimeLabel;
    UILabel *_jobTypeLabel;
    UILabel *_needNumberLabel;
    UILabel *_secondMoneyLabel;
    UILabel *_secondMoneyTypeLabel;
    UILabel *_workTimeLabel;
    UILabel *_companyLabel;
    UILabel *_workPlaceLabel;
    UILabel *_jobResponsebility;
    UILabel *_jobNeedLabel;
    UIButton *_connectComanyButton;
    UIButton *_applyJianZhiButton;
    NSString *companyId;
    
    
}
@property (strong,nonatomic) MLJobDetailViewModel *viewModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobContentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *selectfreeCollectionOutlet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jobTeShuYaoQiuHeightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *btn1;
@property (strong, nonatomic) IBOutlet UIButton *btn2;
@property (strong, nonatomic) IBOutlet UIButton *btn3;

@property (strong, nonatomic)JianZhi* jianzhi;

- (IBAction)showInMapAction:(id)sender;
//测试
@property (weak, nonatomic) IBOutlet UIScrollView *showUIVIEWCESHIDE;

//popUpView
@property (strong, nonatomic) IBOutlet UIView *popUpView;
- (IBAction)callAction:(id)sender;
- (IBAction)messageAction:(id)sender;



@property (weak, nonatomic) IBOutlet UILabel *popUpViewPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *popUpViewNameLabel;

//绑定内容展示表现层
@property (strong, nonatomic) IBOutlet UIButton *chatBtn;
@property (strong, nonatomic) IBOutlet UILabel *chatLabel;
@end

@implementation JobDetailVC

/**
 *  init方法
 *
 *  @param data 给viewModel 传递的model信息
 *
 *  @return instancetype
 */


- (instancetype)initWithData:(id)data
{
    self=[super init];
    if (self==nil) return nil;
    [self setViewModelJianZhi:data];
    return self;
}

/**
 *  设置兼职数据
 *
 *  @param data <#data description#>
 */

- (void)setViewModelJianZhi:(id)data
{
    if ([data isKindOfClass:[JianZhi class]]) {
        JianZhi *jianzhi=data;
        //加入浏览量统计
        self.viewModel=[[MLJobDetailViewModel alloc]initWithData:data];
    }
}

- (void)viewDidLoad {
    
    
    NSLog(@"%@",companyId);
    [super viewDidLoad];
    //[self timeCollectionViewInit];
    [self creatUI];
    self.title=@"兼职详情";
    self.tabBarController.tabBar.hidden=YES;
    
    if (self.viewModel==nil) {
        self.viewModel=[[MLJobDetailViewModel alloc]init];
    }
    
    if (self.isPreview) {
        UIBarButtonItem *rightBarItem=[[UIBarButtonItem alloc]initWithTitle:@"确认发布" style:UIBarButtonItemStylePlain target:self action:@selector(publish)];
        self.navigationItem.rightBarButtonItem=rightBarItem;
        
        UIBarButtonItem *leftBarItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(pushBack)];
        self.navigationItem.rightBarButtonItem=rightBarItem;
        self.navigationItem.leftBarButtonItem=leftBarItem;
        
    }else{
                    UIBarButtonItem *rightBarItem=[[UIBarButtonItem alloc]initWithTitle:@"再次发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishAgain)];
                    self.navigationItem.rightBarButtonItem=rightBarItem;
    }

    
    //创建监听
    @weakify(self)
    [RACObserve(self.viewModel,worktime) subscribeNext:^(id x) {
        @strongify(self)
        NSArray *workTimeArray=self.viewModel.worktime;
        //默认空数据true,所以先刷新数据为false
        for (int j = 0; j<21; j++) {
            selectFreeData[j]=false;
        }
        for (int i = 0; i < [workTimeArray count]; i++) {
            NSLog(@"string:%@", [workTimeArray objectAtIndex:i]);
            int num=[[workTimeArray objectAtIndex:i] intValue];
            if (num>0 && num <21) selectFreeData[num]=true;
            
        }
        [self.selectfreeCollectionOutlet reloadData];
    }];
   
}


- (void)creatUI{
    
    
    _underScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:_underScrollView];
    [self creatUPView];
    [self creatMiddle];
    
}


- (void)creatUPView{
  
    _upView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 82)];
    
    _leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 15, 50, 50)];
    [ self setIconBackgroundColor:[self colorForType: self.viewModel.jianZhi.jianZhiType]];
    _leftLabel.text=self.viewModel.jianZhi.jianZhiType;
    _leftLabel.font=[UIFont systemFontOfSize:12];
    _leftLabel.layer.masksToBounds=YES;
    _leftLabel.layer.cornerRadius=8;
    _leftLabel.textColor=[UIColor whiteColor];
    _leftLabel.textAlignment=NSTextAlignmentCenter;
    [_upView addSubview:_leftLabel];
    

    
    _jobTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(80, 15, SCREENHEIGHT-30, 13)];
    _jobTitleLabel.font=[UIFont systemFontOfSize:12];
    // _jobTitleLabel.text=@"销售工程师";
       if(_jobTitleLabel.text){
           _jobTitleLabel.text=self.viewModel.jianZhi.jianZhiTitle;
    }else{
    _jobTitleLabel.text=@"";
    }
    [_upView addSubview:_jobTitleLabel];
    
    _moneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 32, 40, 15)];
    _moneyLabel.font=[UIFont systemFontOfSize:12];
    //_moneyLabel.textAlignment=NSTextAlignmentRight;
    _moneyLabel.textColor=RGBACOLOR(235, 46, 41, 1);
    // _moneyLabel.text=@"150元";
    NSString *moneyString=@"元";
    if(_moneyLabel.text){
        RAC(_moneyLabel,text)=RACObserve(self.viewModel, jobWages);
        _moneyLabel.text=[_moneyLabel.text stringByAppendingString:moneyString];

    }else{
    
    _moneyLabel.text=@"";
    }
    
    [_upView addSubview:_moneyLabel];
    
    _moneyTypeLabel =[[UILabel alloc]initWithFrame:CGRectMake(118, 32, 20, 15)];
    _moneyTypeLabel.font=[UIFont systemFontOfSize:12];
    _moneyTypeLabel.textColor=RGBACOLOR(235, 46, 41, 1);

    if(_moneyTypeLabel.text){
    _moneyTypeLabel.text=self.viewModel.jianZhi.jianZhiWageType;
    }else{
    
    _moneyTypeLabel.text=@"";
    }
    
  
    
    [_upView addSubview:_moneyTypeLabel];
    
    _settleTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(173, 32, SCREENHEIGHT-173-30, 15)];
    NSString *styleString =@"结算方式:" ;
    if(_settleTypeLabel.text){
        _settleTypeLabel.text= [styleString stringByAppendingString:self.viewModel.jianZhi.jianZhiWageType];
    }else{
        _settleTypeLabel.text= @"";

    }
        _settleTypeLabel.font=[UIFont systemFontOfSize:12];
    [_upView addSubview:_settleTypeLabel];
    
    _pushTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(173, 54, SCREENHEIGHT-173-54, 15)];
    if(_pushTimeLabel.text){
     _pushTimeLabel.text=[@"发布日期:" stringByAppendingString:[DateUtil stringFromDate:self.viewModel.jianZhi.createdAt]];
    }else{
        _pushTimeLabel.text=@"";
    }
    
   

    
    _pushTimeLabel.font=[UIFont systemFontOfSize:12];
    [_upView addSubview:_pushTimeLabel];
    

    
    
    
    
    UIImageView *mapIamgeView=[[UIImageView alloc]initWithFrame:CGRectMake(80, 54, 13, 15)];
    mapIamgeView.image=[UIImage imageNamed:@"地标"];
    [_upView addSubview:mapIamgeView];
    _areaLabel =[[UILabel alloc]initWithFrame:CGRectMake(100, 54, 34, 15)];
    // _areaLabel.text=@"朝阳" ;
    _areaLabel.text=self.viewModel.jianZhi.jianZhiAddress;
    //RAC(_areaLabel,text)=RACObserve(self.viewModel, jobArea);
    _areaLabel.font=[UIFont systemFontOfSize:12];
    [_upView addSubview:_areaLabel];
    UILabel *distanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(125, 54, 60, 15)];
    distanceLabel.text=[self distanceFromJobPoint:self.viewModel.jianZhi.jianZhiPoint.latitude Lon:self.viewModel.jianZhi.jianZhiPoint.longitude];
    distanceLabel.font=[UIFont systemFontOfSize:12];

    [_upView addSubview:distanceLabel];
    UIView *firstView=[[UIView alloc]initWithFrame:CGRectMake(0, 82, SCREENHEIGHT, 5)];
    firstView.backgroundColor=RGBACOLOR(244, 244, 244, 1);
    [_underScrollView addSubview:firstView];
    [_underScrollView addSubview:_upView];
    
}

-(UIColor*)colorForType:(NSString*)type
{
    NSUserDefaults *mysetting=[NSUserDefaults standardUserDefaults];
    NSDictionary *typeAndColorDict=[mysetting objectForKey:TypeListAndColor];
    NSArray *typeArray=[typeAndColorDict allKeys];
    if ([typeArray containsObject:type]) {
        UIColor *color=[UIColor colorRGBFromArray:[typeAndColorDict objectForKey:type]];
        return  color;
    }
    else
    {
        return nil;
    }
}

- (void)setIconBackgroundColor:(UIColor*)color
{
    if(color==nil) _leftLabel.backgroundColor=GreenFillColor;
    else _leftLabel.backgroundColor=color;
}


-(NSString *)distanceFromJobPoint:(double)lat Lon:(double)lon
{
    if (lat>0 && lon>0) {
        
        CLLocationCoordinate2D jobP=CLLocationCoordinate2DMake(lat, lon);
        CLLocationCoordinate2D location=[AJLocationManager shareLocation].lastCoordinate;
        NSNumber *disNumber=[MLMapManager calDistanceMeterWithPointA:jobP PointB:location];
        int threshold=[disNumber intValue];
        if (threshold >100000) {
            return [NSString stringWithFormat:@">100km"];
        }else if(threshold>1000)
        {
            return [NSString stringWithFormat:@"%.2fkm",[disNumber doubleValue]/1000];
        }else if(threshold<100&&threshold>0)
        {
            return [NSString stringWithFormat:@"%dm",threshold];
        }
        
    }
    return @"";
    
}



- (void)creatMiddle{
    
    _middleView=[[UIView alloc]initWithFrame:CGRectMake(0, 87, SCREENWIDTH, 105)];
    [_underScrollView addSubview:_middleView];
    
    _jobTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 21)];
    _jobTypeLabel.text=self.viewModel.jianZhi.jianZhiType;
    //RAC(_jobTypeLabel,text)=RACObserve(self.viewModel, jianZhi.jianZhiType);
    _jobTypeLabel.textColor=RGBACOLOR(63, 164, 123, 1);
    NSString *typeString=@"职位类型: ";
 //   _jobTypeLabel.text=[typeString stringByAppendingString:self.viewModel.jianZhi.jianZhiType];
    _jobTypeLabel.font=[UIFont systemFontOfSize:12];
    [_middleView addSubview:_jobTypeLabel];
    
    _needNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 31, 100, 21)];
    NSString *numString=@"招聘人数: ";
    RAC(_needNumberLabel,text)=RACObserve(self.viewModel, jobRequiredNum);
    _needNumberLabel.text=[numString stringByAppendingString:_needNumberLabel.text];
    
    _needNumberLabel.font=[UIFont systemFontOfSize:12];
    [_middleView addSubview:_needNumberLabel];
    
    _secondMoneyLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 52, 200, 21)];
    _secondMoneyLabel.textColor=RGBACOLOR(235, 46, 41, 1);
    NSString *secondMoneyString=@"薪资待遇:";
    //_secondMoneyLabel.text= [secondMoneyString stringByAppendingString:[_moneyLabel.text stringByAppendingString:_moneyTypeLabel.text]] ;
    
    _secondMoneyLabel.font=[UIFont systemFontOfSize:12];
    [_middleView addSubview:_secondMoneyLabel];
    
    _workTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 76, 300, 21)];
    NSString *startTime= [DateUtil stringFromDate:self.viewModel.jianZhi.jianZhiTimeStart];
    NSString *endTime= [DateUtil stringFromDate:self.viewModel.jianZhi.jianZhiTimeEnd];
    _workTimeLabel.text=@"工作日期:  " ;
    if(startTime&&endTime){
        _workTimeLabel.text=[[_workTimeLabel.text stringByAppendingString:startTime] stringByAppendingString:@"   "];
        _workTimeLabel.text=[_workTimeLabel.text stringByAppendingString:@"至   "];
        _workTimeLabel.text=[_workTimeLabel.text stringByAppendingString:endTime];

    }else{
    _workTimeLabel.text=@"";
    }
    
    
    _workTimeLabel.font=[UIFont systemFontOfSize:12];
    [_middleView addSubview:_workTimeLabel];
    
    UIView *secondView=[[UIView alloc]initWithFrame:CGRectMake(10, 75, SCREENWIDTH-20, 1)];
    secondView.backgroundColor=RGBACOLOR(183, 183, 183, 1);
    [_middleView addSubview:secondView];
    
    UIView *thirdView=[[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 5)];
    thirdView.backgroundColor=RGBACOLOR(244, 244, 244, 1);
    [_middleView addSubview:thirdView];
    
    UILabel *comanyLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 187, SCREENWIDTH, 30)];
    comanyLabel.font=[UIFont systemFontOfSize:15];
    comanyLabel.text=@"招聘单位";
    comanyLabel.userInteractionEnabled=-YES;
    RAC(comanyLabel,text)=RACObserve(self.viewModel, jobQiYeName);
    [_underScrollView addSubview:comanyLabel];
    
    UIButton *comanyButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    [comanyLabel addSubview:comanyButton];
     [comanyButton addTarget:self action:@selector(companyButton) forControlEvents:UIControlEventTouchUpInside];
    
    comanyButton.rac_command=[[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        companyId=self.viewModel.jianZhi.jianZhiQiYe.objectId;

        
        NSLog(@"%@",companyId);
        if (companyId!=nil) {
            CompanyInfoViewController *companyInfoVC=[[CompanyInfoViewController alloc]initWithData:companyId];
            companyInfoVC.hidesBottomBarWhenPushed=YES;
            companyInfoVC.edgesForExtendedLayout=UIRectEdgeNone;
            [self.navigationController pushViewController:companyInfoVC animated:YES];
        }
        else
        {
            TTAlert(@"sorry,该公司的HR什么都没留下~！详情请电话咨询");
            
        }
        return [RACSignal empty];
    }];

    
    
    UIView *forthView=[[UIView alloc]initWithFrame:CGRectMake(0, 217, SCREENWIDTH, 5)];
    forthView.backgroundColor=RGBACOLOR(244, 244, 244, 1);
    [_underScrollView addSubview:forthView];
    
    
    UILabel *placeLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 222, SCREENWIDTH, 30)];
    placeLabel.font=[UIFont systemFontOfSize:15];
    placeLabel.text=@"工作地址";
    placeLabel.userInteractionEnabled=YES;
    [_underScrollView addSubview:placeLabel];
    
    UIButton *placeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    placeButton.frame=CGRectMake(0, 0,SCREENWIDTH, 30);
    [placeLabel addSubview:placeButton];
    [placeButton addTarget:self action:@selector(showInMapAction:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *placeView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH/4*3, 8, 15, 15)];
    placeView.image=[UIImage imageNamed:@"地图"];
    //箭头
    UIImageView *rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(placeView.frame.origin.x+30, 10, 10, 10)];
    rightImageView.image=[UIImage imageNamed:@"灰箭头"];
    [placeLabel addSubview:rightImageView];
    
    UIImageView *rightImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(placeView.frame.origin.x+30, 10, 10, 10)];
    rightImageView2.image=[UIImage imageNamed:@"灰箭头"];
    [comanyLabel addSubview:rightImageView2];
    

    [placeButton addSubview:placeView];
    
    
    
    
    
    
    UIView *underPlaceLabelLine=[[UIView alloc]initWithFrame:CGRectMake(10, 252, SCREENWIDTH-20, 1)];
    underPlaceLabelLine.backgroundColor=RGBACOLOR(183, 183, 183, 1);
    
    [_underScrollView addSubview:underPlaceLabelLine];
    
    _workPlaceLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 263, SCREENWIDTH-40, 20)];
    RAC(_workPlaceLabel,text)=RACObserve(self.viewModel, jobAddress);
    _workPlaceLabel.numberOfLines=0;
     CGSize workPlace = [_workPlaceLabel.text sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(SCREENWIDTH-40, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    _workPlaceLabel.frame=CGRectMake(25, 263, SCREENWIDTH-40, workPlace.height);
    [_underScrollView addSubview:_workPlaceLabel];
    
    UIView *underWorkPlaceLabelView=[[UIView alloc]initWithFrame:CGRectMake(0, _workPlaceLabel.frame.origin.y+workPlace.height+10, SCREENWIDTH, 10)];
    underWorkPlaceLabelView.backgroundColor=RGBACOLOR(244, 244, 244, 1);
    [_underScrollView addSubview:underWorkPlaceLabelView];
    
    UILabel *jobResponsibility=[[UILabel alloc]initWithFrame:CGRectMake(20, underWorkPlaceLabelView.frame.origin.y+15, 60, 20)];
    jobResponsibility.text=@"岗位职责";
    
    jobResponsibility.font=[UIFont systemFontOfSize:15];
    [_underScrollView addSubview:jobResponsibility];
    
    UIView *underResponsibilityLine=[[UIView alloc]initWithFrame:CGRectMake(10, jobResponsibility.frame.origin.y+jobResponsibility.frame.size.height+5, SCREENWIDTH-20, 1)];
    underResponsibilityLine.backgroundColor=RGBACOLOR(183, 183, 183, 1);
    
    [_underScrollView addSubview:underResponsibilityLine];
    
    _jobResponsebility=[[UILabel alloc]initWithFrame:CGRectMake(20, 368, SCREENWIDTH-50, 20)];
    _jobResponsebility.font=[UIFont systemFontOfSize:15];
    _jobResponsebility.text=self.viewModel.jianZhi.jianZhiContent;
    
//    RAC(_jobResponsebility,text)=RACObserve(self.viewModel, jobContent);
    CGSize jobResponsebilitySize = [_jobResponsebility.text sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(SCREENWIDTH-50, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    _jobResponsebility.numberOfLines=0;
    
    _jobResponsebility.frame=CGRectMake(20, underResponsibilityLine.frame.origin.y+10, SCREENWIDTH-20, jobResponsebilitySize.height);
    [_underScrollView addSubview:_jobResponsebility];
    
    //岗位职责内容下的细线
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, _jobResponsebility.frame.origin.y+jobResponsebilitySize.height+15, SCREENWIDTH, 1)];
    line.backgroundColor=RGBACOLOR(183, 183, 183, 1);
    
    [_underScrollView addSubview:line];

    //任职资格
    UILabel *needLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, line.frame.origin.y+10, 60, 20)];
    needLabel.text=@"任职资格";
    needLabel.font=[UIFont systemFontOfSize:15];
    [_underScrollView addSubview:needLabel];
    
    //任职资格下的细线
    UIView *underNeedLabelLine=[[UIView alloc]initWithFrame:CGRectMake(10, needLabel.frame.origin.y+25, SCREENWIDTH-20, 1)];
    underNeedLabelLine.backgroundColor=RGBACOLOR(183, 183, 183, 1);
   [_underScrollView addSubview:underNeedLabelLine];
    
    
    
    //任职资格内容
    _jobNeedLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, underNeedLabelLine.frame.origin.y+10, SCREENHEIGHT-40, 20)];
    _jobNeedLabel.numberOfLines=0;
    _jobNeedLabel.font=[UIFont systemFontOfSize:15];
    _jobNeedLabel.text=self.viewModel.jianZhi.jianZhiRequirement;

    CGSize jobNeed = [_jobNeedLabel.text sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(SCREENWIDTH-40, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    _jobNeedLabel.frame=CGRectMake(20, underNeedLabelLine.frame.origin.y+10,SCREENHEIGHT-40,jobNeed.height);
    
    [_underScrollView addSubview:_jobNeedLabel];
    
    UIView *upConnectView=[[UIView alloc]initWithFrame:CGRectMake(0, _jobNeedLabel.frame.origin.y+_jobNeedLabel.frame.size.height, SCREENWIDTH, 10)];
    upConnectView.backgroundColor=RGBACOLOR(244, 244, 244, 1);
    [_underScrollView addSubview:upConnectView];
    
    //联系方式
    UILabel *connetLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, upConnectView.frame.origin.y+10, SCREENWIDTH, 20)];
    connetLabel.text=@"联系方式";
    [_underScrollView addSubview:connetLabel];
    
    UIView *underConnectView=[[UIView alloc]initWithFrame:CGRectMake(10, connetLabel.frame.origin.y+25, SCREENWIDTH-20, 1)];
    underConnectView.backgroundColor=RGBACOLOR(183, 183, 183, 1);
    [_underScrollView addSubview:underConnectView];
    UILabel *phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, underConnectView.frame.origin.y+5, 200, 20)];
    phoneLabel.text=[@"电话: " stringByAppendingString:self.viewModel.jianZhi.jianZhiContactPhone ];
    [_underScrollView addSubview:phoneLabel];
    
    
    UIImageView *bottomView=[[UIImageView alloc]initWithFrame:CGRectMake(0, phoneLabel.frame.origin.y+32,SCREENWIDTH, 50)];
    bottomView.image=[UIImage imageNamed:@"页脚"];
    [_underScrollView addSubview:bottomView];
    _underScrollView.contentSize=CGSizeMake(SCREENWIDTH, bottomView.frame.origin.y+155);
    // _underScrollView.frame=CGRectMake(0, 0, SCREENWIDTH, bottomView.frame.origin.y+120);
    
}

-(void)companyButton{
    if (companyId!=nil) {
        CompanyInfoViewController *companyInfoVC=[[CompanyInfoViewController alloc]initWithData:companyId];
        companyInfoVC.hidesBottomBarWhenPushed=YES;
        companyInfoVC.edgesForExtendedLayout=UIRectEdgeNone;
        [self.navigationController pushViewController:companyInfoVC animated:YES];
    }
    else
    {
        TTAlert(@"sorry,该公司的HR什么都没留下~！详情请电话咨询");
        
    }
   
}

 - (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}


#pragma mark - Collection View Data Source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 28;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(freecellwidth, freecellwidth);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=0 && indexPath.row<7) {
        return NO;
    }
    return YES;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectFreeData[indexPath.row-7] = selectFreeData[indexPath.row-7]?false:true;
    [collectionView reloadData];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    freeselectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:selectFreecellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[freeselectViewCell alloc]init];
    }
    //[[cell imageView]setFrame:CGRectMake(0, 0, freecellwidth, freecellwidth)];
    if (indexPath.row>=0 && indexPath.row<7) {
        cell.imageView.image = [selectfreetimetitleArray objectAtIndex:indexPath.row];
    }
    if (indexPath.row>=7 && indexPath.row<14) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:1];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:0];
        }
        
    }
    if (indexPath.row>=14 && indexPath.row<21) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:3];
        }else{
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:2];
        }
    }
    if (indexPath.row>=21 && indexPath.row<28) {
        if (selectFreeData[indexPath.row-7]) {
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:5];
        }else{
            
            cell.imageView.image = [selectfreetimepicArray objectAtIndex:4];
        }
    }
    return cell;
};


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return CollectionViewMiniLineSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return CollectionViewMiniInterItemsSpace;
    
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

-(void)makeContactAction
{
    //添加联系
    //FIXME:换控件
    self.popUpView.layer.cornerRadius=2;
    self.popUpView.autoresizingMask=UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
    //    self.popUpView.frame=CGRectMake(0, 0, (300/320)*MainScreenWidth, (280/468)*MainScreenHeight);
    self.popUpView.frame=CGRectMake(0, 0, 300,280);
    [FVCustomAlertView showAlertOnView:self.view withTitle:nil titleColor:[UIColor whiteColor] width:self.popUpView.frame.size.width height:self.popUpView.frame.size.height backgroundImage:nil backgroundColor:[UIColor whiteColor] cornerRadius:4 shadowAlpha:0.5 alpha:1.0 contentView:self.popUpView type:FVAlertTypeCustom];
}

- (IBAction)callAction:(id)sender {
    //打电话
    
    NSString *telUrl = [NSString stringWithFormat:@"tel://%@",self.viewModel.jobPhone];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]]; //拨号
}

- (IBAction)messageAction:(id)sender {
    //发短信
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"sms://%@",self.viewModel.jobPhone];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    [self.view addSubview:callWebview];
}


- (IBAction)showInMapAction:(id)sender {
    
    if (self.viewModel.jianZhi.jianZhiPoint) {
        SRMapViewVC *mapVC=[[SRMapViewVC alloc]init];
        mapVC.sellerCoord=CLLocationCoordinate2DMake(self.viewModel.jianZhi.jianZhiPoint.latitude, self.viewModel.jianZhi.jianZhiPoint.longitude);
        mapVC.sellerTitle=_jobTitleLabel.text;
        
        [self.navigationController pushViewController:mapVC animated:YES];
    }else {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"对不起，该用户暂未提供位置信息" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil,nil];
        [alert show];
    }
    //    [self.viewModel presentShowJobInMapInterfaceFromViewController:self];
}


- (IBAction)showResume:(id)sender {
    
}

- (IBAction)chatWithEnterprise:(id)sender {
    
    AVObject *qiyeInfo = self.viewModel.jianZhi.jianZhiQiYe;
    AVUser *user = [qiyeInfo objectForKey:@"qiYeUser"];
    ChatViewController *chatVC;
    if (user.objectId)
    {
        chatVC = [[ChatViewController alloc] initWithChatter:user.objectId conversationType:eConversationTypeChat];
    }
    else
    {
        chatVC = [[ChatViewController alloc] initWithChatter:@"5541f97be4b0fe513834d3fb" conversationType:eConversationTypeChat];
    }
    chatVC.title = user.username;
   //  chatVC.jianzhi = self.viewModel.jianZhi;
    [self.navigationController pushViewController:chatVC animated:YES];
    
    //    ChatViewController *chatVC = [[ChatViewController alloc] init];
    //
    //    [self.navigationController pushViewController:chatVC animated:YES];
    //    if (self.viewModel.companyInfo!=nil) {
    //
    //        if([self.viewModel.companyInfo objectForKey:@"qiYeUser"]){
    //            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //            AVObject *userQuery=[self.viewModel.companyInfo objectForKey:@"qiYeUser"];
    //            [userQuery fetchInBackgroundWithBlock:^(AVObject *object, NSError *error) {
    //                if (!error) {
    //                    AVUser *_user=object;
    //                    [CDCache registerUser:_user];
    //
    //                    CDIM* im=[CDIM sharedInstance];
    //                    WEAKSELF
    //                    [im fetchConvWithUserId:_user.objectId callback:^(AVIMConversation *conversation, NSError *error) {
    //                        [MBProgressHUD hideHUDForView:self.view animated:YES];
    //                        if(error){
    //                            DLog(@"%@",error);
    //                        }else{
    //                            CDChatRoomVC* chatRoomVC=[[CDChatRoomVC alloc] initWithConv:conversation];
    //                            chatRoomVC.hidesBottomBarWhenPushed=YES;
    //                            [weakSelf.navigationController pushViewController:chatRoomVC animated:YES];
    //                        }
    //                    }];
    //                }
    //
    //            }];
    //        }
    //    }
}

- (void)publish{
    
    
    AVObject *jianzhiObject=[AVObject objectWithClassName:@"JianZhi"];
    [jianzhiObject setObject:@(test) forKey:@"isTest"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiQiYeLuYongValue forKey:@"jianZhiQiYeLuYongValue"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiContent forKey:@"jianZhiContent"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiAddress forKey:@"jianZhiAddress"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiRecruitment forKey:@"jianZhiRecruitment"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiTimeEnd forKey:@"jianZhiTimeEnd"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiWorkTime forKey:@"jianZhiWorkTime"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiKaoPuDu forKey:@"jianZhiKaoPuDu"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiDistrict forKey:@"jianZhiDistrict"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiBrowseTime forKey:@"jianZhiBrowseTime"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiCity forKey:@"jianZhiCity"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiTimeStart forKey:@"jianZhiTimeStart"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiContactPhone forKey:@"jianZhiContactPhone"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiRequirement forKey:@"jianZhiRequirement"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiProvince forKey:@"jianZhiProvince"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiQiYeManYiDu forKey:@"jianZhiQiYeManYiDu"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiWageType forKey:@"jianZhiWageType"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiContactName forKey:@"jianZhiContactName"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiWage forKey:@"jianZhiWage"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianzhiTeShuYaoQiu forKey:@"jianzhiTeShuYaoQiu"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiQiYeName forKey:@"jianZhiQiYeName"];
    
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiQiYeResumeValue forKey:@"jianZhiQiYeResumeValue"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiType forKey:@"jianZhiType"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiPoint forKey:@"jianZhiPoint"];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiLuYongValue forKey:@"jianZhiLuYongValue"];
    
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiTitle forKey:@"jianZhiTitle"];
    
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiContactEmail forKey:@"jianZhiContactEmail"];
    
    [jianzhiObject setObject:self.viewModel.jianZhi.qiYeInfoId forKey:@"qiYeInfoId"];
    
    //AVUser *user=[AVUser currentUser];
    [jianzhiObject setObject:self.viewModel.jianZhi.jianZhiQiYe forKey:@"jianZhiQiYe"];
    int qiyeIsValidate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"qiyeIsValidate"] intValue];
    if(qiyeIsValidate==1)
    {
        [jianzhiObject setObject:@"已认证" forKey:@"isAuthorzied"];
    }
    else if(qiyeIsValidate==0)
    {
        [jianzhiObject setObject:@"未认证" forKey:@"isAuthorzied"];
    }
    else if (qiyeIsValidate == 2)
    {
        [jianzhiObject setObject:@"未处理" forKey:@"isAuthorzied"];
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [jianzhiObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (succeeded) {
            [MBProgressHUD showSuccess:@"保存成功" toView:self.view];
            [self performSelector:@selector(returnAndSave) withObject:nil afterDelay:1.0f];
            [[NSNotificationCenter defaultCenter] postNotificationName:PubListJianzhiNotif object:nil];
        }else{
            [MBProgressHUD showSuccess:@"保存失败" toView:self.view];
        }
    }];
}

- (void)pushBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)returnAndSave{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.saveDelegate finishSave];
}

- (void)publishAgain{
    
}


@end
