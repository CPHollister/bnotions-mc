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
    
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint p = self.frame.origin;
        CGSize s = self.frame.size;
        self.frame = CGRectMake( p.x, self.window.frame.size.height - viewHeight, s.width, viewHeight);
    } completion:^(BOOL finished){
        
    }];
}

- (void) close
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint p = self.frame.origin;
        CGSize s = self.frame.size;
        self.frame = CGRectMake( p.x, self.window.frame.size.height + viewHeight + 5, s.width, viewHeight);
    } completion:^(BOOL finished){
        self.tweetData = nil;
    }];
}


- (void) close:(NSString *)selector andTarget:(id)target andData:(NSDictionary *)data
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint p = self.frame.origin;
        CGSize s = self.frame.size;
        self.frame = CGRectMake( p.x, self.window.frame.size.height + viewHeight + 5, s.width, viewHeight);
    } completion:^(BOOL finished){

        self.tweetData = nil;
        [target performSelector:NSSelectorFromString(selector) withObject:data];
    }];
}

- (void) initLabels
{
    int profileFontSize;
    int userNameFontSize;
    int tweetFontSize;
    int timeSinceTweeFontSize;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        profileFontSize = 22;
        userNameFontSize = 18;
        tweetFontSize = 24;
        timeSinceTweeFontSize = 16;
        //return YES; /* Device is iPad */
    } else {
        profileFontSize = 16;
        userNameFontSize = 12;
        tweetFontSize = 17;
        timeSinceTweeFontSize = 10;
    }
    
    profileName = [[UILabel alloc] initWithFrame:CGRectMake( 55, 25, 220, 23)];
    profileName.backgroundColor = [UIColor clearColor];
    profileName.font = [UIFont fontWithName:FONT_HELVETICA_BOLD size:profileFontSize];
    profileName.textColor = [UIColor blackColor];
    profileName.textAlignment = UITextAlignmentLeft;
    profileName.numberOfLines = 1;

    [self addSubview:profileName];
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(profileName.frame.origin.x + profileName.frame.size.width + 10, profileName.frame.origin.y, 120, 20)];
    userName.backgroundColor = [UIColor clearColor];
    userName.font = [UIFont fontWithName:FONT_HELVETICA_LIGHT size:userNameFontSize];
    userName.textColor = [UIColor blackColor];
    userName.textAlignment = UITextAlignmentLeft;
    userName.numberOfLines = 1;
    
    [self addSubview:userName];
    
    
    tweet = [[UILabel alloc] initWithFrame:CGRectMake( 45, userName.frame.origin.y + 25, 100, 12)];
    tweet.backgroundColor = [UIColor clearColor];
    tweet.font = [UIFont fontWithName:FONT_HELVETICA_REG size:tweetFontSize];
    tweet.textColor = [UIColor blackColor];
    tweet.textAlignment = UITextAlignmentLeft;
    tweet.lineBreakMode = UILineBreakModeWordWrap;
    tweet.numberOfLines = 0;    
    [self addSubview:tweet];
    
    timeSinceTweet = [[UILabel alloc] initWithFrame:CGRectMake( self.frame.size.width - 120, 10, 268, 12)];
    timeSinceTweet.backgroundColor = [UIColor clearColor];
    timeSinceTweet.font = [UIFont fontWithName:FONT_HELVETICA_LIGHT size:timeSinceTweeFontSize];
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
    int padding = 10;
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        padding = 5;
    }
    
    profileImage = [[UIImageView alloc] initWithFrame:CGRectMake( padding, padding, 150, 150)];
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
    int profileNameXPad = 10;
    int profileNameYPad = -5;
    
    int userNameXPad = 5;
    int userNameYPad = 4;
    
    int tweetYPad = 7;
    
    int timeYPad = 8;
    int timeXPad = 10;
    
    if ( UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad )
    {
        profileNameXPad = 5;
        userNameYPad = 3;
        tweetYPad = 3;
        
        timeYPad = 3;
        timeXPad = 5;
    }
    
    if( profileImage ) {
        
    }
    
    if( profileName ) {
        [profileName sizeToFit];
        
        profileName.frame = CGRectMake(profileImage.frame.origin.x + profileImage.frame.size.width + profileNameXPad, profileImage.frame.origin.y + profileNameYPad, profileName.frame.size.width, profileName.frame.size.height);
    }
    
    if( userName ) {
        [userName sizeToFit];
        userName.frame = CGRectMake( profileName.frame.origin.x + profileName.frame.size.width + userNameXPad, profileName.frame.origin.y + userNameYPad, userName.frame.size.width, userName.frame.size.height);
    }
    
    
    if( tweet ) {
        [tweet sizeToFit];
        tweet.frame = CGRectMake( profileName.frame.origin.x, profileName.frame.size.height + tweetYPad, self.frame.size.width - profileName.frame.origin.x - profileNameXPad, tweet.frame.size.height);
    }
    
    if (timeSinceTweet) {
        [timeSinceTweet sizeToFit];
        timeSinceTweet.frame = CGRectMake( self.frame.size.width - timeSinceTweet.frame.size.width - timeXPad, tweet.frame.size.height + tweet.frame.origin.y, timeSinceTweet.frame.size.width, timeSinceTweet.frame.size.height );
    }
    
    [self determineHeight];
}


- (void) determineHeight
{
    int ypadding = UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad ? 21 : 15;
    
    int i = profileImage.frame.size.height + ypadding * 2;
    int ii = timeSinceTweet.frame.origin.y + timeSinceTweet.frame.size.height + ypadding;
    
    
    viewHeight = MAX( profileImage.frame.size.height + ypadding * 2, timeSinceTweet.frame.origin.y + timeSinceTweet.frame.size.height + ypadding);
    
    NSLog(@"to ride you must be this tall %d, %d, %d", viewHeight, i, ii);
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
