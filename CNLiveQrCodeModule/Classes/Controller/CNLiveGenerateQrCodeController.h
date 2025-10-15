//
//  CNLiveGenerateQrCodeController.h
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

/**
 * 生成二维码
 */

#import <UIKit/UIKit.h>
#import "CNCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveGenerateQrCodeController : CNCommonViewController

// ID 生成二维码的信息
@property (nonatomic, copy) NSString *ID;

@end

NS_ASSUME_NONNULL_END
