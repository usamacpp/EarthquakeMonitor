//
//  GSFeature.m
//  EarthquakeMonitor
//
//  Created by osama mourad on 12/13/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import "GSFeature.h"

@implementation GSFeature : NSObject

-(void)parse:(NSDictionary*)fet
{
    NSDictionary *props = [fet objectForKey:@"properties"];
    
    _place = [props objectForKey:@"place"];
    _mag = [[props objectForKey:@"mag"] floatValue];
    _epoch_time = [[props objectForKey:@"time"] longValue];
    
    NSDictionary *geo = [fet objectForKey:@"geometry"];
    
    NSArray *coord = [geo objectForKey:@"coordinates"];
    
    _lng = [[coord objectAtIndex:0] doubleValue];
    _lat = [[coord objectAtIndex:1] doubleValue];
    _depth = [[coord objectAtIndex:2] doubleValue];
    
    //mag = 7;
    
    //claculate color
    _red = 0.0f;
    _green = 0.0f;
    
    if(_mag <= 0.9f)
    {
        _green = 1.0f;
        _red = 0.0f;
    }
    else if(_mag >= 9.0f)
    {
        _green = 0.0f;
        _red = 0.5f;
    }
    else
    {
        _green = (1.0f - ((_mag - 0.9f)/9.1f))/2.0f;
        _red = (1.0f - ((9.0f - _mag)/9.1f))/2.0f;
    }
}

@end
