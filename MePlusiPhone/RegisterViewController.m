//
//  RegisterViewController.m
//  MePlusiPhone
//
//  Created by sks on 16/6/13.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *makesureTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)registerACtion:(id)sender;
- (IBAction)loginAction:(id)sender;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //密码密文显示
    self.password.secureTextEntry = YES;
    self.makesureTF.secureTextEntry = YES;
    //设置代理
    self.numberTF.delegate = self;
    self.emailTF.delegate = self;
    self.password.delegate = self;
    self.makesureTF.delegate = self;
    
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
//注册
- (IBAction)registerACtion:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"email" object:nil userInfo:@{@"import":self.emailTF.text}];
    
    if (![self checkOut]) {
        return;
    }
    //注册
    AVUser *user = [AVUser user];//新建AVUser对象实例
    user.username = self.numberTF.text;//设置用户名
    user.password = self.password.text;//设置密码
    user.email = self.emailTF.text;//设置邮箱
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //注册成功
            MJJLog(@"恭喜您，已注册成功");
        }else{
            //注册失败
            MJJLog(@"对不起，你注册的用户已存在");
        }
    }];

}
//登录
- (IBAction)loginAction:(id)sender {
}
//注册之前需要判断
- (BOOL)checkOut{
    //用户名不能为空且不能为空格
    if (self.numberTF.text.length <= 0 && [self.numberTF.text stringByReplacingOccurrencesOfString:@"" withString:@"  "].length <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示：" message:@"用户名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    if (![self.password.text isEqualToString:self.makesureTF.text]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示：" message:@"两次密码输入不一致" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    if (self.password.text.length <= 0 && [self.password.text stringByReplacingOccurrencesOfString:@"" withString:@"  "].length <= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示：" message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    
    return YES;
}

@end
