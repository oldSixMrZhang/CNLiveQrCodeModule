//
//  CNLiveGroupQrCodeController.h
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

/**
 * 群组二维码
 */

#import <UIKit/UIKit.h>
#import "CNCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class IMAGroup;

@interface CNLiveGroupQrCodeController : CNCommonViewController
@property (nonatomic, strong) IMAGroup *group;

@end

NS_ASSUME_NONNULL_END
