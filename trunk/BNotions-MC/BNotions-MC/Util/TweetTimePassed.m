//
//  TweetTimePassed.m
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-19.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import "TweetTimePassed.h"

@implementation TweetTimePassed

@synthesize years, days, hours, minutes, seconds;

- (id) initWithTweetTime:(NSString *)tweetTime
{
    if( self = [super init] ) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"EEE MMM d HH:mm:ss zzz yyyy"];
        NSDate *tweetDate = [dateFormat dateFromString:tweetTime];
        [dateFormat release];
        
        NSDate *date = [NSDate date];

        NSCalendar *c = [NSCalendar currentCalendar];
        NSDateComponents* components = [c components:(NSYearCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:tweetDate toDate:date options:0] ;
        
        years = components.year;
        days = components.day;
        hours = components.hour;
        minutes = components.minute;
        seconds = components.second;
    }
    
    return self;
}


- (NSString *) timeAsString
{
    NSMutableString *str = [[NSMutableString alloc] init];

    if( years > 0 ) {
        NSString *yearString = years == 1 ? @"year" : @"years";
        [str appendFormat:@"%d %@", years, yearString];
    }

    if( days > 0 && years < 1) {
        [str appendFormat:@"%dd", days];
    }
    
    if( hours > 0 && days < 1) {
        [str appendFormat:@"%dh", hours];
    }
    
    if( minutes > 0 && hours < 1 ) {
        [str appendFormat:@"%dm", minutes];
    }
    
    if (minutes < 10 && hours < 1 ) {
        [str appendFormat:@"%ds", seconds];
    }
    
    return [str autorelease];
}

- (void) dealloc
{
    [super dealloc];
}

@end
