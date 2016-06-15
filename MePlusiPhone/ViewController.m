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
@property(nonatomic,strong)UIView *lightView;
@property(nonatomic,strong)UILabel *tipLabel;


- (IBAction)RTVAction:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self showLeftBtnWithName:@"首页"];

    [self voiceAction];
    
        //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAction:) name:@"message" object:nil];
//    self.roomNum = @"e3347dee5a6c11f5";
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    self.vendorKey = [userDefaults objectForKey:AGDKeyVendorKey];
//    if (self.vendorKey) {
        self.vendorKey = kAppKey;
//    }else{
//        MJJLog(@"1234空值");
//    }

    
}

#pragma  mark --------------- 接收和移除通知
//接收通知
- (void)changeAction:(NSNotification *)notification{
    self.roomNum = notification.userInfo[@"input"];
}
//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
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
- (void)resultAction:(UIButton *)btn{
}
#pragma mark ---------------- voice
- (void)voiceAction{
    
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    voice.frame = CGRectMake(kScreenWidth*3/4, kScreenHeight-80, 60, 60);
    voiceBtn.frame = CGRectMake(kScreenWidth*3/4, 0, 50, 50);
    [voiceBtn setBackgroundColor: [UIColor redColor]];
//    [voice setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    voiceBtn.tag = 1;
    [voiceBtn setTitle:@"voice" forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(robotOnLineAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:voice];
    self.lightView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-70, kScreenWidth, 120)];
//    self.lightView.backgroundColor = [UIColor whiteColor];
    
    self.tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, voiceBtn.frame.size.height+20, kScreenWidth, 50)];
    self.tipLabel.backgroundColor = [UIColor grayColor];
    self.tipLabel.textColor = [UIColor whiteColor];
    
    [self.lightView addSubview:self.tipLabel];
    
    UIButton *makesureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    makesureBtn.frame = CGRectMake(kScreenWidth*3/4-20, voiceBtn.frame.size.height+30, 90, 30);
    [makesureBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [makesureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [makesureBtn addTarget:self action:@selector(robotOnLineAction:) forControlEvents:UIControlEventTouchUpInside];
    makesureBtn.tag = 2;
    [self.lightView addSubview:makesureBtn];
    [self.lightView addSubview:voiceBtn];
    [self.view addSubview:self.lightView];
    
    
    
    
}
//
- (void)robotOnLineAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1:
        {
            if (self.roomNum == nil) {
                self.tipLabel.text = @"   绑定多我机器人吗？";
            }else{
                self.tipLabel.text = @"   唤醒多我机器人吗？";
            }
                [UIView animateWithDuration:0.1 animations:^{
                self.lightView.frame = CGRectMake(0, kScreenHeight-120, kScreenWidth, 120);
                 }];
        }
            break;
        case 2:
        {
            [UIView animateWithDuration:0.1 animations:^{
                self.lightView.frame = CGRectMake(0, kScreenHeight-70, kScreenWidth, 120);
                
            }];
            if (self.vendorKey.length && self.roomNum.length) {
                MJJLog(@"appKey  = %@,roomNum = %@",self.vendorKey,self.roomNum);
//                return YES;
            }else{
                MJJLog(@"####请求失败##### = %@ ,$$$$$$$$ = %@",self.vendorKey,self.roomNum);
//                return NO;
            }

            if (self.roomNum == nil) {
                RobotOnLineViewController *robotVC = [[RobotOnLineViewController alloc]init];
                [self.navigationController pushViewController:robotVC animated:YES];
            }else{

                UIStoryboard *agdSB = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
                AGDChatViewController *AGDVC = [agdSB instantiateViewControllerWithIdentifier:@"AGDChatViewController"];
                [self.navigationController pushViewController:AGDVC animated:YES];
            }
        }
            break;

        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//视频界面
//- (IBAction)RTVAction:(id)sender {
//    if ([self isValidInput]) {
////        [self performSegueWithIdentifier:AGDSegueID sender:sender];
//        
//    }
//}
//- (BOOL)isValidInput{
//    [self.view endEditing:YES];
//    if (self.vendorKey.length && self.roomNum.length) {
//        
//        MJJLog(@"appKey  = %@,roomNum = %@",self.vendorKey,self.roomNum);
//        return YES;
//    }else{
//        MJJLog(@"####请求失败##### = %@ ,$$$$$$$$ = %@",self.vendorKey,self.roomNum);
//        
//    return NO;
//    }
//}

@end
