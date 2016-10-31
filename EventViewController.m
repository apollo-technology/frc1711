//
//  EventViewController.m
//  Raptors1711
//
//  Created by Elijah Cobb on 4/1/16.
//  Copyright © 2016 Apollo Technology. All rights reserved.
//

#import "EventViewController.h"
#import <MapKit/MapKit.h>
#import <SafariServices/SafariServices.h>
#import "RankingsTableViewController.h"
#import "AllTeamsViewController.h"

@interface EventViewController (){
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *eventCodeLabel;
    IBOutlet UILabel *datesLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *typeLabel;
    IBOutlet UILabel *districtLabel;
    IBOutlet UITableViewCell *viewWebsiteLabel;
    IBOutlet UITableViewCell *addressCell;
    IBOutlet UITableViewCell *rankingsCell;
    IBOutlet UITableViewCell *teamsCell;
}

@end

@implementation EventViewController

@synthesize event;

- (void)viewDidLoad {
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = newBackButton;
    
    self.navigationItem.title = event.shortName;
    
    nameLabel.text = [NSString stringWithFormat:@"%@",event.name];
    eventCodeLabel.text = [NSString stringWithFormat:@"%@",event.key];
    datesLabel.text = [NSString stringWithFormat:@"%@ - %@",event.startDateString,event.endDateString];
    addressLabel.text = [NSString stringWithFormat:@"%@",event.address];
    typeLabel.text = [NSString stringWithFormat:@"%@",event.type];
    districtLabel.text = [NSString stringWithFormat:@"%@",event.district];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell == viewWebsiteLabel) {
        SFSafariViewController *browser = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:event.website]];
        browser.view.tintColor = [UIColor colorWithRed:0.400 green:0.694 blue:0.298 alpha:1.00];
        [self presentViewController:browser animated:YES completion:^{
            
        }];
    } else if (selectedCell == addressCell){
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:[event.address stringByReplacingOccurrencesOfString:@"\n" withString:@","]
                         completionHandler:^(NSArray *placemarks, NSError *error) {
                             
                             // Convert the CLPlacemark to an MKPlacemark
                             // Note: There's no error checking for a failed geocode
                             CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
                             MKPlacemark *placemark = [[MKPlacemark alloc]
                                                       initWithCoordinate:geocodedPlacemark.location.coordinate
                                                       addressDictionary:geocodedPlacemark.addressDictionary];
                             
                             // Create a map item for the geocoded address to pass to Maps app
                             MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                             [mapItem setName:geocodedPlacemark.name];
                             
                             // Set the directions mode to "Driving"
                             // Can use MKLaunchOptionsDirectionsModeWalking instead
                             NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
                             
                             // Get the "Current User Location" MKMapItem
                             MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                             
                             // Pass the current location and destination map items to the Maps app
                             // Set the direction mode in the launchOptions dictionary
                             [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
                             
                         }];
        }
    } else if (selectedCell == rankingsCell){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(130.5, 80);
        spinner.color = [UIColor grayColor];
        [spinner startAnimating];
        [alert.view addSubview:spinner];
        [self presentViewController:alert animated:YES completion:^{
            [ATFRC rankingsForEvent:event.key completion:^(NSArray *rankings, BOOL succeeded) {
                RankingsTableViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"rankingDetail"];
                if (rankings.count > 1) {
                    newView.rankings = [[NSMutableArray alloc] initWithArray:rankings];
                    [newView.rankings removeObjectAtIndex:0];
                } else {
                    newView.rankings = [NSMutableArray new];
                }
                newView.event = event;
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController pushViewController:newView animated:YES];
                }];
            }];
        }];
    } else if (selectedCell == teamsCell){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Loading\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.center = CGPointMake(130.5, 80);
        spinner.color = [UIColor grayColor];
        [spinner startAnimating];
        [alert.view addSubview:spinner];
        [self presentViewController:alert animated:YES completion:^{
            [ATFRC teamsAtEvent:event.key completion:^(NSArray *teams, BOOL succeeded) {
                AllTeamsViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"teamsTable"];
                newView.teams = teams;
                [self dismissViewControllerAnimated:YES completion:^{
                    [self.navigationController pushViewController:newView animated:YES];
                }];
            }];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
