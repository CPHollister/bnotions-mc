//
//  TweetInfoView.m
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-18.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import "TweetInfoView.h"

@implementation TweetInfoView

@synthesize tweetData;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        // Initialization code
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
    profileName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
    profileName.textColor = [UIColor blackColor];
    profileName.textAlignment = UITextAlignmentLeft;
    profileName.numberOfLines = 1;

    [self addSubview:profileName];
    
    userName = [[UILabel alloc] initWithFrame:CGRectMake(profileName.frame.origin.x + profileName.frame.size.width + 10, profileName.frame.origin.y, 120, 20)];
    userName.backgroundColor = [UIColor clearColor];
    userName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    userName.textColor = [UIColor blackColor];
    userName.textAlignment = UITextAlignmentLeft;
    userName.numberOfLines = 1;
    
    [self addSubview:userName];
    
    
    tweet = [[UILabel alloc] initWithFrame:CGRectMake( 45, userName.frame.origin.y + 25, 268, 100)];
    tweet.backgroundColor = [UIColor clearColor];
    tweet.font = [UIFont fontWithName:@"HelveticaNeue-Regular" size:24];
    tweet.textColor = [UIColor blackColor];
    tweet.textAlignment = UITextAlignmentLeft;
    tweet.lineBreakMode = UILineBreakModeWordWrap;
    tweet.numberOfLines = 0;
    
    [self addSubview:tweet];    
}


- (void) populateLabels
{
    profileName.text = [[tweetData objectForKey:@"user"] objectForKey:@"name"];
    [profileName sizeToFit];
    
    userName.text = [NSString stringWithFormat:@"@%@",[[tweetData objectForKey:@"user"] objectForKey:@"name"]];
    [userName sizeToFit];
    
    tweet.text = [tweetData objectForKey:@"text"];
    [tweet sizeToFit];
    
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
        
        profileName.frame = CGRectMake(profileImage.frame.origin.x + profileImage.frame.size.width + 10, profileImage.frame.origin.y, profileName.frame.size.width, profileName.frame.size.height);
    }
    
    if( userName ) {
        [userName sizeToFit];
        userName.frame = CGRectMake( profileName.frame.origin.x + profileName.frame.size.width + 5, profileName.frame.origin.y + 5, userName.frame.size.width, userName.frame.size.height);
    }
    
    
    if( tweet ) {
        tweet.frame = CGRectMake( profileName.frame.origin.x, profileName.frame.size.height + 10, self.frame.size.width - profileName.frame.origin.x - 10, tweet.frame.size.height);
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
