//
//  CryptoHelper.m
//  Virus Tracker
//
//  Created by admin on 28/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import "CryptoHelper.h"

@implementation CryptoHelper

+ (NSString *)getSha256:(NSString *)string {
    const char *s=[string cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

@end
