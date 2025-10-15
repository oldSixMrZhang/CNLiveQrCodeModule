//
//  CNLiveGenerateCodeView.m
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveGenerateCodeView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "QMUIKit.h"
#import "SGQRCode.h"//二维码库

#import "CNUserInfoManager.h"
#import "CNLiveCategory.h"

#import "CNLiveNetworking.h"
#import "CNLiveEnvironment.h"

@interface CNLiveGenerateCodeView ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UIImageView *qrCode;
@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) UILabel *desc;

@end

@implementation CNLiveGenerateCodeView
static const NSInteger margin = 20;
- (instancetype)initWithID:(NSString *)ID{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        // 生成二维码
        [self createSubViews];
        [self generateQRCode:ID];
    }
    return self;
    
}

- (void)createSubViews {
    [self addSubview:self.header];
    [self addSubview:self.name];
    [self addSubview:self.address];
    [self addSubview:self.qrCode];
    [self addSubview:self.desc];
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(margin);
        make.top.equalTo(self.mas_top).with.offset(margin);
        make.width.height.offset(60);

    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_top);
        make.left.equalTo(self.header.mas_right).with.offset(margin/2.0);
        make.right.equalTo(self.mas_right).with.offset(-margin);
        make.height.offset(30);
        
    }];
    
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom);
        make.left.equalTo(self.name.mas_left);
        make.right.equalTo(self.name.mas_right);
        make.height.equalTo(self.name.mas_height);
        
    }];

    [_qrCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.top.equalTo(self.header.mas_bottom).with.offset(margin);
        make.width.height.equalTo(self.mas_width).with.offset(-6*margin);
        
    }];
    
    [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.qrCode.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0);
        
    }];

}

- (void)generateQRCode:(NSString *)ID{
    NSDictionary *jsonDic = @{@"content":[NSString base64StringFromText:ID?ID:@"" encryptKey:AppDESKey],@"type":@"orderCode"};
              
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
           
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
           
    UIImage *xw_image = [self getImageWithImageName:@"qr_code_icon" bundleName:@"CNLiveQrCodeModule" targetClass:[self class]];
    [self.qrCode sd_setImageWithURL:nil placeholderImage:[SGQRCodeObtain generateQRCodeWithData:jsonStr size:SCREEN_WIDTH-12*margin logoImage:xw_image ratio:0.2]];
    
}

// 字典转json字符串
- (NSString *)dictionaryToJsonString:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
#pragma mark - 懒加载
- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc] init];
        _header.layer.masksToBounds = YES;
        _header.layer.cornerRadius = 5;
        UIImage *xw_image = [self getImageWithImageName:@"default_avatar_f" bundleName:@"CNLiveQrCodeModule" targetClass:[self class]];
        [_header sd_setImageWithURL:[NSURL URLWithString:CNUserShareModel.faceUrl] placeholderImage:xw_image];
    }
    return _header;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.numberOfLines = 1;
        _name.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _name.font = [UIFont systemFontOfSize:16];
        _name.text = CNUserShareModel.nickname;
    }
    return _name;
}
- (UILabel *)address {
    if (!_address) {
        _address = [[UILabel alloc] init];
        _address.numberOfLines = 1;
        _address.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _address.font = [UIFont systemFontOfSize:14];
        _address.text = CNUserShareModel.location;
    }
    return _address;
}
- (UIImageView *)qrCode {
    if (!_qrCode) {
        _qrCode = [[UIImageView alloc] init];
    }
    return _qrCode;
}
- (UILabel *)desc {
    if (!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.numberOfLines = 1;
        _desc.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _desc.font = [UIFont systemFontOfSize:16];
        _desc.textAlignment = NSTextAlignmentCenter;
        _desc.text = @"扫描二维码,完成确认订单";
    }
    return _desc;
}

@end
