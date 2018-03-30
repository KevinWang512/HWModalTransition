//
//  UIImageView+Category.m
//  HWExtension
//
//  Created by houwen.wang on 2016/11/10.
//  Copyright © 2016年 houwen.wang. All rights reserved.
//

#import "UIImageView+Category.h"

@implementation UIImage (Aspect)

- (CGSize)aspectScaleToFitSize:(CGSize)size {
    
    CGSize fitedSize = CGSizeMake(size.width, size.height);
    
    if (self.size.width != 0.0f && self.size.height != 0.0f && size.height != 0.0f) {
        
        CGFloat widthHightRatio = self.size.width / self.size.height;
        
        if (size.width / size.height > widthHightRatio) {
            fitedSize.width = size.height * widthHightRatio;
            fitedSize.height = size.height;
        } else {
            fitedSize.width = size.width;
            fitedSize.height = size.width / widthHightRatio;
        }
    }
    return fitedSize;
}

@end

@implementation UIImageView (Category)

- (CGSize)aspectScaleToFitSize:(CGSize)size {
    if (self.image) {
        return [self.image aspectScaleToFitSize:size];
    }
    return size;
}

@end
