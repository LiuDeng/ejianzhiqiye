//
//  StudentCertifyViewController.m
//  ejianzhi
//
//  Created by chen xuefeng on 15/6/23.
//  Copyright (c) 2015年 Studio Of Spicy Hot. All rights reserved.
//

#import "StudentCertifyViewController.h"
#import "AuthenticateButton.h"
#import "MLTextUtils.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
@interface StudentCertifyViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, retain) UIScrollView *scrollView;
@end

@implementation StudentCertifyViewController{
     NSInteger buttonClick;
     BOOL imagePickerPushing;
     UIImage *firstImage;
     UIImage *secImage;
    BOOL firstImageSuc;
    BOOL secImageSuc;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 50, SCREENWIDTH-20,SCREENHEIGHT-50)];
    for (NSInteger i = 0; i<2; i++)
    {
        AuthenticateButton *button;
        if (i == 0)
        {
            button = [[AuthenticateButton alloc] initWithFrame:CGRectMake(0, (130+12)*i, SCREENWIDTH-20, 130) withImageName:@"upload.png" andtitle:@"点此上传学生证" andtitleColor:[UIColor grayColor]];
        }
        else if (i == 1)
        {
            button = [[AuthenticateButton alloc] initWithFrame:CGRectMake(0, (130+12)*i, SCREENWIDTH-20, 130) withImageName:@"upload.png" andtitle:@"点此上传身份证" andtitleColor:[UIColor grayColor]];
        }
        button.layer.cornerRadius = 10.0f;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 5.0f;
        button.tag = 100+i;
        [button addTarget:self action:@selector(selectImage:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_scrollView addSubview:button];
    }
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, (130+12)*2, SCREENWIDTH-20, 45);
    [submitButton setTitle:@"保存并提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    submitButton.backgroundColor = COLOR(57, 156, 109);
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.layer.cornerRadius = 5.0f;
    submitButton.layer.masksToBounds = YES;
    [_scrollView addSubview:submitButton];
    
    float height = (130+12)*2+45;
    if (height > SCREENWIDTH-50-44-20)
    {
        [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, height)];
    }
    
    [self.view addSubview:_scrollView];

}
#pragma -mark 选择图片
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
        
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    picker = Nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submitButtonClick:(UIButton *)sender
{
    if(firstImage==nil&&secImage==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请上传您的身份证和学生证照片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else if (firstImage!=nil&&secImage==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请上传您的身份证照片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }else if (secImage==nil&&firstImage==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请上传您的学生证照片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (firstImage != nil)
    {
        //上传图片
        NSData *imageData = UIImageJPEGRepresentation(firstImage, 0.5);
        
        AVFile *imageFile = [AVFile fileWithName:@"userStudentFile" data:imageData];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            
            if (succeeded) {
                if (imageFile.url != Nil)
                {
                    AVQuery *query=[AVQuery queryWithClassName:@"UserDetail"];
                    [query whereKey:@"userObjectId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"userObjectId"]];
                    
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        
                        if (!error)
                        {
                            if (objects.count > 0)
                            {
                                AVObject *userDetail = [objects objectAtIndex:0];
                                
                                [userDetail setObject:imageFile forKey:@"userStudentFile"];
                                [userDetail saveEventually];
                            }
                            firstImageSuc = YES;
                            [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                            [self uploadSucWithobjects:objects];
                        }
                       else
                       {
                           [MBProgressHUD showError:UPLOADFAIL toView:self.view];
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
        
        AVFile *imageFile = [AVFile fileWithName:@"userIdentityFile" data:imageData];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                if (imageFile.url != Nil)
                {
                    AVQuery *query=[AVQuery queryWithClassName:@"UserDetail"];
                    
                    [query whereKey:@"userObjectId" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"userObjectId"]];
                    
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        
                        if (!error)
                        {
                            if (objects.count > 0)
                            {
                                AVObject *userDetail = [objects objectAtIndex:0];
                                
                                [userDetail setObject:imageFile forKey:@"userIdentifyFile"];
                                [userDetail saveEventually];
                            }
                            secImageSuc = YES;
                            [MBProgressHUD showError:UPLOADSUCCESS toView:self.view];
                            [self uploadSucWithobjects:objects];
                        }
                        else
                        {
                            [MBProgressHUD showError:UPLOADFAIL toView:self.view];
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
    
    
    
    
}

- (void)uploadSucWithobjects:(NSArray *)objects
{
    if (secImageSuc && firstImageSuc)
    {
        AVObject *userDetail = [objects objectAtIndex:0];
        [userDetail setObject:@"未处理" forKey:@"isAuthorized"];
        [userDetail saveEventually];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(2) forKey:@"userIsValidate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self performSelector:@selector(backView) withObject:self afterDelay:1];
    }
}

- (void)backView{
    [self.navigationController popViewControllerAnimated:YES];
    
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
