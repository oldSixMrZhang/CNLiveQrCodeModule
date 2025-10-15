//
//  CNLiveGroupQrCodeController.m
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveGroupQrCodeController.h"
#import <Masonry/Masonry.h>
#import "QMUIKit.h"
#import "SGQRCode.h"//二维码库

//#import "CNLiveShareManager.h"
//#import "CNLiveShareToolDefine.h"
#import "CNLiveCategory.h"
#import "CNLiveNavigationBar.h"

#import "CNLiveGroupQrcodeView.h"

@interface CNLiveGroupQrCodeController ()
@property (nonatomic, strong) CNLiveNavigationBar *navigationBar;
@property (nonatomic, strong) CNLiveGroupQrCodeView *groupView;
@property (nonatomic, strong) UIButton *save;
@property (nonatomic, strong) UIButton *share;

@end

@implementation CNLiveGroupQrCodeController
static const NSInteger margin = 10;
static const CGFloat timeValue = 1.5;

#pragma mark - 生命周期
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:249/255.0 alpha:1.0];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.groupView];
    
    [self.view addSubview:self.save];
    CGFloat width = (SCREEN_WIDTH-6*margin)/2.0;
    [self.save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(2.5*margin);
        make.top.mas_equalTo(self.groupView.mas_bottom).mas_offset(2*margin);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(40);

    }];
    
    [self.view addSubview:self.share];
    [self.share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.save.mas_right).mas_offset(margin);
        make.top.mas_equalTo(self.save.mas_top);
        make.width.mas_equalTo(self.save.mas_width);
        make.height.mas_equalTo(self.save.mas_height);

    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 懒加载
- (CNLiveNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [CNLiveNavigationBar navigationBar];
        _navigationBar.title.text = @"群二维码名片";
        __weak typeof(self) weakSelf = self;
        _navigationBar.onClickLeftButton = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(!strongSelf) return ;
            [strongSelf goBack];
        };
    }
    return _navigationBar;
}
- (CNLiveGroupQrCodeView *)groupView {
    if (!_groupView) {
        _groupView = [[CNLiveGroupQrCodeView alloc] initWithFrame:CGRectMake(0, 0, 310, 450)];
        _groupView.center = CGPointMake(self.view.center.x, self.view.center.y-20);
        _groupView.layer.masksToBounds = YES;
        _groupView.layer.cornerRadius = 10;
        _groupView.group = self.group;
    }
    return _groupView;
}
- (UIButton *)save{
    if(!_save){
        _save = [UIButton buttonWithType:UIButtonTypeCustom];
        _save.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _save.backgroundColor = [UIColor whiteColor];
        _save.layer.cornerRadius = 5;
        _save.layer.masksToBounds = YES;
        [_save addTarget:self action:@selector(saveBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_save setTitle:@"保存到手机" forState:UIControlStateNormal];
        [_save setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        _save.backgroundColor = [UIColor colorWithRed:234/255.0 green:236/255.0 blue:244/255.0 alpha:1.0];
        
    }
    return _save;
    
}
- (UIButton *)share{
    if(!_share){
        _share = [UIButton buttonWithType:UIButtonTypeCustom];
        _share.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _share.backgroundColor = [UIColor whiteColor];
        _share.layer.cornerRadius = 5;
        _share.layer.masksToBounds = YES;
        [_share addTarget:self action:@selector(shareDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_share setTitle:@"分享二维码" forState:UIControlStateNormal];
        [_share setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _share.backgroundColor = [UIColor colorWithRed:35/255.0 green:212/255.0 blue:30/255.0 alpha:1.0];
        
    }
    return _share;
    
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
#pragma mark - 保存到手机
- (void)saveBtnDidClicked:(UIButton *)btn{
    UIImage *image = [self generateImage:self.groupView];
    [QMUITips showLoadingInView:self.view];
    [self saveImage:image];
    [QMUITips hideAllTipsInView:self.view];

}

- (void)saveImage:(UIImage *)image {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success){
            dispatch_async(dispatch_get_main_queue(), ^{
                [QMUITips showSucceed:@"保存成功" inView:self.view hideAfterDelay:timeValue];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [QMUITips showError:@"保存失败" inView:self.view hideAfterDelay:timeValue];
            });
        }


    }];
    
}

#pragma mark - 分享二维码
- (void)shareDidClicked:(UIButton *)btn{
    UIImage *image = [self generateImage:self.groupView];
//    [CNLiveShareManager showShareViewWithParamForShareTitle:nil ShareUrl:nil ShareDesc:nil ShareImage:image ScreenFull:NO HiddenWjj:NO HiddenQQ:NO HiddenWB:NO HiddenWechat:NO HiddenSafari:YES TopImage:imageArray TopTitles:titleArray PlatformType:CNLiveSharePlatformTypeAll TouchActionBlock:^(NSString *title) {
//
//    } CompleterBlock:^(CNLiveShareResultType resultType, CNLiveSharePlatformType platformType, NSString *typtString) {
//
//    }];
    
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

@end
