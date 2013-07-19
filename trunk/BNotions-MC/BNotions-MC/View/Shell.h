//
//  Shell.h
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-15.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import "SearchView.h"

@class TweetInfoView;

@interface Shell : UIView <MapViewDelegate, SearchViewDelegate>
{
    // Views
    MapView *mapView;
    SearchView *searchView;
    TweetInfoView *tweetInfoView;
    
    // Properties
    BOOL searchViewIsOpen;
    
    // Gestures
    UISwipeGestureRecognizer *swipeForSearch;
}

- (void) initMapView;
- (void) initSearchView;
- (void) initTweetInfoView;
- (void) initShellGestures;

- (void) onTwitterLoginSuccess;
@end
