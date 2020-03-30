//
//  ProximityEvent.h
//  Virus Tracker
//
//  Created by admin on 29/03/2020.
//  Copyright © 2020 Uepaa AG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProximityEvent : RLMObject

@property int distanceType;
@property long timestampMs;
@property long durationMs;
@property int infectionState;
@property BOOL isConfidential;

- (NSDictionary *)getDictionary;

@end

NS_ASSUME_NONNULL_END
