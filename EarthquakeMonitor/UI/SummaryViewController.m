//
//  MasterViewController.m
//  EarthquakeMonitor
//
//  Created by osama mourad on 12/13/14.
//  Copyright (c) 2014 osama mourad. All rights reserved.
//

#import "SummaryViewController.h"
#import "DetailViewController.h"

@interface SummaryViewController ()

@end

@implementation SummaryViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //show wait indicator
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //init wen service helper object & get fets list
    hlpr = [[WSHelper alloc] init];
    [hlpr setDelegate:(id)self];
    [hlpr retrieveFeaturesList];
    
    lastPageScroll = [NSDate date];
    //self.refreshControl = [[UIRefreshControl alloc] init];
    
    //generate background image
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[self genBackgroundImage]];
    self.tableView.backgroundView = tempImageView;
    
    //refresh features list every minute
    [self fireTimer];
}

//setup refrest timer object
-(void)fireTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(refreshFeaturesList) userInfo:nil repeats:YES];
}

//refresh features list
-(void)refreshFeaturesList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hlpr retrieveFeaturesList];
}

//refresh features list & stop refresh timer
-(void)refreshFeaturesListTimerInvalidate:(BOOL)show
{
    [timer invalidate];
    if(show)
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hlpr retrieveFeaturesList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshFeatruresList:(id)sender {
    
    NSLog(@"refresh features list");
    
    [self refreshFeaturesListTimerInvalidate:YES];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //pass selected row object to details view
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSObject *object = [fets objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(fets != nil)
        return fets.count;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *fet = [fets objectAtIndex:indexPath.row];
    
    GSFeature *gsfet = [[GSFeature alloc] init];
    
    [gsfet parse:fet];
    
    cell.textLabel.text = gsfet.place;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Magnitude was %.2f", gsfet.mag];
    cell.backgroundColor = gsfet.color;
}

#pragma mark - WSHelper

//features list updated
-(void)wsFeaturesListRetrieved:(NSArray *)featuresList
{
    fets = featuresList;
    
    NSLog(@"features count = %i", (int)featuresList.count);
    
    [self.tableView reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //[self.refreshControl endRefreshing];
    
    if(timer != nil && timer.isValid == NO)
        [self fireTimer];
    
    UIColor *navColor;
    
    if(hlpr.isOnline)
    {
        _titleNavBar.title = @"Summary - Online";
        navColor = [UIColor colorWithRed:0 green:0.9 blue:0 alpha:1.0];
    }
    else
    {
        _titleNavBar.title = @"Summary - Offline";
        navColor = [UIColor colorWithRed:0.9 green:0 blue:0 alpha:1.0];
    }
    
    [self.navigationController.navigationBar setBarTintColor: navColor];
    [[UINavigationBar appearance] setTranslucent:NO];
}

//error occured
-(void)wsError
{
    NSLog(@"Error connecting to web service");
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    _titleNavBar.title = @"Summary - Error";
    UIColor *navColor = [UIColor colorWithRed:0.9 green:0 blue:0 alpha:1.0];
    [self.navigationController.navigationBar setBarTintColor: navColor];
    [[UINavigationBar appearance] setTranslucent:NO];
}

#pragma mark - UIScrollView

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //handle pull to refresh
    NSTimeInterval tint = [lastPageScroll timeIntervalSinceNow];
    
    if(fabs(tint) > 2.0f)
    {
        NSLog(@"time interval since last scroll action = %f", fabs(tint));
        
        lastPageScroll = [NSDate date];
        if(scrollView.contentOffset.y < -15)
        {
            NSLog(@"refresh");
            //[self.refreshControl beginRefreshing];
            [self refreshFeaturesListTimerInvalidate:YES];
        }
    }
}

#pragma mark - my utils

//generate background image with image scalled
-(UIImage*)genBackgroundImage
{
    UIImage *image = [UIImage imageNamed:@"AppIcon_512.png"];
    CGSize ns = self.tableView.frame.size;
    
    UIGraphicsBeginImageContext(ns);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float c = 0.8;
    CGContextSetRGBStrokeColor(ctx, 1.0, c, c, 0.8);
    CGContextSetRGBFillColor(ctx, 1.0, c, c, 0.8);
    
    CGContextFillRect(ctx, CGRectMake(0.0, 0.0, ns.width, ns.height));
    
    float scale = ns.width / image.size.width;
    float newHeight = image.size.height * scale;
    
    [image drawInRect:CGRectMake(0, (ns.height - newHeight)/2.0, ns.width, newHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
