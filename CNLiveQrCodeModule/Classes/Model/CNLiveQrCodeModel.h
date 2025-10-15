//
//  CNLiveQrCodeModel.h
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CNLiveQrCodeCellType) {
    CNLiveQrCodeCellTypeOrder        = 0,
    CNLiveQrCodeCellTypeTool         = 1,
    CNLiveQrCodeCellTypeGoods        = 2,
    CNLiveQrCodeCellTypeSports       = 3
    
};

@interface CNLiveQrCodeModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;

@property (nonatomic, copy) NSString *style;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;

@property (nonatomic, assign) CNLiveQrCodeCellType type;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat margin;

@end

NS_ASSUME_NONNULL_END
