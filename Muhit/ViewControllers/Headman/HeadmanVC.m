//
//  HeadmanVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "HeadmanVC.h"
#import <MapKit/MapKit.h>

@interface HeadmanVC ()<MKMapViewDelegate,CLLocationManagerDelegate>{

    IBOutlet UILabel *lblHeadman,*lblName,*lblPhone,*lblCell,*lblMail,*lblAddress;
    IBOutlet UIImageView *imgHeadman,*imgPhone,*imgCell,*imgMail,*imgAddress;
    IBOutlet UIView *viewPhone,*viewCell,*viewMail,*viewAddress;
    IBOutlet MKMapView *map;
    CLLocationManager *locationManager;
    IBOutlet NSLayoutConstraint *constPhoneTop,*constCellTop,*constMailTop,*constAddressTop,*constMapTop;
}

@end

@implementation HeadmanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustUI];
    [self test];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

-(void)adjustUI{
    imgHeadman.layer.cornerRadius = 85/2;
    imgHeadman.layer.masksToBounds = YES;
    
    [imgPhone setImage:[IonIcons imageWithIcon:ion_android_call size:25 color:CLR_LIGHT_BLUE]];
    [imgCell setImage:[IonIcons imageWithIcon:ion_iphone size:25 color:CLR_LIGHT_BLUE]];
    [imgMail setImage:[IonIcons imageWithIcon:ion_email size:25 color:CLR_LIGHT_BLUE]];
    [imgAddress setImage:[IonIcons imageWithIcon:ion_location size:25 color:CLR_LIGHT_BLUE]];
    
    [map setShowsUserLocation:YES];
    locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
}

-(void)test{
    NSDictionary *dict =@{
                            @"name":@"Kamil Can",
                            @"image":@"http://themes.justgoodthemes.com/demo/getready/full-blue/images/John_Doe.jpg",
                            @"phone":@"0212 221 23 23",
                            @"cell":@"0535 533 23 03",
                            @"email":@"kamil.can@kadikoy.gov.tr",
//                            @"address":@"Şükrübey Mah. Can Sok. No:3",
                            @"lat":@"40.990026",
                            @"lon":@"29.024258"
                            };
    
    [self setDetailsWithDictionary:dict];
}

-(void)setDetailsWithDictionary:(NSDictionary*)dict{
    
    float total = 20;
    
    [lblName setText:dict[@"name"]];
    
    if (isNotNull(dict[@"phone"])) {
        [lblPhone setText:dict[@"phone"]];
        constPhoneTop.constant = total;
        total += 40;

    }
    else{
        [viewPhone setHidden:YES];
    }
    
    if (isNotNull(dict[@"cell"])) {
        [lblCell setText:dict[@"cell"]];
        constCellTop.constant = total;
        total += 40;
    }
    else{
        [viewCell setHidden:YES];
    }
    
    if (isNotNull(dict[@"email"])) {
        [lblMail setText:dict[@"email"]];
        constMailTop.constant = total;
        total += 40;
    }
    else{
        [viewMail setHidden:YES];
    }
    
    if (isNotNull(dict[@"address"])) {
        [lblAddress setText:dict[@"address"]];
        constAddressTop.constant = total;
        total += 40;
    }
    else{
        [viewAddress setHidden:YES];
    }
    
    constMapTop.constant = total;
    
    [self.view layoutIfNeeded];
    
    if (dict[@"image"]) {
        [imgHeadman sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]] placeholderImage:[UIImage imageNamed:@"userPlaceholder"]];
    }
    else{
        [imgHeadman setImage:[UIImage imageNamed:@"userPlaceholder"]];
    }
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    [point setCoordinate:CLLocationCoordinate2DMake([dict[@"lat"] floatValue], [dict[@"lon"] floatValue])];
    [point setTitle:LocalizedString(@"Muhtar")];
    [point setSubtitle:dict[@"name"]];

    [map addAnnotation:point];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([dict[@"lat"] floatValue], [dict[@"lon"] floatValue]), 300, 300);
    [map setRegion:[map regionThatFits:region] animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)_map viewForAnnotation:(id <MKAnnotation>)annotation{
    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    
    if (annotationView == nil){
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
    }
    
    annotationView.image = [IonIcons imageWithIcon:ion_location size:60 color:CLR_LIGHT_BLUE];
    annotationView.annotation = annotation;
    
    return annotationView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [self setTitle:LocalizedString(@"Muhtarım")];
    [lblHeadman setText:LocalizedString(@"Muhtar")];
}

@end
