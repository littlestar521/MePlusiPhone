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

static NSString *const AGDSegueID  = @"Chat";

@interface ViewController ()
@property(nonatomic,strong)UIButton *actionBtn;
@property(nonatomic,strong)NSString *vendorKey;
@property(nonatomic,strong)NSString *roomNum;

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
    self.roomNum = @"e3347dee5a6c11f5";
    
    //
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    self.vendorKey = [userDefaults objectForKey:AGDKeyVendorKey];
//    if (self.vendorKey) {
        self.vendorKey = kAppKey;
//    }else{
//        NSLog(@"1234空值");
//    }

    
}
#pragma mark  ------------- appKey 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (![segue.identifier isEqualToString:AGDSegueID]) {
        return;
    }
    AGDChatViewController *chatVC = segue.destinationViewController;
    chatVC.dictionary = @{AGDKeyChannel:self.roomNum,AGDKeyVendorKey:self.vendorKey};
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        chatVC.chatType = AGDChatTypeDefault;
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
#pragma  mark --------------- 移除通知
//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark ---------------- voice
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
    if ([self isValidInput]) {
//        [self performSegueWithIdentifier:AGDSegueID sender:sender];
        UIStoryboard *agdSB = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
        AGDChatViewController *AGDVC = [agdSB instantiateViewControllerWithIdentifier:@"AGDChatViewController"];
        [self.navigationController pushViewController:AGDVC animated:YES];
    }
}
- (BOOL)isValidInput{
    [self.view endEditing:YES];
    if (self.vendorKey.length && self.roomNum.length) {
        
        NSLog(@"appKey  = %@,roomNum = %@",self.vendorKey,self.roomNum);
        return YES;
    }else{
        NSLog(@"####请求失败##### = %@ ,$$$$$$$$ = %@",self.vendorKey,self.roomNum);
        
    return NO;
    }
}

@end
