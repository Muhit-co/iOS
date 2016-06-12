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
    NSString *formattedAddress;
    CLLocationCoordinate2D pointedCoordinate;
    CLLocationManager *locationManager;
    UIButton *btn;
}
@end

@implementation PickFromMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [imgPoint setImage:[IonIcons imageWithIcon:ion_location size:50 color:CLR_LIGHT_BLUE]];
    [btnCancel setImage:[IonIcons imageWithIcon:ion_close size:20 color:[UIColor whiteColor]]];
    [btnLocation setImage:[IonIcons imageWithIcon:ion_navigate size:15 color:[UIColor whiteColor]]];
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
    
    NSDictionary *ntf = @{@"full":formattedAddress,@"hood":lblGeoCode1.text,@"coordinates": [NSString stringWithFormat:@"%f, %f",pointedCoordinate.latitude,pointedCoordinate.longitude]};
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
        NSLog(@"response:%@",response);
        if (!error) {
            NSString *city,*district,*hood;
            @try {
                if (response[@"results"] && [response[@"results"] count]>0) {
                    NSDictionary *address = response[@"results"][0];
                    if (address[@"address_components"]) {
                        for (NSDictionary *dict in address[@"address_components"]) {
                            if (dict[@"types"][0]) {
                                if ([dict[@"types"][0] isEqualToString:@"administrative_area_level_1"]) {
                                    city = dict[@"long_name"];
                                }
                                if ([dict[@"types"][0] isEqualToString:@"administrative_area_level_2"]) {
                                    district = dict[@"long_name"];
                                }
                                if ([dict[@"types"][0] isEqualToString:@"administrative_area_level_4"]) {
                                    hood = dict[@"long_name"];
                                }
                            }
                        }
                        formattedAddress = [NSString stringWithFormat:@"%@, %@, %@",hood,district,city];
                        [lblGeoCode1 setText:hood];
                        [lblGeoCode2 setText:[NSString stringWithFormat:@"%@, %@",district,city]];
                    }
                }
            }
            @catch (NSException *exception) {
            }
            @finally {
            }
        }
        else{
            
        }
    }];
}

#pragma mark Localization
- (void) setLocalizedStrings {
    [btnPick setTitle:LocalizedString(@"ok")];
}
#pragma mark -
@end
