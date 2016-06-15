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
// 如果使用了实时通信模块，请添加以下导入语句：
//#import <AVOSCloudIM/AVOSCloudIM.h>

@interface LoginViewController ()<UITextFieldDelegate>

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgetPasswordBtn:(id)sender {
}

- (IBAction)loginAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil userInfo:@{@"import":self.numberTF.text}];
    
    
    [AVUser logInWithUsernameInBackground:self.numberTF.text password:self.passwordTF.text block:^(AVUser *user, NSError *error) {
        if (user) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示：" message:@"登陆成功^^*^^" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//            [alert addAction:action];
//            [self presentViewController:alert animated:YES completion:nil];
            
            UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *VC = [SB instantiateViewControllerWithIdentifier:@"ViewController"];
            [self.navigationController pushViewController:VC animated:YES];
            
        }else{
            MJJLog(@"%@",error);
        }
    }];
}

- (IBAction)registerAction:(id)sender {
}
@end
