//
//  TweetInfoView.h
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-18.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TweetInfoView : UIView
{
    UIImageView *profileImage;
    
    UILabel *profileName;
    
    UILabel *userName;
    
    UILabel *tweet;
    
    UILabel *timeSinceTweet;
    
    int viewHeight;
}

@property (nonatomic, assign) NSDictionary *tweetData;


- (void) open:(NSDictionary *)data;
- (void) close;
- (void) close:(NSString *)selector andTarget:(id)target andData:(NSDictionary *)data;

- (void) determineHeight;

@end
