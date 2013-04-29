//
//  MyLocation.h
//  MapChallenge
//
//  Created by Thuy Copeland on 4/25/13.
//  Copyright (c) 2013 Thuy Copeland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyLocation : NSObject <MKAnnotation>
- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
