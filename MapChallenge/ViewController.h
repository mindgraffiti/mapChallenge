//
//  ViewController.h
//  MapChallenge
//
//  Created by Thuy Copeland on 4/25/13.
//  Copyright (c) 2013 Thuy Copeland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSDictionary *pic;
- (IBAction)refreshTapped:(id)sender;


@end
