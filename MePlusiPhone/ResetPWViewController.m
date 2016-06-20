//
//  ResetPWViewController.m
//  MePlusiPhone
//
//  Created by sks on 16/6/16.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "ResetPWViewController.h"
#import "LoginViewController.h"

@interface ResetPWViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UIView *backView;



- (IBAction)ResetPasswordAction:(id)sender;


@end

@implementation ResetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtnWithName:@""];
    
    self.emailTF.delegate = self;
   
}
#pragma mark ------------ 隐藏导航栏
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = kMainColor;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ResetPasswordAction:(id)sender {

    [AVUser requestPasswordResetForEmailInBackground:self.emailTF.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"重置请求已发送至您的邮箱" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                LoginViewController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginVC"];
                [self.navigationController pushViewController:loginVC animated:NO];
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            

            
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您输入的邮箱有误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }];
}
@end
