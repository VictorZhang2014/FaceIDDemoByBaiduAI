//
//  ViewController.m
//  FaceIDRecognizerDemo
//
//  Created by Victor Zhang on 2017/12/3.
//  Copyright © 2017年 Victor Studio. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>


@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) BOOL isSignedUp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册按钮
    UIButton *registerBtn = [[UIButton alloc] init];
    registerBtn.translatesAutoresizingMaskIntoConstraints = false;
    [registerBtn setTitle:@"Sign Up by Face ID" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [registerBtn setBackgroundColor:[UIColor greenColor]];
    [registerBtn addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    //登陆按钮
    UIButton *loginBtn = [[UIButton alloc] init];
    loginBtn.translatesAutoresizingMaskIntoConstraints = false;
    [loginBtn setTitle:@"Sign In by Face ID" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [loginBtn setBackgroundColor:[UIColor greenColor]];
    [loginBtn addTarget:self action:@selector(signIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(registerBtn, loginBtn);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(90)-[registerBtn(==45)]-[loginBtn(==45)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[registerBtn]-(20)-|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[loginBtn]-(20)-|" options:0 metrics:nil views:views]];
    
}

- (void)signUp
{
    self.isSignedUp = YES;
    
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    imagepicker.title = @"选择一张照片作为登录依据";
    [self presentViewController:imagepicker animated:YES completion:nil];
}

- (void)signIn
{
    self.isSignedUp = NO;
    
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    [self presentViewController:imagepicker animated:YES completion:nil];
}

- (void)signInByFacePhoto:(UIImage *)image {
    ///http://ai.baidu.com/docs#/FACE-API/top
   
    NSURL *url = [NSURL URLWithString:@"https://aip.baidubce.com/rest/2.0/face/v2/identify?access_token=24.48afaec56f491332f092314fbdd00fa6.2592000.1514881126.282335-10233570"];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *base64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    paramDict[@"group_id"] = @"group_id";
    paramDict[@"image"] = base64Str;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url.absoluteString parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        /*
         "log_id" = 2670583803120321;
         result =     (
             {
                 "group_id" = "group_id";
                     scores =             (
                         100
                     );
                 uid = "test_uid";
                 "user_info" = "user_info";
             }
         );
         "result_num" = 1;
         */
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)signUpByFacePhoto:(UIImage *)image {
    ///http://ai.baidu.com/docs#/FACE-API/top
    
    NSURL *url = [NSURL URLWithString:@"https://aip.baidubce.com/rest/2.0/face/v2/faceset/user/add?access_token=24.48afaec56f491332f092314fbdd00fa6.2592000.1514881126.282335-10233570"];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *base64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    paramDict[@"uid"] = @"test_uid";
    paramDict[@"group_id"] = @"group_id";
    paramDict[@"user_info"] = @"user_info";
    paramDict[@"image"] = base64Str;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url.absoluteString parameters:paramDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (self.isSignedUp) {
        [self signUpByFacePhoto:image];
    } else {
        [self signInByFacePhoto:image];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
