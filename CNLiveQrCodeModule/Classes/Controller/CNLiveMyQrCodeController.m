//
//  CNLiveQrCodeController.m
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveMyQrCodeController.h"
#import <Photos/Photos.h>
#import <Accelerate/Accelerate.h>

#import "QMUIKit.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "CNLiveCategory.h"
#import "CNLiveNavigationBar.h"

#import "CNLiveMyQrCodeView.h"
#import "CNLiveScanQrCodeController.h"

@interface CNLiveMyQrCodeController ()<QMUIAlertControllerDelegate>
@property (nonatomic, strong) CNLiveNavigationBar *navigationBar;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) CNLiveMyQrCodeView *qrCodeView;

@end

@implementation CNLiveMyQrCodeController
static const NSInteger margin = 20;
static const CGFloat timeValue = 1.5;

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    if (@available(iOS 11, *)) {
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self createSubViews];    
}

- (void)dealloc {
    NSLog(@"CNLiveMyQrCodeController -- dealloc");
    
}

- (void)createSubViews {
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.qrCodeView];
    [self.view addSubview:self.navigationBar];

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

- (void)getPHAuthorizationStatus:(void (^)(void))block{
    // 1.获取当前App的相册授权状态
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    
    // 2.判断授权状态
    if (authorizationStatus == PHAuthorizationStatusAuthorized) {
        // 2.1 如果已经授权, 保存图片(调用步骤2的方法)
        block();
        
    } else if (authorizationStatus == PHAuthorizationStatusNotDetermined) { // 如果没决定, 弹出指示框, 让用户选择
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            // 如果用户选择授权, 则保存图片
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
        }];
        
    } else {
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
        if (app_Name == nil) {
            app_Name = [infoDict objectForKey:@"CFBundleName"];
        }
        NSString *messageString = [NSString stringWithFormat:@"请在iPhone的\"设置 - 隐私 - 相机\"选项中,允许%@访问你的相册", app_Name];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"好" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

// 保存图片
- (void)saveImage:(UIImage *)image{
    if(!image){
        [QMUITips showError:@"保存失败" inView:self.view hideAfterDelay:timeValue];
        return;
    }
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [QMUITips showSucceed:@"保存成功" inView:self.view hideAfterDelay:timeValue];
            } else {
                [QMUITips showError:@"保存失败" inView:self.view hideAfterDelay:timeValue];
            }
        });
        
    }];
}
// UIView转UIImage
- (UIImage *)generateImage:(UIView *)view{
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    // 2. 将控制器View的Layer渲染到上下文
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 3.取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 4.结束上下文
    UIGraphicsEndImageContext();

    return newImage;
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

- (void)didHideAlertController:(QMUIAlertController *)alertController{
    self.navigationBar.right.userInteractionEnabled = YES;

}

#pragma mark - 懒加载
- (UIImageView *)bgView{
    if(!_bgView){
        _bgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        UIImage *image = [self getImageWithImageName:@"qr_code_bg" bundleName:@"CNLiveQrCodeModule" targetClass:[CNLiveMyQrCodeController class]];
        [_bgView sd_setImageWithURL:[NSURL URLWithString:@"User_Head"] placeholderImage:image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }
    return _bgView;
}
- (CNLiveMyQrCodeView *)qrCodeView {
    if (!_qrCodeView) {
        _qrCodeView = [[CNLiveMyQrCodeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*margin, SCREEN_WIDTH-2*margin+40)];
        _qrCodeView.center = self.view.center;
        _qrCodeView.text = @"扫描二维码,加我好友";
    }
    return _qrCodeView;
}
- (CNLiveNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [CNLiveNavigationBar navigationBar];
        _navigationBar.backgroundColor = [UIColor clearColor];
        UIImage *image1 = [self getImageWithImageName:@"cnlive_back_white_b" bundleName:@"CNLiveCustomControl" targetClass:[CNLiveNavigationBar class]];
        _navigationBar.leftImage = image1;

        _navigationBar.title.text = @"我的二维码";
        _navigationBar.title.textColor = [UIColor whiteColor];
        _navigationBar.lineHidden = YES;
        
        UIImage *image2 = [self getImageWithImageName:@"cnlive_white_more" bundleName:@"CNLiveCustomControl" targetClass:[CNLiveNavigationBar class]];
        _navigationBar.rightImage = image2;
        
        __weak typeof(self) weakSelf = self;
        _navigationBar.onClickLeftButton = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
             if(!strongSelf) return ;
            [strongSelf goBack];
        };
        _navigationBar.onClickRightButton = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
             if(!strongSelf) return ;
            [strongSelf rightButtonOnClick];
            
        };
    }
    return _navigationBar;
}
- (void)rightButtonOnClick{
    self.navigationBar.right.userInteractionEnabled = NO;
    __weak typeof(self) weakSelf = self;
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"保存图片" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return ;
        [strongSelf getPHAuthorizationStatus:^{
            UIImage *image = [strongSelf generateImage:strongSelf.qrCodeView];
            [QMUITips showLoadingInView:strongSelf.view];
            [strongSelf saveImage:image];
            [QMUITips hideAllTipsInView:strongSelf.view];
        }];
        strongSelf.navigationBar.right.userInteractionEnabled = YES;

     }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"扫描二维码" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return ;
        if(strongSelf.isScanCode){
            [strongSelf.navigationController popViewControllerAnimated:YES];
        }else{
            CNLiveScanQrCodeController *vc = [[CNLiveScanQrCodeController alloc]init];
            vc.isMyCode = YES;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        }
        strongSelf.navigationBar.right.userInteractionEnabled = YES;
    }];
    QMUIAlertAction *action3 = [QMUIAlertAction actionWithTitle:@"重置二维码" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return ;
        [strongSelf.qrCodeView generateQRCode:@"reset"];
        strongSelf.navigationBar.right.userInteractionEnabled = YES;

    }];
    QMUIAlertAction *cancel = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
          __strong typeof(weakSelf) strongSelf = weakSelf;
          if(!strongSelf) return ;
          strongSelf.navigationBar.right.userInteractionEnabled = YES;

      }];
           
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:QMUIAlertControllerStyleActionSheet];
    alertController.delegate = self;
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:cancel];

    NSMutableDictionary *titleAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertTitleAttributes];
           
    titleAttributs[NSForegroundColorAttributeName] = [UIColor colorWithRed:35/255.0 green:212/255.0 blue:30/255.0 alpha:1.0];
    
    NSMutableDictionary *cancelAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertTitleAttributes];
    cancelAttributs[NSForegroundColorAttributeName] = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

    action1.buttonAttributes = titleAttributs;
    action2.buttonAttributes = titleAttributs;
    action3.buttonAttributes = titleAttributs;
    cancel.buttonAttributes = cancelAttributs;

    [alertController showWithAnimated:YES];
}

@end
