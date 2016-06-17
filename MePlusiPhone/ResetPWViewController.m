//
//  ResetPWViewController.m
//  MePlusiPhone
//
//  Created by sks on 16/6/16.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "ResetPWViewController.h"

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
//#pragma mark ------------ 隐藏导航栏
//- (void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//}
#pragma mark ------------  回收键盘
//点击键盘上return回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:10.0 animations:^{
        self.backView.frame = CGRectMake(0, -200, kScreenWidth, kScreenHeight-300);
    }];
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
            [UIView setAnimationDelay:2.0];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            MJJLog(@"errorerror");
        }
    }];
}
@end
