//
//  CustomCollectionview.m
//  相册展示测试
//
//  Created by 孙昊 on 2016/12/12.
//  Copyright © 2016年 sitech. All rights reserved.
//

#import "CustomCollectionview.h"


@implementation CustomCollectionview

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pictureImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.pictureImg];
        
        
        self.pressImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-20, 0, 20, 20)];
        [self addSubview:self.pressImg];
        
    }
    return self;
}

@end
