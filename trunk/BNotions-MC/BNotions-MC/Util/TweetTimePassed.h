//
//  TweetTimePassed.h
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-19.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetTimePassed : NSObject {
    
}

@property(nonatomic, assign) int years;
@property(nonatomic, assign) int days;
@property(nonatomic, assign) int hours;
@property(nonatomic, assign) int minutes;
@property(nonatomic, assign) int seconds;


- (id) initWithTweetTime:(NSString *)tweetTime;

- (NSString *) timeAsString;

@end
