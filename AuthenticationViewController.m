//
//  AuthenticationViewController.m
//  ejianzhi
//
//  Created by 小哥 on 15/6/20.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "AuthenticateButton.h"
#import "MLTextUtils.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"

@interface AuthenticationViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL imagePickerPushing;
    NSInteger buttonClick;
    UIImage *firstImage;
    UIImage *secImage;
    UIImage *thirdImage;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@end

@implementation AuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 50, SCREENWIDTH-20,SCREENHEIGHT-50)];
    for (int i = 0; i<3; i++)
    {
        AuthenticateButton *button;
        if (i == 0)
        {
            button = [[AuthenticateButton alloc] initWithFrame:CGRectMake(0, (130+12)*i, SCREENWIDTH-20, 130) withImageName:@"upload.png" andtitle:@"点此上传营业执照" andtitleColor:[UIColor redColor]];
        }
        else if (i == 1)
        {
            button = [[AuthenticateButton alloc] initWithFrame:CGRectMake(0, (130+12)*i, SCREENWIDTH-20, 130) withImageName:@"upload.png" andtitle:@"点此上传组织机构代码证" andtitleColor:[UIColor redColor]];
        }
        else if (i == 2)
        {
            button = [[AuthenticateButton alloc] initWithFrame:CGRectMake(0, (130+12)*i, SCREENWIDTH-20, 130) withImageName:@"upload.png" andtitle:@"点此上传税务登记证" andtitleColor:[UIColor redColor]];
        }
        
        button.layer.cornerRadius = 10.0f;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 10.0f;
        button.tag = 100+i;
        [button addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_scrollView addSubview:button];
    }
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, (130+12)*3, SCREENWIDTH-20, 45);
    [submitButton setTitle:@"保存并提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.backgroundColor = COLOR(57, 156, 109);
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.layer.cornerRadius = 5.0f;
    submitButton.layer.masksToBounds = YES;
    [_scrollView addSubview:submitButton];
    
    float height = (130+12)*3+45;
    if (height > SCREENWIDTH-50-44-20)
    {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, height)];
    }
    
    [self.view addSubview:_scrollView];
    
    
}

- (void)selectImage:(AuthenticateButton *)sender
{
    buttonClick = sender.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:Nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"从相册选择",@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    actionSheet.tag = 0;
    [actionSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==0) {
        if (buttonIndex == 0) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = TRUE;
            [self presentViewController:imagePickerController animated:YES completion:^{
                imagePickerPushing=YES;
            }];
            return;
        }
        if (buttonIndex == 1) {
            UIImagePickerController *imagePickerController =[[UIImagePickerController alloc]init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = TRUE;
                [self presentViewController:imagePickerController animated:YES completion:^{
                    imagePickerPushing=YES;
                }];
            }else{
                UIAlertView *alterTittle = [[UIAlertView alloc] initWithTitle:ALERTVIEW_TITLE message:ALERTVIEW_CAMERAWRONG delegate:nil cancelButtonTitle:ALERTVIEW_KNOWN otherButtonTitles:nil];
                [alterTittle show];
            }
            return;
        }
        
    }
}

