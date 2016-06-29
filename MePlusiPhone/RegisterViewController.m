//
//  RegisterViewController.m
//  MePlusiPhone
//
//  Created by sks on 16/6/13.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "RegisterViewController.h"
#import "SingleTon.h"
#import "ViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>


@property(nonatomic,strong)NSString *robotUUID;
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

//注册
- (IBAction)registerACtion:(id)sender {
    
    if (![self checkOut]) {
        return;
    }
    AVUser *user = [AVUser user];
    user.username = self.numberTF.text;
    user.password = self.password.text;
    user.email = self.emailTF.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSString *uuid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
            AVObject *main = [AVObject objectWithClassName:@"_User" objectId:user.objectId];
            [main setObject:uuid forKey:@"userUUID"];
            [main saveInBackground];
//            AVObject *robot = [AVObject objectWithClassName:@"Robot"];
//            [robot saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                if (succeeded) {
                    SingleTon *singleTon = [SingleTon shareData];
                    singleTon.userid = main.objectId;
//                    singleTon.robotid = robot.objectId;
//                }
//            }];
//            
            //注册成功
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"恭喜您，已注册成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [AVUser logInWithUsernameInBackground:user.username  password:user.password block:^(AVUser *user, NSError *error) {
                    if (user) {
                        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ViewController *VC = [SB instantiateViewControllerWithIdentifier:@"ViewController"];
                        [self.navigationController pushViewController:VC animated:YES];
                    }
                }];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            //注册失败
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"你注册的用户已存在或邮箱有误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];

}
//关联表
- (void)relationClasses{
    NSString *uuid = [[[UIDevice currentDevice]identifierForVendor]UUIDString];
    MJJLog(@"%@",uuid);
    
    AVObject *main = [[AVObject alloc]initWithClassName:@"_User"];
    [main setObject:self.emailTF.text forKey:@"email"];
    [main setObject:self.numberTF.text forKey:@"username"];
    [main setObject:self.password.text forKey:@"password"];
    [main setObject:uuid forKey:@"userUUID"];
    [main setObject:@"" forKey:@"robotUUID"];
    
    AVObject *user2 = [[AVObject alloc]initWithClassName:@"Robot"];
    [user2 setObject:nil forKey:@"robotName"];
    [user2 setObject:@"me+，机器人" forKey:@"robotDescription"];
    [user2 setObject:@"" forKey:@"robotUUID"];

    [AVObject saveAllInBackground:@[user2] block:^(BOOL succeeded, NSError *error) {
        if (error) {
            MJJLog(@"链接出错");
        }else{
            AVRelation *relation = [main relationForKey:@"containedToUsers"];
            [relation addObject:user2];
            
            
            [main saveInBackground];
            
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
