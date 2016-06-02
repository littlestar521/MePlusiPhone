//
//  ViewController.m
//  MePlusiPhone
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 MePlus. All rights reserved.
//

#import "ViewController.h"
#import "MePlus.pch"
#import "LeftView.h"
#import "RobotOnLineViewController.h"
#import "AGDChatViewController.h"

@interface ViewController ()
@property(nonatomic,strong)UIButton *actionBtn;

- (IBAction)RTVAction:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self showLeftBtnWithName:@"首页"];

    [self voiceAction];
    
//    [self anyAction];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAction:) name:@"notification" object:nil];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *vendorKey = [userDefaults objectForKey:AGDKeyVendorKey];
    if (vendorKey) {
        vendorKey = kAppKey;
    }else{
    
    }

    
}
- (void)anyAction{
    self.actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.actionBtn.frame = CGRectMake(kScreenWidth*3/4-60, kScreenHeight-80-60, 60, 60);
    [self.actionBtn setBackgroundColor: [UIColor purpleColor]];
    [self.actionBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.actionBtn addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.actionBtn];


}
- (void)resultAction:(UIButton *)btn{
}
- (void)changeAction:(NSNotification *)notification{
    
    
}
//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)voiceAction{
    
    UIButton *voice = [UIButton buttonWithType:UIButtonTypeCustom];
    voice.frame = CGRectMake(kScreenWidth*3/4, kScreenHeight-80, 60, 60);
    [voice setBackgroundColor: [UIColor redColor]];
//    [voice setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [voice setTitle:@"voice" forState:UIControlStateNormal];
    [voice addTarget:self action:@selector(robotOnLineAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voice];
    
}
//
- (void)robotOnLineAction:(UIButton *)btn{
    
    RobotOnLineViewController *robotVC = [[RobotOnLineViewController alloc]init];
    [self.navigationController pushViewController:robotVC animated:YES];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//视频界面
- (IBAction)RTVAction:(id)sender {
//    if (<#condition#>) {
//        <#statements#>
//    }
    UIStoryboard *agdSB = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    AGDChatViewController *AGDVC = [agdSB instantiateViewControllerWithIdentifier:@"AGDChatViewController"];
    [self.navigationController pushViewController:AGDVC animated:YES];
    
}
@end