//图片获取
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    picker = Nil;
    
    [self dismissModalViewControllerAnimated:YES];
    if (buttonClick == 100)
    {
        AuthenticateButton *button = (AuthenticateButton *)[_scrollView viewWithTag:100];
        [button setImage:image forState:UIControlStateNormal];
        firstImage = image;
        button.ig.image = nil;
        button.titlLabel.text = @"";
    }
    else if (buttonClick == 101)
    {
        AuthenticateButton *button = (AuthenticateButton *)[_scrollView viewWithTag:101];
        [button setImage:image forState:UIControlStateNormal];
        secImage = image;
        button.ig.image = nil;
        button.titlLabel.text = @"";
    }
    else if (buttonClick == 102)
    {
        AuthenticateButton *button = (AuthenticateButton *)[_scrollView viewWithTag:102];
        [button setImage:image forState:UIControlStateNormal];
        thirdImage = image;
        button.ig.image = nil;
        button.titlLabel.text = @"";
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker = Nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitButtonClick:(UIButton *)sender
{
    if (firstImage != nil)
    {
        //上传图片
        NSData *imageData = UIImageJPEGRepresentation(firstImage, 0.5);
        
        AVFile *imageFile = [AVFile fileWithName:@"qiYeBusinessLicense" data:imageData];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                if (imageFile.url != Nil)
                {
                    AVQuery *query = [AVUser query];
                    [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"userObjectId"]];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        
                        AVQuery *query=[AVQuery queryWithClassName:@"QiYeInfo"];
                        if (objects.count > 0)
                        {
                            AVUser *user = [objects objectAtIndex:0];
                            [query whereKey:@"qiYeUser" equalTo:user];
                            
                            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                
                                if (!error)
                                {
                                    if (objects.count > 0)
                                    {
                                        AVObject *qiyeInfo = [objects objectAtIndex:0];
                                        
                                        [qiyeInfo setObject:imageFile forKey:@"qiYeBusinessLicense"];
                                        [qiyeInfo saveEventually];
                                    }
                                }
                                [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                            }];
                        }
                        
                    }];
                    
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                    });
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                });
            }
            
        } progressBlock:^(NSInteger percentDone) {
            
        }];
    }
    if (secImage != nil)
    {
        //上传图片
        NSData *imageData = UIImageJPEGRepresentation(secImage, 0.5);
        
        AVFile *imageFile = [AVFile fileWithName:@"qiYeZuZhiJiGou" data:imageData];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                if (imageFile.url != Nil)
                {
                    AVQuery *query = [AVUser query];
                    [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"userObjectId"]];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        
                        AVQuery *query=[AVQuery queryWithClassName:@"QiYeInfo"];
                        if (objects.count > 0)
                        {
                            AVUser *user = [objects objectAtIndex:0];
                            [query whereKey:@"qiYeUser" equalTo:user];
                            
                            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                
                                if (!error)
                                {
                                    if (objects.count > 0)
                                    {
                                        AVObject *qiyeInfo = [objects objectAtIndex:0];
                                        
                                        [qiyeInfo setObject:imageFile forKey:@"qiYeZuZhiJiGou"];
                                        [qiyeInfo saveEventually];
                                    }
                                }
                                [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                            }];
                        }
                        
                    }];
                    
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                    });
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                });
            }
            
        } progressBlock:^(NSInteger percentDone) {
            
        }];
        
    }
    if (thirdImage != nil)
    {
        //上传图片
        NSData *imageData = UIImageJPEGRepresentation(thirdImage, 0.5);
        
        AVFile *imageFile = [AVFile fileWithName:@"qiYeShuiWuDengJi" data:imageData];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                if (imageFile.url != Nil)
                {
                    AVQuery *query = [AVUser query];
                    [query whereKey:@"objectId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"userObjectId"]];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        
                        AVQuery *query=[AVQuery queryWithClassName:@"QiYeInfo"];
                        if (objects.count > 0)
                        {
                            AVUser *user = [objects objectAtIndex:0];
                            [query whereKey:@"qiYeUser" equalTo:user];
                            
                            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                
                                if (!error)
                                {
                                    if (objects.count > 0)
                                    {
                                        AVObject *qiyeInfo = [objects objectAtIndex:0];
                                        
                                        [qiyeInfo setObject:imageFile forKey:@"qiYeShuiWuDengJi"];
                                        [qiyeInfo saveEventually];
                                    }
                                }
                                [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                        }
                        
                    }];
                    
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                    });
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [MBProgressHUD showError:UPLOADFAIL toView:self.view];
                });
            }
            
        } progressBlock:^(NSInteger percentDone) {
            
        }];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(3) forKey:@"qiyeIsValidate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
