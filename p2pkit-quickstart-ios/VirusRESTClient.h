//
//  VirusRESTClient.h
//  Virus Tracker
//
//  Created by admin on 29/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RESTToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface VirusRESTClient : NSObject

- (void)getInfectedTokenList:(void(^)(NSArray<RESTToken*> *tokenList))completion;

@end

NS_ASSUME_NONNULL_END
