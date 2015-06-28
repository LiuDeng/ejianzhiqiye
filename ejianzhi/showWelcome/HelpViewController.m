//
//  HelpViewController.m
//  ejianzhi
//
//  Created by 小哥 on 15/6/27.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
{
    UIScrollView *scrollView;
}
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"didGuide"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    for (int i = 1; i<5; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(SCREENWIDTH*(i-1), 0, SCREENWIDTH, SCREENHEIGHT);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页%d.png",i]];
        [scrollView addSubview:imageView];
        if (i == 4)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = imageView.frame;
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(hideHelpVC) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:button];
        }
        
        
    }
    [self.view addSubview:scrollView];
    
    [scrollView setContentSize:CGSizeMake(SCREENWIDTH*4, SCREENHEIGHT)];
    
}

- (void)hideHelpVC
{
    if ([self.delegate respondsToSelector:@selector(hideHelpViewController)]) {
        [self.delegate hideHelpViewController];
    }
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
