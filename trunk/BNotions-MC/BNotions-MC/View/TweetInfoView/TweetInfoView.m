//
//  TweetInfoView.m
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-18.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import "TweetInfoView.h"

#import "Constants.h"
#import "TweetTimePassed.h"

@implementation TweetInfoView

@synthesize tweetData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        [self initLabels];
        [self initProfileImage];
        
    }
    return self;
}



- (void) open:(NSDictionary *)data
{
    self.tweetData = data;
    [self populateLabels];
    [self loadProfileImage];
}

- (void) close
{
    self.tweetData = nil;
}

- (void) initLabels
{
    profileName = [[UILabel alloc] initWithFrame:CGRectMake( 55, 25, 220, 23)];
    profileName.backgroundColor = [UIColor clearColor];
    profileName.font = [UIFont fontWithName:FONT_HELVETICA_BOLD size:22];
    profileName.textColor = [UIColor blackColor];
    profileName.textAlignment = UITextAlignmentLeft;
    profileName.numberOfLines = 1;

    [self addSubview:profileName];
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(profileName.frame.origin.x + profileName.frame.size.width + 10, profileName.frame.origin.y, 120, 20)];
    userName.backgroundColor = [UIColor clearColor];
    userName.font = [UIFont fontWithName:FONT_HELVETICA_LIGHT size:18];
    userName.textColor = [UIColor blackColor];
    userName.textAlignment = UITextAlignmentLeft;
    userName.numberOfLines = 1;
    
    [self addSubview:userName];
    
    
    tweet = [[UILabel alloc] initWithFrame:CGRectMake( 45, userName.frame.origin.y + 25, 268, 100)];
    tweet.backgroundColor = [UIColor clearColor];
    tweet.font = [UIFont fontWithName:FONT_HELVETICA_REG size:24];
    tweet.textColor = [UIColor blackColor];
    tweet.textAlignment = UITextAlignmentLeft;
    tweet.lineBreakMode = UILineBreakModeWordWrap;
    tweet.numberOfLines = 0;
    
    [self addSubview:tweet];
    
    timeSinceTweet = [[UILabel alloc] initWithFrame:CGRectMake( self.frame.size.width - 120, tweet.frame.origin.y + tweet.frame.size.height + 4, 268, 19)];
    timeSinceTweet.backgroundColor = [UIColor clearColor];
    timeSinceTweet.font = [UIFont fontWithName:FONT_HELVETICA_LIGHT size:16];
    timeSinceTweet.textColor = [UIColor blackColor];
    timeSinceTweet.textAlignment = UITextAlignmentLeft;
    timeSinceTweet.numberOfLines = 1;
    
    [self addSubview:timeSinceTweet];
}


- (void) populateLabels
{
    profileName.text = [[tweetData objectForKey:@"user"] objectForKey:@"name"];
    [profileName sizeToFit];
    
    userName.text = [NSString stringWithFormat:@"@%@",[[tweetData objectForKey:@"user"] objectForKey:@"name"]];
    [userName sizeToFit];
    
    tweet.text = [tweetData objectForKey:@"text"];
    [tweet sizeToFit];
    
    TweetTimePassed *timePassed = [[TweetTimePassed alloc] initWithTweetTime:[tweetData objectForKey:@"created_at"]];
    
    timeSinceTweet.text = [timePassed timeAsString];
    [timeSinceTweet sizeToFit];
    
    [self layoutSubviews];
}


- (void) initProfileImage
{
    profileImage = [[UIImageView alloc] initWithFrame:CGRectMake( 10, 10, 150, 150)];
    profileImage.layer.cornerRadius = 5;
    profileImage.clipsToBounds = YES;
    
    [self addSubview:profileImage];
}


- (void) loadProfileImage
{
    NSURL *url = [NSURL URLWithString:[[tweetData objectForKey:@"user"] objectForKey:@"profile_image_url"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    CGSize size = img.size;
    
    [profileImage setImage:img];
    CGPoint p = profileImage.frame.origin;
    
    profileImage.frame = CGRectMake(p.x, p.y, size.width, size.height);
}


- (void) layoutSubviews
{
    if( profileImage ) {
        
    }
    
    if( profileName ) {
        [profileName sizeToFit];
        
        profileName.frame = CGRectMake(profileImage.frame.origin.x + profileImage.frame.size.width + 11, profileImage.frame.origin.y- 5, profileName.frame.size.width, profileName.frame.size.height);
    }
    
    if( userName ) {
        [userName sizeToFit];
        userName.frame = CGRectMake( profileName.frame.origin.x + profileName.frame.size.width + 5, profileName.frame.origin.y + 4, userName.frame.size.width, userName.frame.size.height);
    }
    
    
    if( tweet ) {
        tweet.frame = CGRectMake( profileName.frame.origin.x, profileName.frame.size.height + 7, self.frame.size.width - profileName.frame.origin.x - 10, tweet.frame.size.height);
    }
    
    if (timeSinceTweet) {
        timeSinceTweet.frame = CGRectMake( self.frame.size.width - timeSinceTweet.frame.size.width - 10, self.frame.size.height - timeSinceTweet.frame.size.height - 8, timeSinceTweet.frame.size.width, 19);
    }
}


- (void) dealloc
{
    [profileImage release];
    profileImage = nil;
    
    [profileName release];
    profileName = nil;
    
    [userName release];
    userName = nil;
    
    [tweet release];
    tweet = nil;
    
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
