//
//  NSDate+Api.m
//  Kinofinder
//
//  Created by Artur Olszak on 31/03/16.
//  Copyright © 2016 bam! interactive marketing GmbH. All rights reserved.
//

#import "NSDate+Api.h"

@implementation NSDate (Api)

+ (NSDate *)dateFromString:(NSString*)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    if (!date) {
        formatter.dateFormat = @"dd.MM.yyyy";
        date = [formatter dateFromString:dateString];
    }
    if (!date) {
        formatter.dateFormat = @"yyyy-MM-dd";
        date = [formatter dateFromString:dateString];
    }
    return date;
}

- (NSString *)timestampString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [formatter stringFromDate:self];
    return dateString;
}

- (NSUInteger)weekDayIndex {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:self];
    long weekday = [comps weekday];
    return weekday;
}

- (NSDate *)addDays:(NSInteger)days {
    NSDateComponents *components= [[NSDateComponents alloc] init];
    [components setDay:days];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSInteger)numberOfDaysBetweenDate:(NSDate *)date {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:date options:0];
    return [components day];
}

- (NSDate *)dateWithoutTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:self];
    
    return [formatter dateFromString:dateString];
}

- (NSDate *)dateWithHour:(NSUInteger)hour andMinute:(NSUInteger)minute {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:0];
    return [calendar dateFromComponents:components];
}

- (NSUInteger)hour {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:self];
    return components.hour;
}

- (NSUInteger)minutes {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:self];
    return components.minute;
}

- (BOOL)isEqualToDateIgnoringTime:(NSDate*)date {
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSString *dateString = [formatter stringFromDate:self];
    return dateString;
}

@end
