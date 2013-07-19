//
//  MapView.m
//  BNotions-MC
//
//  Created by Kyle Brooks on 2013-07-15.
//  Copyright (c) 2013 Kyle Brooks Inc. All rights reserved.
//

#import "MapView.h"

#import "Constants.h"
#import "FHSTwitterEngine.h"
#import "MapAnnotation.h"
#import "MapAnnotationView.h"

@implementation MapView

@synthesize searchValue = _searchValue, delegate;

- (void) setSearchValue:(NSString *)searchValue
{
    if ( ![searchValue isEqualToString:_searchValue] ) {
        [_searchValue release];
        _searchValue = nil;
        
        _searchValue = [searchValue retain];
        
        [mappedData release];
        mappedData = nil;
        
        [self clearAnnotations];
        
        [self searchTwitter];
    }
}

- (NSString *)searchValue
{
    return _searchValue;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _searchValue = @"";
        
        // Initialization code
        [self initMap];
        [self initLocationManager];
    }
    return self;
}


#pragma mark - MKMapView initialization
- (void) initMap
{
    map = [[MKMapView alloc] initWithFrame:self.frame];
    map.delegate = self;
    map.showsUserLocation = YES;

    [self addSubview:map];
}

#pragma mark - CLLocationManager initialization
- (void) initLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    [locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark - Map Population

- (void) populateMap:(NSArray *)data
{
    NSArray *mapData = [data retain];
    
    if ( mappedData == nil ) {
        mappedData = [[NSMutableDictionary alloc] init];
    }
    
    dataToMap = [NSMutableDictionary dictionary];
    
    for( int i = 0; i < [mapData count]; i++ )
    {
        NSDictionary *tweet = (NSDictionary *)[mapData objectAtIndex:i];
        
        id tweetId = (id)[tweet objectForKey:@"id"];
        
        id tweetCoordinates = (id)[tweet objectForKey:@"coordinates"];
        
        if( [tweetCoordinates isKindOfClass:[NSDictionary class]] && ![mappedData objectForKey:[tweetId stringValue]]) {
            [dataToMap setObject:tweet forKey:[tweetId stringValue]];
        }
    }
    
    [mapData release];
    mapData = nil;
    
    for( int i = 0; i < [[dataToMap allKeys] count]; i++ )
    {
        NSString *key = [[dataToMap allKeys] objectAtIndex:i];
        NSDictionary *tweet = (NSDictionary *)[dataToMap valueForKey:key];
        
        id tweetId = (id)[tweet objectForKey:@"id"];
        id tweetCoordinates = (id)[tweet objectForKey:@"coordinates"];
        NSArray *coordinateArray = [tweetCoordinates objectForKey:@"coordinates"];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[coordinateArray objectAtIndex:1] floatValue];
        coordinate.longitude = [[coordinateArray objectAtIndex:0] floatValue];
        
        MapAnnotation *mapAnnotation;
        mapAnnotation = [[[MapAnnotation alloc] initWithData:tweet andCoordinate:coordinate] autorelease];

        [map addAnnotation:mapAnnotation];
        
        [mappedData setObject:tweet forKey:[tweetId stringValue]];
    }
}


- (void) clearAnnotations
{
    for (id<MKAnnotation> annotation in map.annotations) {
        
        if(annotation != map.userLocation){
            [map removeAnnotation:annotation];
        }else{
            MKAnnotationView* annotationView = [map viewForAnnotation:annotation];
            annotationView.userInteractionEnabled = NO;
            annotationView.canShowCallout = NO;
        }
    }
}


#pragma mark - MKMapView Delegate Methods

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self searchTwitter];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MapLocation";
    
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        MapAnnotationView *annotationView = (MapAnnotationView *) [ map dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if( annotation == map.userLocation ) {
            return nil;
        } else if (annotationView == nil) {
            annotationView = [[[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if( [view isKindOfClass:[MapAnnotationView class]] ) {
        [self.delegate mapAnnotationViewSelected:[(MapAnnotation *)view.annotation data]];
    }
}

- (void) mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if( [view isKindOfClass:[MapAnnotationView class]] ) {
        view.selected = NO;
        
        [self.delegate mapAnnotationViewDeselected];
    }
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    for (aV in views) {
        
        CGRect endFrame = aV.frame;
        
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 230.0, aV.frame.size.width, aV.frame.size.height);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.45];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [aV setFrame:endFrame];
        [UIView commitAnimations];
        
    }
}

#pragma mark - CLLocationManager Delegate Methods
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    
    CLLocationCoordinate2D zoomLocation = newLocation.coordinate;
    
    int zoomDistance = 10000;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoomDistance, zoomDistance);
    MKCoordinateRegion adjustedRegion = [map regionThatFits:viewRegion];
    [map setRegion:adjustedRegion animated:YES];
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"ERROR: %@", [error description]);
}


#pragma mark - Twitter Integration

- (void) searchTwitter
{
    if( [[FHSTwitterEngine sharedEngine] isAuthorized] ) {
        dispatch_async(GCDBackgroundThread, ^{
            @autoreleasepool {
                id twitterData = [[FHSTwitterEngine sharedEngine]searchTweetsWithGeoCode:[self getLocationCoordinates] andQuery:_searchValue count:100 resultType:FHSTwitterEngineResultTypePopular unil:[NSDate distantPast] sinceID:@"1" maxID:nil];
                
                if( [twitterData isKindOfClass:[NSError class]]) {
                    [self performSelector:@selector(onErrorGettingResults) onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
                    return;
                }
                dispatch_sync(GCDMainThread, ^{
                    @autoreleasepool {
                        if( twitterData && [twitterData objectForKey:@"statuses"] ) {
                            [self populateMap:[twitterData objectForKey:@"statuses"]];
                        }
                    }
                });
            }
        });
    } else {
//        [self notLoggedInError];
    }
}

- (void) notLoggedInError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error" message:@"Please login with Twitter to use the app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert autorelease];
}



- (void) onErrorGettingResults
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Error" message:@"Please provide a keyword to search Twitter." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert autorelease];
}


#pragma mark - Other methods

- (void) deselectCurrentAnnotationView
{
    
}


#pragma mark - getter methods
- (NSString *)getLocationCoordinates
{
    MKMapRect mRect = map.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    CLLocationDistance currentDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    return [NSString stringWithFormat:@"%f,%f,%fkm", map.centerCoordinate.latitude, map.centerCoordinate.longitude, currentDist / 1000];
}


- (void) dealloc
{
    locationManager.delegate = nil;
    [locationManager release];
    locationManager = nil;
    
    map.delegate = nil;
    [map release];
    map = nil;
    
    [_searchValue release];
    _searchValue = nil;
    
    [mappedData release];
    mappedData = nil;
    
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
