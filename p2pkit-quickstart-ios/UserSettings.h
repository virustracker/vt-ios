//
//  UserSettings.h
//  Virus Tracker
//
//  Created by admin on 30/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserSettings : RLMObject

@property bool shouldSyncData;
@property bool didFinishOnboarding;
@property bool isMarkedAsInfected;

- (NSDictionary *)getDictionary;
- (void)setWith:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
