//
//  CNLiveMyQrCodeView.h
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CNLiveQrCodeType){
    CNLiveQrCodeTypeDefualt = 0,    //默认生成个人二维码
    CNLiveQrCodeTypeOrder,          //生成订单二维码
};

@interface CNLiveMyQrCodeView : UIView
@property (nonatomic, strong) NSString *text;

- (void)generateQRCode:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
