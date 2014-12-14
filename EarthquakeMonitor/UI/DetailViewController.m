//
//  DetailViewController.m
//  EarthquakeMonitor
//
//  Created by osama mourad on 12/13/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        gsfet = [[GSFeature alloc] init];
        
        [gsfet parse:self.detailItem];
        
        self.detailsNavBar.title = gsfet.place;
        
        NSString *magString = [NSString stringWithFormat:@"Magnitude: %.2f", gsfet.mag];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:gsfet.epoch_time/1000];
        NSString *dateString = [NSString stringWithFormat:@"Time: %@", [NSDateFormatter localizedStringFromDate:date
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterMediumStyle]];
        NSString *locString = [NSString stringWithFormat:@"Location (Longtiude: %.2f, Latitude: %.2f, Depth: %.2f Km)", gsfet.lng, gsfet.lat, gsfet.depth];
        
        self.detailDescriptionLabel.text = [NSString stringWithFormat:@" %@\n %@\n %@", magString,
                                                                                        dateString,
                                                                                        locString];
        self.detailDescriptionLabel.backgroundColor = gsfet.color;
        
        
        //add annotation pin
        _map.delegate = self;
        if(ann == nil)
            ann = [[MKPointAnnotation alloc] init];
        else
            [_map removeAnnotation:ann];
        
        [ann setCoordinate: CLLocationCoordinate2DMake(gsfet.lat, gsfet.lng)];
        [ann setTitle:gsfet.place];
        [_map addAnnotation:ann];
        
        //set zoom and center coord
        [self SetZoom:20.0 location:CLLocationCoordinate2DMake(gsfet.lat, gsfet.lng)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - util

//set on map center point with defined zoom level
-(void) SetZoom:(double)miles location:(CLLocationCoordinate2D) newLoc
{
    if(miles < 0.025 || miles > 7000)
        return;
    
    double scalingFactor = ABS( cos(2 * M_PI * newLoc.latitude /360.0) );
    MKCoordinateSpan span;
    span.latitudeDelta = miles/69.0f;
    span.longitudeDelta = miles/( scalingFactor*69.0f );
    MKCoordinateRegion region;
    region.span = span;
    region.center = CLLocationCoordinate2DMake(newLoc.latitude, newLoc.longitude);
    [_map setRegion:region animated:YES];
}

@end
