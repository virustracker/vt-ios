//
//  CryptoHelper.h
//  Virus Tracker
//
//  Created by admin on 28/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

@interface CryptoHelper : NSObject

+ (NSString *)getSha256:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
