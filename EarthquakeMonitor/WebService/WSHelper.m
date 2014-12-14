//
//  WSHelper.m
//  EarthquakeMonitor
//
//  Created by osama mourad on 12/13/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import "WSHelper.h"

@implementation WSHelper

-(void)setDelegate:(id<WSHelperDelegate>)delegate
{
    _del = delegate;
}

-(void)retrieveFeaturesList
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if (remoteHostStatus != NotReachable) {
        //if online get the list from web service
        _isOnline = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                
                NSString *surl = @"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson";
                NSURL *url = [[NSURL alloc] initWithString:surl];
                
                NSData *data = [NSData dataWithContentsOfURL:url];
                
                NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"WS = %@", strData);
                
                //store text locally for offline use
                NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
                [defs setValue:data forKey:@"lastUpdate"];
                [defs synchronize];
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSArray *arr = [dic objectForKey:@"features"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //update delegate with recent features list
                    if([_del respondsToSelector:@selector(wsFeaturesListRetrieved:)])
                        [_del wsFeaturesListRetrieved:arr];
                });
            }
            @catch (NSException *exception) {
                //if error occured
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([_del respondsToSelector:@selector(wsError)])
                        [_del wsError];
                });
            }
        });
    }
    else
    {
        // do offline list loading
        
        _isOnline = NO;
        
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        NSData *data = [defs valueForKey:@"lastUpdate"];
        
        if(data != nil)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSArray *arr = [dic objectForKey:@"features"];
            
            //update delegate with recent features list
            if([_del respondsToSelector:@selector(wsFeaturesListRetrieved:)])
                [_del wsFeaturesListRetrieved:arr];
        }
        else
        {
            //if error occured
            if([_del respondsToSelector:@selector(wsError)])
                [_del wsError];
        }
    }
}

@end
