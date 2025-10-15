//
//  CNLiveMyQrCodeView.m
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveMyQrCodeView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "QMUIKit.h"
#import "SGQRCode.h"//二维码库

#import "CNUserInfoManager.h"
#import "CNLiveCategory.h"

#import "CNLiveNetworking.h"
#import "CNLiveEnvironment.h"

@interface CNLiveMyQrCodeView ()
@property (nonatomic, strong) UIImageView *header;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UIButton *reset;

@property (nonatomic, strong) UIImageView *qrCode;

@property (nonatomic, strong) UILabel *friends;

@end

@implementation CNLiveMyQrCodeView
static const NSInteger margin = 20;
static const CGFloat timeValue = 1.5;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        // 生成二维码
        [self generateQRCode:@"gen"];
        [self createSubViews];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"CNLiveMyQrCodeView -- dealloc");
    
}

- (void)createSubViews {
    [self addSubview:self.header];
    [self addSubview:self.reset];

    [self addSubview:self.name];
    [self addSubview:self.address];
    
    [self addSubview:self.qrCode];
    [self addSubview:self.friends];
    
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(margin);
        make.top.equalTo(self.mas_top).with.offset(margin);
        make.width.height.offset(60);

    }];
    
    [_reset mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(self.header.mas_centerY).with.offset(0);
         make.right.equalTo(self.mas_right).with.offset(-margin);
         make.width.height.offset(35);
         
     }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_top);
        make.left.equalTo(self.header.mas_right).with.offset(margin/2.0);
        make.right.equalTo(self.reset.mas_left).with.offset(0);
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
    
    [_friends mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.qrCode.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0);
        
    }];

}

- (void)setText:(NSString *)text{
    _text = text;
    _friends.text = text;
}

// 重置二维码
- (void)generateQRCode:(NSString *)type{
    NSDictionary *params = @{
                                @"appId":AppId,
                                @"sid":CNUserShareModel.uid,
                                @"type":type
                                };
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [QMUITips showLoadingInView:self];
    __weak typeof(self) weakSelf = self;

    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:CNGenOrResetCodeUrl Param:params CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) return;
        [QMUITips hideAllToastInView:strongSelf animated:YES];
        if(!error&&[responseObject isKindOfClass:[NSDictionary class]]){
            //对content 先加密 再转为 json 字符串
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSDictionary *jsonDic = @{@"content":[NSString base64StringFromText:dic[@"data"][@"qrcode"] encryptKey:AppDESKey],@"type":@"user"};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            UIImage *xw_image = [self getImageWithImageName:@"qr_code_icon" bundleName:@"CNLiveQrCodeModule" targetClass:[CNLiveMyQrCodeView class]];
            
            UIImage *image = [SGQRCodeObtain generateQRCodeWithData:jsonStr size:SCREEN_WIDTH-12*margin logoImage:xw_image ratio:0.2];
            strongSelf.qrCode.image = image;
            [[SDImageCache sharedImageCache] storeImage:image forKey:CNUserShareModel.uid toDisk:YES completion:NULL];
            
            if([type isEqualToString:@"reset"]){
                [QMUITips showSucceed:@"重置成功" inView:strongSelf hideAfterDelay:timeValue];
            }

        }else{
            if([type isEqualToString:@"reset"]){
                [QMUITips showError:@"重置失败" inView:strongSelf hideAfterDelay:timeValue];
            }

        }
    }];
    
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
#pragma mark - 响应方法
- (void)resetDidClicked:(UIButton *)btn{
    [self generateQRCode:@"reset"];
    
}

#pragma mark - 懒加载
- (UIImageView *)header {
    if (!_header) {
        _header = [[UIImageView alloc] init];
        _header.layer.masksToBounds = YES;
        _header.layer.cornerRadius = 5;
        UIImage *image = [self getImageWithImageName:@"default_avatar_f" bundleName:@"CNLiveQrCodeModule" targetClass:[self class]];
        [_header sd_setImageWithURL:[NSURL URLWithString:CNUserShareModel.faceUrl] placeholderImage:image];
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
- (UIButton *)reset{
    if(!_reset){
        _reset = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *xw_image = [self getImageWithImageName:@"code_reset" bundleName:@"CNLiveQrCodeModule" targetClass:[self class]];
        [_reset setImage:xw_image forState:UIControlStateNormal];
        [_reset addTarget:self action:@selector(resetDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reset;
    
}
- (UIImageView *)qrCode {
    if (!_qrCode) {
        _qrCode = [[UIImageView alloc] init];
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:CNUserShareModel.uid];
        [_qrCode sd_setImageWithURL:nil placeholderImage:image];
        _qrCode.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:CNUserShareModel.uid];

    }
    return _qrCode;
}
- (UILabel *)friends {
    if (!_friends) {
        _friends = [[UILabel alloc] init];
        _friends.numberOfLines = 1;
        _friends.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _friends.font = [UIFont systemFontOfSize:16];
        _friends.textAlignment = NSTextAlignmentCenter;
        _friends.text = @"扫描二维码,加我好友";
    }
    return _friends;
}

@end
