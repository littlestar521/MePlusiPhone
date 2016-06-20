//
//  LoginViewController.m
//  MePlusiPhone
//
//  Created by sks on 16/6/13.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "MePlus.pch"
#import <AVOSCloud/AVOSCloud.h>
#import "SSKeychain.h"

// 如果使用了实时通信模块，请添加以下导入语句：
//#import <AVOSCloudIM/AVOSCloudIM.h>

@interface LoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)NSString *robotUUID;

@property (weak, nonatomic) IBOutlet UITextField *numberTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


- (IBAction)forgetPasswordBtn:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)registerAction:(id)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //密码密文显示
    self.passwordTF.secureTextEntry = YES;
    
    //设置代理
    self.numberTF.delegate = self;
    self.passwordTF.delegate = self;
    
       
    
    
}
#pragma mark ------------ 隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark ------------  回收键盘
//点击键盘上return回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
//点击空白处回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//弹出键盘时，输入框上移至被隐藏
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGFloat offset = self.view.frame.size.height- (textField.frame.origin.y + textField.frame.size.height+216+80);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}
//实现回收键盘时，输入框恢复原来的位置
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgetPasswordBtn:(id)sender {
}

- (IBAction)loginAction:(id)sender {
    
    [AVUser logInWithUsernameInBackground:self.numberTF.text password:self.passwordTF.text block:^(AVUser *user, NSError *error) {
        if (user) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil userInfo:@{@"import":self.numberTF.text}];
//            [self uuid];
           
            UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *VC = [SB instantiateViewControllerWithIdentifier:@"ViewController"];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您输入的账号或密码不正确，请核对后再输" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];

            MJJLog(@"！！%@",error);
        }
    }];
}
- (void)uuid{

//    NSString *uuid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
//    MJJLog(@"%@",uuid);
//
    //获取objectid
//    AVObject *userid = [AVObject objectWithClassName:@"_User"];
//    [userid setObject:uuid  forKey:@"userUUID"];
//    [userid saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            MJJLog(@"!!!存储成功%@",userid.objectId);
//        }else{
//            MJJLog(@"####请检查网络环境以及SDK配置是否正确");
//        }
//    }];

//    AVObject *to = [AVObject objectWithClassName:@"_User" objectId:userid.objectId];
//    [to setObject:uuid forKey:@"userUUID"];
//    [to saveInBackground];
//    
//    AVObject *todo = [AVObject objectWithClassName:@"_User"];
//    [todo setObject:[NSString stringWithFormat:@"%@",uuid] forKey:@"userUUID"];
//    [todo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (succeeded) {
//            // 存储成功
//            [todo setObject:[NSString stringWithFormat:@"%@",uuid]  forKey:@"userUUID"];
//            [todo saveInBackground];
//        } else {
//            // 失败的话，请检查网络环境以及 SDK 配置是否正确
//            MJJLog(@"error");
//        }
//    }];
    
    
}




- (IBAction)registerAction:(id)sender {
}
@end
