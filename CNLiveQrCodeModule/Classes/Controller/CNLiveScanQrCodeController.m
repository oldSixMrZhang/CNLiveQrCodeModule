//
//  CNLiveScanQrCodeController.m
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveScanQrCodeController.h"

#import "MJExtension.h"
#import "QMUIKit.h"

#import "SGQRCode.h"//二维码库
#import "CNLiveCategory.h"

#import "CNLiveMyQrCodeController.h"
#import "CNLiveNavigationBar.h"

#import "CNLiveScanResultController.h"

@interface CNLiveScanQrCodeController (){
    SGQRCodeObtain *obtain;
}
@property (nonatomic, strong) CNLiveNavigationBar *navigationBar;
@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UIButton *flashlightBtn;//手电筒
@property (nonatomic, assign) BOOL isSelected;//是否打开手电筒
@property (nonatomic, strong) UIButton *codeButton;//我的二维码
@property (nonatomic, strong) UILabel *promptLabel;//将二维码/条码放入框内, 即可自动扫描

@end

@implementation CNLiveScanQrCodeController
static const CGFloat timeValue = 1.5;

- (void)getAVAuthorizationStatus:(void (^)(void))block{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            block();
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                block();
                break;
            }
            case AVAuthorizationStatusDenied: {
                NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
                if (app_Name == nil) {
                    app_Name = [infoDict objectForKey:@"CFBundleName"];
                }
                NSString *messageString = [NSString stringWithFormat:@"请在iPhone的\"设置 - 隐私 - 相机\"选项中,允许%@访问你的相机", app_Name];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    [QMUITips showError:@"未检测到您的摄像头" inView:self.view hideAfterDelay:timeValue];
}

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [obtain startRunningWithBefore:nil completion:nil];
    [self.scanView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
    [self removeFlashlightBtn];
    [obtain stopRunning];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    if (@available(iOS 11, *)) {
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    obtain = [SGQRCodeObtain QRCodeObtain];
    [self getAVAuthorizationStatus:^{
        [self startScanQRCode];

    }];
    
    [self createSubViews];

}

- (void)dealloc {
    [self removeScanningView];
}

- (void)removeScanningView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

#pragma mark - UI
- (void)createSubViews {
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.flashlightBtn];
    [self.view addSubview:self.codeButton];
    [self.view addSubview:self.promptLabel];
    [self.view addSubview:self.navigationBar];

}
#pragma mark - 扫描二维码
- (void)startScanQRCode{
    // 创建二维码扫描
    __weak typeof(self) weakSelf = self;
    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.sampleBufferDelegate = YES;
    configure.openLog = YES;
    configure.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    // 这里只是提供了几种作为参考（共：13）；需什么类型添加什么类型即可
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    configure.metadataObjectTypes = arr;
    
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    [obtain startRunningWithBefore:^{
        
    } completion:^{

    }];
    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return ;
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
            [QMUITips showError:@"暂未识别出二维码" inView:strongSelf.view hideAfterDelay:timeValue];

        } else {
            [obtain stopRunning];
            [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
            [strongSelf handleResult:result];

        }

    }];
    // 根据外界光线强弱值判断是否自动开启手电筒
    [obtain setBlockWithQRCodeObtainScanBrightness:^(SGQRCodeObtain *obtain, CGFloat brightness) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return ;
        if (brightness < - 1) {
            [strongSelf.view addSubview:weakSelf.flashlightBtn];
            
        } else {
            if (strongSelf.isSelected == NO) {
                [strongSelf removeFlashlightBtn];
            }
        }
    }];
}

#pragma mark - 识别二维码后判断处理
- (void)handleResult:(NSString *)result{
    NSLog(@"结果---%@",result);
    // 1.json字符串转字典
    NSDictionary *resultDic = [self dictionaryWithJsonString:result];
    // 2.字典取值判断是不是app的业务
    // 是app的业务
    if (resultDic&&[resultDic[@"type"] isEqualToString:@"user"]) {
        // 3.字典取值解密判断页面跳转
        if(resultDic[@"content"]&&![resultDic[@"content"] isEqualToString:@""]){
//            NSString *content = [XWCryptoDES decryptUseDES:resultDic[@"content"] key:AppDESKey];
//            NSDictionary *contentDic = [self dictionaryWithJsonString:content];
//            [self jumpToController:contentDic];
        }
    }
    // 不是app的业务
    else{
        CNLiveScanResultController *jumpVC = [[CNLiveScanResultController alloc] init];
        jumpVC.jump_URL = result;
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
    
}

#pragma mark - 识别二维码后页面跳转
// 页面跳转
- (void)jumpToController:(NSDictionary *)content {
    
    
}

// json字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return @{};
    }
    return dic;
}

