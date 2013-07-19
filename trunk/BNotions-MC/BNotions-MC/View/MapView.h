//
//  MapView.h
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-15.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class MapView;
@protocol MapViewDelegate <NSObject>
@required
- (void)mapAnnotationViewSelected:(NSDictionary *)data;
- (void)mapAnnotationViewDeselected;
@end

@interface MapView : UIView <MKMapViewDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>
{
    MKMapView *map;
    
    CLLocationManager *locationManager;
    
    NSString *_searchValue;
    
    NSMutableDictionary *dataToMap;
    NSMutableDictionary *mappedData;
}

@property (nonatomic, retain) NSString *searchValue;
@property (nonatomic, assign) id delegate;

- (void) initMap;
- (void) initLocationManager;

- (void) populateMap:(NSArray *)d;

- (void) deselectCurrentAnnotationView;

@end
