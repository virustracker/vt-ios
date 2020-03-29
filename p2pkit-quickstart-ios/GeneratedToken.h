//
//  GeneratedToken.h
//  Virus Tracker
//
//  Created by admin on 28/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GeneratedToken : RLMObject

@property NSDate *date;
@property NSString *token;
@property NSString *preimage;
@property NSNumber<RLMBool> *isInfected;

@end

NS_ASSUME_NONNULL_END
