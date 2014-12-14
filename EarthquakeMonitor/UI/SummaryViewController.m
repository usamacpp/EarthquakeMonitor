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
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WSHelper setDelegate:(id)self];
    hlpr = [[WSHelper alloc] init];
    [hlpr retrieveFeaturesList];
    
    lastPageScroll = [NSDate date];
    
    //self.tableView.backgroundColor=[UIColor redColor];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppIcon_512.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshFeatruresList:(id)sender {
    
    NSLog(@"refresh features list");
    
    [hlpr retrieveFeaturesList];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
    cell.backgroundColor = [UIColor colorWithRed:gsfet.red green:gsfet.green blue:0.0f alpha:0.9f];
}

#pragma mark - WSHelper

-(void)wsFeaturesListRetrieved:(NSArray *)featuresList
{
    fets = featuresList;
    
    NSLog(@"features count = %i", (int)featuresList.count);
    
    [self.tableView reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)wsError
{
    NSLog(@"Error connecting to web service");
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - UIScrollView

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSTimeInterval tint = [lastPageScroll timeIntervalSinceNow];
    
    if(fabs(tint) > 3.0f)
    {
        NSLog(@"time interval since last scroll action = %f", fabs(tint));
        
        lastPageScroll = [NSDate date];
        if(scrollView.contentOffset.y < -15)
        {
            NSLog(@"refresh");
            
            [hlpr retrieveFeaturesList];
        }
    }
}

@end
