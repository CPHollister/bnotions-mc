//
//  Shell.m
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-15.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import "Shell.h"

#import "Constants.h"
#import "FHSTwitterEngine.h"
#import "MapView.h"
#import "SearchView.h"
#import "TweetInfoView.h"

#define TWEET_INFO_VIEW_FRAME_OPEN CGRectMake(0, self.frame.size.height - 90, self.frame.size.width, 90)
#define TWEET_INFO_VIEW_FRAME_CLOSE CGRectMake(0,self.frame.size.height + 5, self.frame.size.width, 90)

#define TWEET_INFO_VIEW_FRAME_IPHONE_OPEN CGRectMake(0, self.frame.size.height - 190, self.frame.size.width, 190)
#define TWEET_INFO_VIEW_FRAME_IPHONE_CLOSE CGRectMake(0,self.frame.size.height + 5, self.frame.size.width, 190)

#define SEARCH_VIEW_FRAME_OPEN CGRectMake((self.frame.size.width - searchView.frame.size.width) / 2, searchView.frame.origin.y, searchView.frame.size.width, searchView.frame.size.height);
#define SEARCH_VIEW_FRAME_CLOSE CGRectMake(-257, 10, 307, 50)

@implementation Shell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code
        [self initMapView];
        [self initSearchView];
        [self initTweetInfoView];
        [self initShellGestures];
    }
    
    return self;
}


- (void) onTwitterLoginSuccess
{
    [self openSearchView];
}


#pragma mark - MapView Methods
- (void) initMapView
{
    mapView = [[MapView alloc] initWithFrame:self.frame];
    mapView.delegate = self;
    
    [self addSubview:mapView];
}


#pragma mark - SearchView Methods
- (void) initSearchView
{
    searchView = [[SearchView alloc] initWithFrame:SEARCH_VIEW_FRAME_CLOSE];
    searchView.delegate = self;
    
    [self addSubview:searchView];
    
    searchViewIsOpen = NO;
}

- (void) openSearchView
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        searchView.frame = SEARCH_VIEW_FRAME_OPEN;
    } completion:^(BOOL finished){
        searchViewIsOpen = YES;
        
        swipeForSearch.direction = UISwipeGestureRecognizerDirectionLeft;
    }];
}

- (void) closeSearchView
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        searchView.frame = SEARCH_VIEW_FRAME_CLOSE;
    } completion:^(BOOL finished){
        searchViewIsOpen = NO;
        swipeForSearch.direction = UISwipeGestureRecognizerDirectionRight;
        
        mapView.searchValue = [searchView searchValue];
    }];
}


- (void) readyToCloseSearchView
{
    [self closeSearchView];
}


#pragma mark - TweetInfoView Methods
- (void) initTweetInfoView
{
    tweetInfoView = [[TweetInfoView alloc] initWithFrame:TWEET_INFO_VIEW_FRAME_CLOSE];
    
    [self addSubview:tweetInfoView];
}


- (void) openTweetInfoView:(NSDictionary *)data
{
    [tweetInfoView open:data];
}


- (void) closeTweetInfoView:(BOOL)open andData:(NSDictionary *)data
{
    if( open && data) {
        [tweetInfoView close:@"openTweetInfoView:" andTarget:self andData:data];
    } else {
        [tweetInfoView close];
    }
}


#pragma mark - Gesture Recognizers
- (void) initShellGestures
{
    swipeForSearch = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeForSearch:)];
    swipeForSearch.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:swipeForSearch];
}

- (void) onSwipeForSearch:(UIGestureRecognizer *)sender
{
    if( !searchViewIsOpen ) {
        [self openSearchView];
    } else {
        [self closeSearchView];
    }
}


#pragma mark - MapView Delegate Methods

- (void) mapAnnotationViewSelected:(NSDictionary *)data
{
    if( tweetInfoView.tweetData != nil ) {
        [self closeTweetInfoView:YES andData:data];
    } else {
        [self openTweetInfoView:data];
    }
}


- (void) mapAnnotationViewDeselected
{
    [self closeTweetInfoView:NO andData:nil];
}


#pragma mark - SearchView Delegate Methods


- (void) dealloc
{
    [mapView release];
    mapView = nil;
    
    [swipeForSearch release];
    swipeForSearch = nil;
    
    [searchView release];
    searchView = nil;
    
    [tweetInfoView release];
    tweetInfoView = nil;
    
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
