//
//  ScanViewController.m
//  
//
//  Created by sks on 16/6/6.
//
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SingleTon.h"
#import "ViewController.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property(nonatomic)BOOL isReading;
//2.1设置一个用于显示的View---扫描的范围框
@property(nonatomic,strong)UIView *showView;
@property(nonatomic,strong)CALayer *scanLineLayer;
//2.2设置一个捕获会话
@property(nonatomic,strong)AVCaptureSession *captureSession;
//2.3展示layer即为照相机显示的范围
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *videoPreviewLayer;

-(BOOL)startReading;
-(void)stopReading;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtnWithName:@""];
    
    
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = kMainColor;
}

-(void)viewWillAppear:(BOOL)animated{
    
//    if (!_isReading) {
//        if ([self startReading]) {
//        }
//    }
//    else{
//        [self stopReading];
//    }
//    
//    _isReading = !_isReading;
    self.navigationController.navigationBar.barTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.001];

    NSError *error;
    //第四步：
    //11.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.初始化会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue= dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [self.view.layer addSublayer:_videoPreviewLayer];
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    //10.1.扫描框
    _showView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.1f, self.view.bounds.size.height * 0.3f,self.view.bounds.size.width - self.view.bounds.size.width * 0.2f, self.view.bounds.size.height -self.view.bounds.size.height * 0.6f)];
    _showView.layer.borderColor = [UIColor yellowColor].CGColor;
    _showView.layer.borderWidth = 1.0f;
    [self.view addSubview:_showView];
    
    //10.2.扫描线
    _scanLineLayer = [[CALayer alloc] init];
    _scanLineLayer.frame = CGRectMake(0, 0, _showView.bounds.size.width, 1);
    _scanLineLayer.backgroundColor = [UIColor redColor].CGColor;
    
    [_showView.layer addSublayer:_scanLineLayer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    

}
//扫描线的动画范围
- (void)moveScanLayer:(NSTimer *)timer{
    CGRect frame = _scanLineLayer.frame;
    //先判断扫描线是否已经出扫描框的范围
    if (_showView.frame.size.height < _scanLineLayer.frame.origin.y) {
        frame.origin.y = 0;  //如果是，就讲扫描线的y值归0，从扫描框顶部开始
        _scanLineLayer.frame = frame;
    }else{
        //如果刚好在扫描框内，则每次y值加5向下移动
        frame.origin.y += 8;
        //设置扫描线移动的时间
        [UIView animateWithDuration:0.01 animations:^{
            _scanLineLayer.frame = frame;
        }];
    }
}

//停止流动
-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLineLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
    //    [_showView removeFromSuperview];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *result =[metadataObj stringValue];
            SingleTon *data = [SingleTon shareData];
            data.robotNum = result;
            
            //user.userid  robot.robotid
            
            AVQuery *query = [AVQuery queryWithClassName:@"user"];
            SingleTon *user = [SingleTon shareData];
//            MJJLog(@"user.id = %@ %@ ",user.userid,user.robotid);
            [query getObjectInBackgroundWithId:user.userid block:^(AVObject *object, NSError *error) {
                MJJLog(@"%@",[object objectForKey:@"username"]);
                [object setObject:data.robotNum forKey:@"robotUUID"];
                [object saveInBackground];
            }];
            
            AVQuery *query1 = [AVQuery queryWithClassName:@"Robot"];
            [query1 getObjectInBackgroundWithId:user.robotid block:^(AVObject *object, NSError *error) {
                [object setObject:data.robotNum forKey:@"robotUUID"];
                [object saveInBackground];
            }];
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"扫描结果" message:result preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
                _isReading = NO;
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ViewController *VC = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
                [self.navigationController pushViewController:VC animated:YES];
                
            }
                                     ];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            //            [_startBtn setTitle:@"开始扫描" forState:UIControlStateNormal];
        }
        
    }
}
//是否支持屏幕反转
- (BOOL)shouldAutorotate
{
    return NO;
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

@end
