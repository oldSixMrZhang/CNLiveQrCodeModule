//
//  CNLiveGroupQrCodeView.m
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveGroupQrCodeView.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>
#import "QMUIKit.h"
#import "SGQRCode.h"//二维码库
#import "MJExtension.h"

#import "CNUserInfoManager.h"
#import "CNLiveCategory.h"

// IM
#import "TIMAdapter.h"
#import "CommonLibrary.h"

@interface CNLiveGroupQrCodeView()
@property (nonatomic, strong) UIImageView *groupHead;
@property (nonatomic, strong) UILabel *groupName;
@property (nonatomic, strong) UIImageView *qrCode;
@property (nonatomic, strong) UILabel *desc;

@end
@implementation CNLiveGroupQrCodeView
static const NSInteger margin = 15;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

#pragma mark - UI
- (void)createUI{
    [self addSubview:self.groupHead];
    [self.groupHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).mas_offset(margin);
        make.top.mas_equalTo(self).mas_offset(margin);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(36);
    }];
    
    [self addSubview:self.groupName];
    [self.groupName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.groupHead.mas_right).mas_offset(margin);
        make.right.mas_equalTo(self.mas_right).mas_offset(-margin);
        make.top.mas_equalTo(self.groupHead.mas_top);
        make.height.mas_equalTo(self.groupHead.mas_height);

    }];
    
    [self addSubview:self.qrCode];
    [self.qrCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.groupName.mas_bottom).mas_offset(margin);
        make.width.mas_equalTo(220.0);
        make.height.mas_equalTo(220.0);
    }];
    
    [self addSubview:self.desc];
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(margin);
        make.right.mas_equalTo(self.mas_right).mas_offset(-margin);
        make.top.mas_equalTo(self.qrCode.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);

   }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Setter
- (void)setGroup:(IMAGroup *)group{
    _group = group;
    if(group.avatorIcon){
        _groupHead.image = group.avatorIcon;
        
    }else{
//        [_groupHead setImageWithGroupId:group.groupInfo.groupId];

    }
    _groupName.text = group.groupInfo.groupName;

    NSString *groupId = CNLiveStringIsEmpty(group.groupInfo.groupId)?@"":group.groupInfo.groupId;
    NSString *wjjQr = [NSString base64StringFromText:[@{@"content":[@{@"groupId":groupId,@"groupName":@"group.groupInfo.groupName"} mj_JSONString],@"type":@"groupQrType"} mj_JSONString] encryptKey:@"cnliveIm"];
    NSString *jsonStr = [NSString stringWithFormat:@"%@wjjQrSkipType=wjjQrPublicGroupType&isWjjQr=%@",@"shareUrl",wjjQr];
    UIImage *xw_image = [self getImageWithImageName:@"qr_code_icon" bundleName:@"CNLiveQrCodeModule" targetClass:[self class]];
    UIImage *image = [SGQRCodeObtain generateQRCodeWithData:jsonStr size:220.0 logoImage:xw_image ratio:0.2];

    _qrCode.image = image;
    [[SDImageCache sharedImageCache] storeImage:image forKey:groupId toDisk:YES completion:NULL];
    
}

#pragma mark - Getter
- (UIImageView *)groupHead {
    if (!_groupHead) {
        _groupHead = [[UIImageView alloc] init];
        _groupHead.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        UIImage *image = [self getImageWithImageName:@"default_avatar_f" bundleName:@"CNLiveQrCodeModule" targetClass:[self class]];
        _groupHead.image = image;
    }
    return _groupHead;
}

- (UILabel *)groupName {
    if (!_groupName) {
        _groupName = [[UILabel alloc] init];
        _groupName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _groupName.font = UIFontMake(15);
        _groupName.numberOfLines = 1;
        _groupName.text = @"";
    }
    return _groupName;
}

- (UIImageView *)qrCode {
    if (!_qrCode) {
        _qrCode = [[UIImageView alloc] init];
        _qrCode.backgroundColor = [UIColor greenColor];
        NSString *groupId = CNLiveStringIsEmpty(self.group.groupInfo.groupId)?@"":self.group.groupInfo.groupId;
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:groupId];
        _qrCode.image = image;
    }
    return _qrCode;
}

- (UILabel *)desc {
    if (!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        _desc.font = UIFontMake(15);
        _desc.numberOfLines = 0;
        _desc.lineBreakMode = NSLineBreakByWordWrapping;
        _desc.textAlignment = NSTextAlignmentLeft;
        _desc.text = @">>保存到手机:用户有网家家客户端前提下,可以直接识别二维码进群聊天\n\n>>分享二维码:用户需先点击识别二维 码下载网家家客户端后,在已登录状态下,直接进入申请加群界面,点击“申请加群”按钮,进群聊天";
    }
    return _desc;
}

@end
