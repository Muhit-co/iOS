//
//  PickFromMapVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "PickFromMapVC.h"


@interface PickFromMapVC ()<CLLocationManagerDelegate> {
    
    IBOutlet GMSMapView *map;
    IBOutlet UIImageView *imgPoint;
    IBOutlet UIButton *btnCancel,*btnPick,*btnLocation;
    IBOutlet UILabel *lblGeoCode1,*lblGeoCode2;
    CLLocationCoordinate2D pointedCoordinate;
    CLLocationManager *locationManager;
    UIButton *btn;
}
@end

@implementation PickFromMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [imgPoint setImage:[IonIcons imageWithIcon:ion_location size:75 color:CLR_DARK_PUPRPLE]];
    [btnCancel setImage:[IonIcons imageWithIcon:ion_close size:20 color:CLR_WHITE]];
    [btnLocation setImage:[IonIcons imageWithIcon:ion_navigate size:15 color:CLR_WHITE]];
    btnPick.layer.cornerRadius = cornerRadius;
    btnLocation.layer.cornerRadius = cornerRadius;
    
    locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    map.settings.rotateGestures = NO;
    map.settings.tiltGestures = NO;
    [map setCamera:[GMSCameraPosition cameraWithTarget:locationManager.location.coordinate zoom:16]];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view layoutIfNeeded];
}

- (IBAction)actCancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actPicked:(id)sender{
    
    NSDictionary *ntf = @{@"hood":lblGeoCode1.text,@"coordinates": [NSString stringWithFormat:@"%f, %f",pointedCoordinate.latitude,pointedCoordinate.longitude]};
    [NC postNotificationName:NC_GEOCODE_PICKED object:ntf];
    [self actCancel:nil];
}

- (IBAction)actLocation:(id)sender{
    [map animateToCameraPosition:[GMSCameraPosition cameraWithTarget:locationManager.location.coordinate zoom:16]];
}

#pragma mark - MapView Delegates

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    pointedCoordinate = position.target;
    
    [MuhitServices getAddressesWithLocation:pointedCoordinate handler:^(NSDictionary *response, NSError *error) {
        if (!error) {
            @try {
                [lblGeoCode1 setText:[UF getHoodFromGMSAddress:response]];
                [lblGeoCode2 setText:[UF getDistrictCityFromGMSAddress:response]];
            }
            @catch (NSException *exception) {} @finally {}
        }
    }];
}

#pragma mark Localization
- (void) setLocalizedStrings {
    [btnPick setTitle:LocalizedString(@"ok")];
}
#pragma mark -
@end
