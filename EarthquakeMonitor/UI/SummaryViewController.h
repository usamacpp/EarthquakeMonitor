//
//  MasterViewController.h
//  EarthquakeMonitor
//
//  Created by osama mourad on 12/13/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WSHelper.h"
#import "MBProgressHUD.h"

@interface SummaryViewController : UITableViewController <WSHelperDelegate, UIScrollViewDelegate>
{
    NSArray *fets;      //features list
    WSHelper *hlpr;     //web service helper
    
    NSDate *lastPageScroll; //date object to keep last time scroll view pulled down or up
    NSTimer *timer;     //refresh timer
}

@property (strong, nonatomic) IBOutlet UINavigationItem *titleNavBar;
- (IBAction)refreshFeatruresList:(id)sender;

@end

