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
        GSFeature *gsfet = [[GSFeature alloc] init];
        
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
        self.detailDescriptionLabel.backgroundColor = [UIColor colorWithRed:gsfet.red green:gsfet.green blue:0.0f alpha:1.0f];
        
        
        //add annotation pin
        if(ann == nil)
            ann = [[MKPointAnnotation alloc] init];
        else
            [_map removeAnnotation:ann];
        
        [ann setCoordinate: CLLocationCoordinate2DMake(gsfet.lat, gsfet.lng)];
        //[ann setTitle:@"place"];
        //[ann setSubtitle:str];
        [_map addAnnotation:ann];
        
        _map.centerCoordinate = CLLocationCoordinate2DMake(gsfet.lat, gsfet.lng);
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

@end
