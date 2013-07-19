//
//  MapAnnotationView.m
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-18.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import "MapAnnotationView.h"

#import "Constants.h"
#import "MapAnnotation.h"
#import "TweetTimePassed.h"

@implementation MapAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isHot = NO;
    }
    return self;
}

-(void)setAnnotation:(id<MKAnnotation>)annotation
{
    isHot = NO;

    NSString *tweetTime = [[(MapAnnotation *)annotation data] objectForKey:@"created_at"];
    
    TweetTimePassed *timePassed = [[TweetTimePassed alloc] initWithTweetTime:tweetTime];
    
    if( timePassed.hours == 0 && timePassed.days == 0 && timePassed.years == 0 ) {
        isHot = YES;
    }

    self.image = [UIImage imageNamed:isHot ? TWEET_PIN_HOT : TWEET_PIN];
    
    [timePassed release];
    timePassed = nil;
    
    [super setAnnotation:annotation];
}


-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    NSString *imgName;
    
    if( selected ) {
        imgName = isHot ? TWEET_PIN_HOT_SELECTED :TWEET_PIN_SELECTED;
    } else {
        imgName = isHot ? TWEET_PIN_HOT : TWEET_PIN;
    }
    
    self.image = [UIImage imageNamed:imgName];
    
    [super setSelected:selected animated:YES];
}


-(void)dealloc
{
    [super dealloc];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
