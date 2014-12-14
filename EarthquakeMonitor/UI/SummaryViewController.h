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
    NSArray *fets;
    WSHelper *hlpr;
    
    NSDate *lastPageScroll;
}

- (IBAction)refreshFeatruresList:(id)sender;

@end

