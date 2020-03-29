//
//  RESTToken.h
//  Virus Tracker
//
//  Created by admin on 29/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Custom HTTP Response status enumeration
 */
typedef NS_ENUM(NSUInteger, RESTTokenVerificationType) {
    RESTTokenVerificationTypeSelfReport,
    RESTTokenVerificationTypeVerifiedByInstitution
};

@interface RESTToken : NSObject

@property RESTTokenVerificationType type;
@property NSString *value;

@end

NS_ASSUME_NONNULL_END
