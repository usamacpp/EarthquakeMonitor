//
//  GSFeature.h
//  EarthquakeMonitor
//
//  Created by osama mourad on 12/13/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSFeature : NSObject

@property float mag;
@property float red;
@property float green;

@property float lng;
@property float lat;
@property float depth;
@property NSString *place;

@property long epoch_time;
@property NSString *date;
@property NSString *time;

-(void)parse:(NSDictionary*)fet;

@end
