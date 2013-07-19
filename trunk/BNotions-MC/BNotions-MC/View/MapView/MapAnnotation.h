//
//  MapAnnotation.h
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-17.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, retain) NSDictionary *data;
@property (nonatomic, readonly)CLLocationCoordinate2D coordinate;

- (id) initWithData:(NSDictionary *)data andCoordinate:(CLLocationCoordinate2D )tweetCoordinate;
@end
