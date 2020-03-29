//
//  NSDate+Api.h
//  Kinofinder
//
//  Created by Artur Olszak on 31/03/16.
//  Copyright © 2016 bam! interactive marketing GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Api)

/**
 @brief Parse date in any format
 */
+ (NSDate *)dateFromString:(NSString *)dateString;

/** */
- (NSString *)timestampString;

/** */
- (NSUInteger)weekDayIndex;

/** */
- (NSDate *)addDays:(NSInteger)days;

/** */
- (NSDate *)dateWithoutTime;

/** */
- (NSDate*)dateWithHour:(NSUInteger)hour andMinute:(NSUInteger)minute;

/** */
- (NSInteger)numberOfDaysBetweenDate:(NSDate *)date;

/** */
- (NSUInteger)hour;

/** */
- (NSUInteger)minutes;

/** */
- (BOOL)isEqualToDateIgnoringTime:(NSDate*)date;

/** */
- (NSString *)timeString;

@end
