//
//  WSHelper.h
//  EarthquakeMonitor
//
//  Created by osama mourad on 12/13/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Reachability.h"
#import "GSFeature.h"

@protocol WSHelperDelegate <NSObject>

@optional

-(void) wsFeaturesListRetrieved:(NSArray*)featuresList;
-(void) wsError;

@end

@interface WSHelper : NSObject

@property (readonly) BOOL isOnline;
@property (nonatomic) id<WSHelperDelegate> del;

-(void)setDelegate:(id<WSHelperDelegate>)delegate;
-(void)retrieveFeaturesList;

@end
