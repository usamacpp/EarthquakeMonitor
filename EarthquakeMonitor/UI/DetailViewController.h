//
//  DetailViewController.h
//  EarthquakeMonitor
//
//  Created by osama mourad on 12/13/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "GSFeature.h"

@interface DetailViewController : UIViewController <MKMapViewDelegate>
{
    MKPointAnnotation *ann;
    GSFeature *gsfet;
}

@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UINavigationItem *detailsNavBar;
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

