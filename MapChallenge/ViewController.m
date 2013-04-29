//
//  ViewController.m
//  MapChallenge
//
//  Created by Thuy Copeland on 4/25/13.
//  Copyright (c) 2013 Thuy Copeland. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "MyLocation.h"
#define METERS_PER_MILE 1609.344

@interface ViewController ()

@end
NSString *const FlickrAPIKey = @"ac8632f586ffdd791cf9af3fffecb90c";
@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 38.991971;
    zoomLocation.longitude = -94.594517;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [_mapView setRegion:viewRegion animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Add new method above refreshTapped
- (void)plotBarPositions:(id)JSON {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [_mapView removeAnnotation:annotation];
    }
    
    NSDictionary *root = (NSDictionary *)JSON;
    NSDictionary *results = [root valueForKey:@"results"];
    
    for (NSDictionary *row in results) {
        NSDictionary *location = [[row valueForKey:@"geometry"]valueForKey:@"location"];
    
        NSNumber *latitude = [location valueForKey:@"lat"];
        NSNumber *longitude = [location valueForKey:@"lng"];
        NSString *barDescription = [row valueForKey:@"name"];
        NSString *address = [row valueForKey:@"vicinity"];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        MyLocation *annotation = [[MyLocation alloc] initWithName:barDescription address:address coordinate:coordinate];
        [_mapView addAnnotation:annotation];
	}
}


- (IBAction)refreshTapped:(id)sender {
        
    NSString *searchURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=38.991971,-94.594517&radius=500&types=bar&sensor=false&key=AIzaSyDXJMmAyqt3P-FtzAVReXvhFr9mC6ueWqg"];
    
    // encode special characters found in the searchURL.
    NSString *encodedURL = [searchURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:encodedURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        // convert responseData dict to NSData
        // take the JSON and plot it!
        [self plotBarPositions:JSON];
        
//        NSURL *picURL = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=food&per_page=25&format=json&nojsoncallback=1",
//                         FlickrAPIKey];
//        
//        NSURLRequest *requestImage = [NSURLRequest requestWithURL:picURL];
//        NSLog(@"about to load image");
//        
//        AFImageRequestOperation *operationImage = [AFImageRequestOperation imageRequestOperationWithRequest:requestImage success:^(UIImage *flickrPic){
//            self.imageView = [[UIImageView alloc] initWithImage:flickrPic];
//            
//            
//            NSLog(@"image loaded");
//        }];
//        [operationImage start];
        
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"Errors. %@", error);
    }];
    
    [operation start];
    

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"drinks.png"];//here we use a nice image instead of the default pins
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            // declare the pic
            UIImage *picx = [UIImage imageNamed:@"drinks2.png"];
            // create an image view
            UIImageView *imageView = [[UIImageView alloc] initWithImage:picx];
            // pass the image view to the callout
            annotationView.leftCalloutAccessoryView = imageView;
            
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MyLocation *location = (MyLocation*)view.annotation;
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
}
@end
