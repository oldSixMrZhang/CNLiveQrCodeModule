//
//  CNLiveScanResultController.h
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright (c) 2019 153993236@qq.com. All rights reserved.
//

/**
 * 扫码结果
 */

#import <UIKit/UIKit.h>
#import "CNCommonViewController.h"

@interface CNLiveScanResultController : CNCommonViewController
/** 是否返回到Root */
@property (nonatomic, assign) BOOL isPopToRoot;
@property (nonatomic, copy) NSString *jump_URL;

@end
