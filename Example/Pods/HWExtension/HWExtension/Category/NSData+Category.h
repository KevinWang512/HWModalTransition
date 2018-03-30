//
//  NSData+Category.h
//  HWExtension
//
//  Created by wanghouwen on 2017/12/14.
//  Copyright © 2017年 wanghouwen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HWSHAType) {
    HWSHAType1 = 1,
    HWSHAType224,
    HWSHAType256,
    HWSHAType384,
    HWSHAType512
};

@interface NSData (Enumerator)

- (void)enumerateSubdataWithLength:(NSUInteger)length usingBlock:(void(^)(NSData *subdata, NSRange range, BOOL *stop))block;

@end

@interface NSData (CommonCrypto)

@property (nonatomic, copy, readonly) NSString *md5String;    //
- (NSString *)shaStringWithType:(HWSHAType)type;              //

@end
