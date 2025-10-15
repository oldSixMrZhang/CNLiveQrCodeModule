//
//  CNLiveQrCodeService.m
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveQrCodeService.h"
#import "CNLiveServices.h"

#import "CNLiveManager.h"

// 扫一扫
#import "CNLiveScanQrCodeController.h"
// 我的二维码
#import "CNLiveMyQrCodeController.h"
// 群二维码名片
#import "CNLiveGroupQrCodeController.h"
// 生成二维码
#import "CNLiveGenerateQrCodeController.h"

@BeeHiveService(CNLiveQrCodeServiceProtocol,CNLiveQrCodeService)
@interface CNLiveQrCodeService ()<CNLiveQrCodeServiceProtocol>

@end

@implementation CNLiveQrCodeService

// 扫一扫
- (UIViewController *)getScanQrCodeController {
    return [CNLiveScanQrCodeController new];
}

- (void)pushToScanQrCodeController:(BOOL)isMyCode {
    CNLiveScanQrCodeController *vc = [[CNLiveScanQrCodeController alloc]init];
    vc.isMyCode = isMyCode;
    [CNLivePageJumpManager jumpViewController:vc];
}

// 我的二维码
- (UIViewController *)getMyQrCodeController {
    return [CNLiveMyQrCodeController new];
}

- (void)pushToMyQrCodeController:(BOOL)isScanCode {
    CNLiveMyQrCodeController *vc = [[CNLiveMyQrCodeController alloc]init];
    vc.isScanCode = isScanCode;
    [CNLivePageJumpManager jumpViewController:vc];
}

// 群组二维码
- (UIViewController *)getGroupQrCodeController {
    return [CNLiveGroupQrCodeController new];
}

- (void)pushToGroupQrCodeController {
    CNLiveGroupQrCodeController *vc = [[CNLiveGroupQrCodeController alloc]init];
    [CNLivePageJumpManager jumpViewController:vc];
}

// 生成二维码
- (UIViewController *)getGenerateQrCodeController {
    return [CNLiveGenerateQrCodeController new];
}

- (void)pushToGenerateQrCodeController:(NSString *)ID {
    CNLiveGenerateQrCodeController *vc = [[CNLiveGenerateQrCodeController alloc]init];
    vc.ID = ID;
    [CNLivePageJumpManager jumpViewController:vc];
}

@end
