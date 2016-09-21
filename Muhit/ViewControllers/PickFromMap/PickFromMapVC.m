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

    [btnLocation setImage:[IonIcons imageWithIcon:ion_android_locate size:24 color:CLR_LIGHT_BLUE]];
    
    btnPick.layer.cornerRadius = cornerRadius;
    btnLocation.layer.cornerRadius = cornerRadius;
    btnCancel.layer.cornerRadius = cornerRadius;
    
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
    
    NSDictionary *ntf = @{@"hood":lblGeoCode1.text,@"coordinates": [NSString stringWithFormat:@"%f, %f",pointedCoordinate.latitude,pointedCoordinate.longitude],@"full":[NSString stringWithFormat:@"%@, %@",lblGeoCode1.text,lblGeoCode2.text]};
    [NC postNotificationName:NC_GEOCODE_PICKED object:ntf];
    [self actCancel:nil];
}

- (IBAction)actLocation:(id)sender{
    [map animateToCameraPosition:[GMSCameraPosition cameraWithTarget:locationManager.location.coordinate zoom:16]];
}

#pragma mark - MapView Delegates

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    pointedCoordinate = position.target;
    
    [SERVICES getAddressesWithLocation:pointedCoordinate handler:^(NSDictionary *response, NSError *error) {
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
    [btnCancel setTitle:[LocalizedString(@"dismiss") toUpper]];
    [btnPick setTitle:[LocalizedString(@"ok") toUpper]];
}
#pragma mark -
@end
