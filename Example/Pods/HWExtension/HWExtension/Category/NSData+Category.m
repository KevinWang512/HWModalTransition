//
//  NSData+Category.m
//  HWExtension
//
//  Created by wanghouwen on 2017/12/14.
//  Copyright © 2017年 wanghouwen. All rights reserved.
//

#import "NSData+Category.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (Enumerator)

- (void)enumerateSubdataWithLength:(NSUInteger)length usingBlock:(void(^)(NSData *subdata, NSRange range, BOOL *stop))block {
    
    if (block && length > 0) {
        
        NSUInteger loc = 0;
        NSData *d_t = nil;
        
        do {
            @autoreleasepool {
                
                NSUInteger len = length;
                
                if (len > self.length - loc) {
                    len = self.length - loc;
                }
                
                d_t = [self subdataWithRange:NSMakeRange(loc, len)];
                
                BOOL stop = NO;
                block(d_t, NSMakeRange(loc, len), &stop);
                if (stop) break;
                
                loc += length;
                loc = MIN(loc, self.length);
            }
        } while (d_t && d_t.length);
    }
}

@end

@implementation NSData (CommonCrypto)

#ifdef TARGET_OS_IOS
#define HW_DEFAULT_BLOCK_BYTES (1024)
#else
#define HW_DEFAULT_BLOCK_BYTES (1024 * 5)
#endif

- (NSString *)md5String {
    
    __block CC_MD5_CTX md5Ctx;
    CC_MD5_Init(&md5Ctx);
    
    [self enumerateSubdataWithLength:HW_DEFAULT_BLOCK_BYTES usingBlock:^(NSData *subdata, NSRange range, BOOL *stop) {
        CC_MD5_Update(&md5Ctx, subdata.bytes, (CC_LONG)subdata.length);
    }];
    
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &md5Ctx);
    
    return [self stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)shaStringWithType:(HWSHAType)type {
    
    NSDictionary <NSNumber *, NSNumber *>*lengthMap = @{@(HWSHAType1) : @(CC_SHA1_DIGEST_LENGTH),
                                                        @(HWSHAType224) : @(CC_SHA224_DIGEST_LENGTH),
                                                        @(HWSHAType256) : @(CC_SHA256_DIGEST_LENGTH),
                                                        @(HWSHAType384) : @(CC_SHA384_DIGEST_LENGTH),
                                                        @(HWSHAType512) : @(CC_SHA512_DIGEST_LENGTH)};
    if ([lengthMap.allKeys containsObject:@(type)]) {
        
        int length = lengthMap[@(type)].intValue;
        uint8_t buffer[length];
        
        if (type == HWSHAType1) {
            
            __block CC_SHA1_CTX shaCtx;
            CC_SHA1_Init(&shaCtx);
            
            [self enumerateSubdataWithLength:HW_DEFAULT_BLOCK_BYTES usingBlock:^(NSData *subdata, NSRange range, BOOL *stop) {
                CC_SHA1_Update(&shaCtx, subdata.bytes, (CC_LONG)subdata.length);
            }];
            
            CC_SHA1_Final(buffer, &shaCtx);
            
        } else if (type == HWSHAType224) {
            
            __block CC_SHA256_CTX shaCtx;
            CC_SHA224_Init(&shaCtx);
            
            [self enumerateSubdataWithLength:HW_DEFAULT_BLOCK_BYTES usingBlock:^(NSData *subdata, NSRange range, BOOL *stop) {
                CC_SHA224_Update(&shaCtx, subdata.bytes, (CC_LONG)subdata.length);
            }];
            
            CC_SHA224_Final(buffer, &shaCtx);
            
        } else if (type == HWSHAType256) {
            
            __block CC_SHA256_CTX shaCtx;
            CC_SHA256_Init(&shaCtx);
            
            [self enumerateSubdataWithLength:HW_DEFAULT_BLOCK_BYTES usingBlock:^(NSData *subdata, NSRange range, BOOL *stop) {
                CC_SHA256_Update(&shaCtx, subdata.bytes, (CC_LONG)subdata.length);
            }];
            
            CC_SHA256_Final(buffer, &shaCtx);
            
        } else if (type == HWSHAType384) {
            
            __block CC_SHA512_CTX shaCtx;
            CC_SHA384_Init(&shaCtx);
            
            [self enumerateSubdataWithLength:HW_DEFAULT_BLOCK_BYTES usingBlock:^(NSData *subdata, NSRange range, BOOL *stop) {
                CC_SHA384_Update(&shaCtx, subdata.bytes, (CC_LONG)subdata.length);
            }];
            
            CC_SHA384_Final(buffer, &shaCtx);
            
        } else if (type == HWSHAType512) {
            
            __block CC_SHA512_CTX shaCtx;
            CC_SHA512_Init(&shaCtx);
            
            [self enumerateSubdataWithLength:HW_DEFAULT_BLOCK_BYTES usingBlock:^(NSData *subdata, NSRange range, BOOL *stop) {
                CC_SHA512_Update(&shaCtx, subdata.bytes, (CC_LONG)subdata.length);
            }];
            
            CC_SHA512_Final(buffer, &shaCtx);
            
        }
        
        return [self stringFromBytes:buffer length:length];
    }
    
    return nil;
}

#pragma mark - private

- (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    return [strM copy];
}

@end
