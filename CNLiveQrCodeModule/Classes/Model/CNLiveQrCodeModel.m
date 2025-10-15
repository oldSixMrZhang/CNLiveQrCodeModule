//
//  CNLiveQrCodeModel.m
//  CNLiveQrCodeModule
//
//  Created by 153993236@qq.com on 11/12/2019.
//  Copyright © 2019 153993236@qq.com. All rights reserved.
//

#import "CNLiveQrCodeModel.h"

@implementation CNLiveQrCodeModel
static const NSInteger margin = 10;

- (CNLiveQrCodeCellType)type{
    if([self.style isEqualToString:@"1"]){
        return CNLiveQrCodeCellTypeOrder;
    }
    else if([self.style isEqualToString:@"2"]){
        return CNLiveQrCodeCellTypeTool;
        
    }
    else if([self.style isEqualToString:@"3"]){
        return CNLiveQrCodeCellTypeGoods;
        
    }
    else if([self.style isEqualToString:@"4"]){
        return CNLiveQrCodeCellTypeSports;
        
    }
    return CNLiveQrCodeCellTypeOrder;
}

- (CGFloat)height{
    CGFloat titleHeight = 50;
    CGFloat btnHeight = 60;

    //订单
    if(self.type == CNLiveQrCodeCellTypeOrder){
        return 2*margin+titleHeight+btnHeight+margin;
    }
    //工具
    else if(self.type == CNLiveQrCodeCellTypeTool){
        return 2*margin+titleHeight+ceilf(self.titles.count/4.0)*(btnHeight+margin);

    }
    //商品
    else if(self.type == CNLiveQrCodeCellTypeGoods){
        // 电票的高度  80
        return 2*margin+titleHeight+80+margin;
        
    }
    //大众体育
    else if(self.type == CNLiveQrCodeCellTypeSports){
        return 2*margin+titleHeight+ceilf(self.titles.count/4.0)*(btnHeight+margin);
        
    }
    return 0.0000001f;
}

@end
