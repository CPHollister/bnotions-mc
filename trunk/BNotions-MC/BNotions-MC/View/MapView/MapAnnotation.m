//
//  MapAnnotation.m
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-17.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize coordinate;

- (id) initWithData:(NSDictionary *)data andCoordinate:(CLLocationCoordinate2D )tweetCoordinate
{
    if( [self init] ) {
        self.data = data;
        
        coordinate = tweetCoordinate;
    }
    
    return self;
}


- (void) dealloc
{
    self.data = nil;
    
    [super dealloc];
}

@end