#pragma mark - 代理
/**
 * 状态栏的颜色
 *
 * @return UIStatusBarStyle
 *
 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;

}

#pragma mark - 懒加载
- (CNLiveNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [CNLiveNavigationBar navigationBar];
        _navigationBar.backgroundColor = [UIColor clearColor];
        UIImage *image = [self getImageWithImageName:@"cnlive_back_white_b" bundleName:@"CNLiveCustomControl" targetClass:[CNLiveNavigationBar class]];
        _navigationBar.leftImage = image;
        
        _navigationBar.title.text = @"扫一扫";
        _navigationBar.title.textColor = [UIColor whiteColor];

        _navigationBar.rightTitle = @"相册";
        [_navigationBar.right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        _navigationBar.lineHidden = YES;

        __weak typeof(self) weakSelf = self;
         _navigationBar.onClickLeftButton = ^{
             __strong typeof(weakSelf) strongSelf = weakSelf;
             if(!strongSelf) return;
             [strongSelf goBack];
         };
    
#pragma mark - 选择图片识别二维码
        _navigationBar.onClickRightButton = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf) return ;
            [strongSelf rightButtonOnClick];
        };
    }
    return _navigationBar;
}
- (void)rightButtonOnClick{
    _navigationBar.right.userInteractionEnabled = NO;
    // 从相册中读取二维码
    [obtain establishAuthorizationQRCodeObtainAlbumWithController:nil];
    if (obtain.isPHAuthorization == YES) {
        [self.scanView removeTimer];
    }
    
    __weak typeof(self) weakSelf = self;
    [obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:^(SGQRCodeObtain *obtain) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return ;
        strongSelf.navigationBar.right.userInteractionEnabled = YES;
    }];
    [obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return ;
        strongSelf.navigationBar.right.userInteractionEnabled = YES;
        if (result == nil) {
            NSLog(@"暂未识别出二维码");
            [QMUITips showError:@"暂未识别出二维码" inView:strongSelf.view hideAfterDelay:timeValue];

        } else {
            [strongSelf handleResult:result];
        }
    }];

}
- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _scanView;
}
- (UIButton *)flashlightBtn {
    if (!_flashlightBtn) {
        _flashlightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat flashlightBtnW = 100;
        CGFloat flashlightBtnH = 50;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = 0.55 * self.view.frame.size.height;
        _flashlightBtn.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        UIImage *image1 = [self getImageWithImageName:@"flashlight_close" bundleName:@"CNLiveQrCodeModule" targetClass:[CNLiveScanQrCodeController class]];
        UIImage *image2 = [self getImageWithImageName:@"flashlight_open" bundleName:@"CNLiveQrCodeModule" targetClass:[CNLiveScanQrCodeController class]];
        [_flashlightBtn setImage:image1 forState:UIControlStateNormal];
        [_flashlightBtn setImage:image2 forState:UIControlStateSelected];
        [_flashlightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_flashlightBtn setTitleColor:[UIColor colorWithRed:35/255.0 green:212/255.0 blue:30/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [_flashlightBtn setTitleColor:[UIColor colorWithRed:35/255.0 green:212/255.0 blue:30/255.0 alpha:1.0] forState:UIControlStateSelected];
        [_flashlightBtn setTitle:@"轻触点亮" forState:UIControlStateNormal];
        [_flashlightBtn setTitle:@"轻触关闭" forState:UIControlStateHighlighted];
        [_flashlightBtn setTitle:@"轻触关闭" forState:UIControlStateSelected];
        _flashlightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_flashlightBtn addTarget:self action:@selector(flashlightButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _flashlightBtn.titleEdgeInsets = UIEdgeInsetsMake(_flashlightBtn.imageView.frame.size.height+10, -_flashlightBtn.imageView.frame.size.width, 0, 0);
        _flashlightBtn.imageEdgeInsets = UIEdgeInsetsMake(-_flashlightBtn.titleLabel.bounds.size.height, 0, 10, -_flashlightBtn.titleLabel.bounds.size.width);
    }
    return _flashlightBtn;
    
}
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.73 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码/条码放入框内, 即可自动扫描";
    }
    return _promptLabel;
    
}
- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        CGFloat flashlightBtnW = 100;
        CGFloat flashlightBtnH = 50;
        CGFloat flashlightBtnX = 0.5 * (self.view.frame.size.width - flashlightBtnW);
        CGFloat flashlightBtnY = CGRectGetMaxY(self.promptLabel.frame)+15;
        _codeButton.frame = CGRectMake(flashlightBtnX, flashlightBtnY, flashlightBtnW, flashlightBtnH);
        UIImage *image = [self getImageWithImageName:@"qr_code_green" bundleName:@"CNLiveQrCodeModule" targetClass:[CNLiveScanQrCodeController class]];
        [_codeButton setImage:image forState:UIControlStateNormal];
        [_codeButton setTitle:@"我的二维码" forState:UIControlStateNormal];
        _codeButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15.0f];
        [_codeButton setTitleColor:[UIColor colorWithRed:35/255.0 green:212/255.0 blue:30/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(codeButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_codeButton  setAdjustsImageWhenHighlighted:NO];
        _codeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
        _codeButton.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, -80);
    }
    return _codeButton;
    
}

#pragma mark - 响应方法
- (void)goBack {
    if (self.presentingViewController != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)flashlightButtonDidClicked:(UIButton *)button {
    if (button.selected == NO) {
        [obtain openFlashlight];
        self.isSelected = YES;
        button.selected = YES;
    }
    else {
        [self removeFlashlightBtn];
    }
}
- (void)removeFlashlightBtn {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->obtain closeFlashlight];
        self.isSelected = NO;
        self.flashlightBtn.selected = NO;
        [self.flashlightBtn removeFromSuperview];
    });
    
}
- (void)codeButtonDidClicked:(UIButton *)button{
    if(self.isMyCode){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        CNLiveMyQrCodeController *vc = [[CNLiveMyQrCodeController alloc] init];
        vc.isScanCode = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

@end
