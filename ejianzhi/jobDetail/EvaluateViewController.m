//
//  EvaluateViewController.m
//  ejianzhi
//
//  Created by 小哥 on 15/7/16.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "EvaluateViewController.h"
#import "UIImageView+EMWebCache.h"
#import "RatingBar.h"
#import "stringUtil.h"

@interface EvaluateViewController () <RatingBarDelegate>
{
    UIImageView *headView;
    UIScrollView *scrollView;
    NSInteger first;
    NSInteger second;
    NSInteger third;
    NSInteger forth;
}
@property (nonatomic, strong) NSArray *array;
@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _array = [NSArray arrayWithObjects:@"诚信度", @"工作态度", @"工作完成度", @"是否愿意再次录用", nil];
    
    [self initView];
}

- (void)creatImageView{
    
    //    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    //    button.backgroundColor=[UIColor lightGrayColor];
    //    [button addTarget:self action:@selector(goToSee) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:button];
    headView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, SCREENWIDTH-40, 80)];
    //headView.backgroundColor=[UIColor lightGrayColor];
    headView.image=[UIImage imageNamed:@"背景框"];
    
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    _leftImageView.layer.masksToBounds=YES;
    _leftImageView.layer.cornerRadius=30;
    _leftImageView.backgroundColor=[UIColor yellowColor];
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    //姓名
    _userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 10,60, 25)];
    // _userNameLabel.backgroundColor=[UIColor grayColor];
    _userNameLabel.font=[UIFont fontWithName:nil size:15];
    _userNameLabel.textColor=RGBACOLOR(20, 20, 20, 1);
    _userNameLabel.text =self.userName;
    
    //年龄
    _userAgeLabel=[[UILabel alloc]initWithFrame:CGRectMake(140, 10, 40, 25)];
    //    _userAgeLabel.backgroundColor=[UIColor greenColor];
    _userAgeLabel.font=[UIFont fontWithName:nil size:12];
    _userAgeLabel.textColor=RGBACOLOR(81, 81, 81, 1);
    _userAgeLabel.text=self.userAge;
    
    //学校
    _userSchoolLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 35, 200, 15)];
//    _userSchoolLabel.text= [@"就读于"stringByAppendingString: self.userSchool];
    _userSchoolLabel.font=[UIFont fontWithName:nil size:12];
    _userSchoolLabel.textColor=RGBACOLOR(81, 81, 81, 1);
    
    UILabel *jobLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 55, 200, 15)];
    jobLabel.textColor=RGBACOLOR(81, 81, 81, 1);
    jobLabel.font=[UIFont fontWithName:nil size:12];
//    jobLabel.text=[@"期望工作:"stringByAppendingString: self.expectJob];
    
    [headView addSubview:jobLabel];
    [headView addSubview:_leftImageView];
    [headView addSubview:_userNameLabel];
    [headView addSubview:_userSchoolLabel];
    [headView addSubview:_userAgeLabel];
    [scrollView addSubview:headView];
    
}

- (void)initView
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    
    // 顶部卡片
    [self creatImageView];
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.text = @"总体评价信息";
    totalLabel.font = [UIFont systemFontOfSize:18.0f];
    totalLabel.numberOfLines = 1;
    CGSize descLabelSize = [totalLabel.text sizeWithFont:[UIFont systemFontOfSize:18.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 44) lineBreakMode:NSLineBreakByWordWrapping];
    totalLabel.frame = CGRectMake(22, headView.frame.origin.y+headView.frame.size.height+10, descLabelSize.width, 44);
    [scrollView addSubview:totalLabel];
    
    RatingBar *ratingbar = [[RatingBar alloc] initWithFrame:CGRectMake(totalLabel.frame.origin.x+totalLabel.frame.size.width, totalLabel.frame.origin.y+12, 140, 15)];
    ratingbar.tag = 105;
    ratingbar.enable = NO;
    [scrollView addSubview:ratingbar];
    
    for (int i = 0; i<_array.count; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = [_array objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:15.0f];
        label.numberOfLines = 1;
        CGSize labelSize = [label.text sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(MAXFLOAT, 30) lineBreakMode:NSLineBreakByWordWrapping];
        label.frame = CGRectMake(40, (totalLabel.frame.origin.y+totalLabel.frame.size.height)+(i*(labelSize.height+20)), labelSize.width, 22);
        [scrollView addSubview:label];
        
        RatingBar *ratingbar = [[RatingBar alloc] initWithFrame:CGRectMake(label.frame.origin.x+label.frame.size.width, label.frame.origin.y+3, 140, 15)];
        ratingbar.delegate = self;
        ratingbar.tag = 100+i;
        [scrollView addSubview:ratingbar];
        
    }
    
    // 分割线
    UIImageView *seperatorView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (totalLabel.frame.origin.y+totalLabel.frame.size.height)+((_array.count-1)*(22+20))+20, SCREENWIDTH-20, 1)];
    seperatorView.image = [UIImage imageNamed:@"分栏线"];
    [scrollView addSubview:seperatorView];
    
    // 评价
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, seperatorView.frame.origin.y+20, 100, 22)];
    label.text = @"对她/他的评价";
    label.font = [UIFont systemFontOfSize:15.0f];
    [scrollView addSubview:label];
    
    // 输入框
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, label.frame.origin.y+22, SCREENWIDTH-40, 125)];
    textView.layer.cornerRadius = 10.0f;
    textView.layer.masksToBounds = YES;
    textView.layer.borderWidth = 1.0f;
    textView.layer.borderColor = [COLOR(145, 145, 145) CGColor];
    [scrollView addSubview:textView];
    
    // 提交按钮
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake((SCREENWIDTH-170)/2, textView.frame.origin.y+textView.frame.size.height+20, 170, 38);
    [submitButton setTitle:@"确定提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.backgroundColor = COLOR(68, 170, 128);
    submitButton.layer.cornerRadius = 5.0f;
    submitButton.layer.masksToBounds = YES;
    [submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:submitButton];
    
    // 页脚图片
    UIImageView *footimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, submitButton.frame.origin.y+submitButton.frame.size.height+20, SCREENWIDTH, 50)];
    footimageView.image = [UIImage imageNamed:@"页脚"];
    [scrollView addSubview:footimageView];
    
    float height = seperatorView.frame.origin.y;
    height += 20 + label.frame.size.height+20+textView.frame.size.height+20+submitButton.frame.size.height+50+50+20;
    if (height > SCREENHEIGHT)
    {
        scrollView.contentSize = CGSizeMake(SCREENWIDTH, height);
    }
    
}

-(void)selectedAfter:(RatingBar *)ratingBar
{
    if (ratingBar.tag == 100)
    {
        first = ratingBar.starNumber;
    }
    else if (ratingBar.tag == 101)
    {
        second = ratingBar.starNumber;
    }
    else if (ratingBar.tag == 102)
    {
        third = ratingBar.starNumber;
    }
    else if (ratingBar.tag == 103)
    {
        forth = ratingBar.starNumber;
    }
    
    RatingBar *rat = (RatingBar *)[scrollView viewWithTag:105];
    rat.starNumber = [[stringUtil decimalwithFormat:@"0" floatV:(first + second + third + forth) / (float)_array.count]integerValue];
}

#pragma mark 顶部卡片点击代理
- (void)topViewClick
{
    
}

#pragma mark 确定提交按钮事件
- (void)submitAction:(UIButton *)sender
{
    
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
