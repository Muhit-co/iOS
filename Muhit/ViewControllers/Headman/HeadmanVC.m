//
//  HeadmanVC.m
//  Muhit
//
//  Created by Emre YANIK on 05/06/15.
//  Copyright (c) 2015 Muhit. All rights reserved.
//

#import "HeadmanVC.h"

@interface HeadmanVC ()<CLLocationManagerDelegate>{
    
    IBOutlet UILabel *lblHood,*lblName,*lblCity,*lblPhone,*lblCell,*lblMail,*lblAddress,*lblHoodIdeas;
    IBOutlet UIImageView *imgHeadman,*imgPhone,*imgCell,*imgMail,*imgAddress,*imgIdeas;
    IBOutlet UIView *viewPhone,*viewCell,*viewMail,*viewAddress;
    IBOutlet UIButton *btnMenu,*btnHoodIdeas;
    IBOutlet GMSMapView *map;
    CLLocationManager *locationManager;
    IBOutlet NSLayoutConstraint *constPhoneTop,*constCellTop,*constMailTop,*constAddressTop,*constMapTop;
    BOOL fromMenu;
    NSDictionary *dictHeadman;
}
@end

@implementation HeadmanVC

- (id)initFromMenu{
    self = [super init];
    if (self){
        fromMenu = YES;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (fromMenu) {
        [btnMenu setSize:CGSizeMake(40, 36)];
        [btnMenu setImage:[IonIcons imageWithIcon:ion_navicon size:36 color:CLR_WHITE]];
        UIBarButtonItem *barBtnMenu = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -12;
        [[self navigationItem] setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, barBtnMenu, nil] animated:NO];
    }
    
    [self adjustUI];
    [self.view setHidden:YES];
    [self getHeadman];
}

-(void)adjustUI{
    imgHeadman.layer.cornerRadius = 50;
    imgHeadman.layer.masksToBounds = YES;
    
    btnHoodIdeas.layer.cornerRadius = cornerRadius;
    
    [imgIdeas setImage:[IonIcons imageWithIcon:ion_chevron_down size:16 color:CLR_WHITE]];
    [imgPhone setImage:[IonIcons imageWithIcon:ion_android_call size:24 color:CLR_LIGHT_BLUE]];
    [imgCell setImage:[IonIcons imageWithIcon:ion_iphone size:24 color:CLR_LIGHT_BLUE]];
    [imgMail setImage:[IonIcons imageWithIcon:ion_email size:24 color:CLR_LIGHT_BLUE]];
    [imgAddress setImage:[IonIcons imageWithIcon:ion_location size:24 color:CLR_LIGHT_BLUE]];
    
    locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
}

-(IBAction)actMenu:(id)sender{
    [self.view endEditing:YES];
    [[MT drawerController] toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)getHeadman{
    ADD_HUD
    [SERVICES getHeadman:[MT userId] handler:^(NSDictionary *response, NSError *error) {
        if (error) {
            REMOVE_HUD
            SHOW_ALERT(response[KEY_ERROR][KEY_MESSAGE]);
        }
        else{
            [self setDetailsWithDictionary:response[@"headMan"]];
        }
    }];
}

-(void)setDetailsWithDictionary:(NSDictionary*)dict{
    
    dictHeadman = dict;
    
    float total = 0;
    
    [lblName setText:dict[@"full_name"]];
    [lblHood setText:dict[@"hood"]];
    [lblCity setText:dict[@"city"]];
    [lblHoodIdeas setText:dict[@"hood"]];
    
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
    
    if (isNotNull(dict[@"location"])) {
        [lblAddress setText:dict[@"location"]];
        constAddressTop.constant = total;
        total += 40;
    }
    else{
        [viewAddress setHidden:YES];
    }
    constMapTop.constant = total;
    
    [self.view layoutIfNeeded];
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@/200x200/%@",IMAGE_PROXY,dict[@"picture"]];
    [imgHeadman sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:PLACEHOLDER_IMAGE];
    
    if (dict[@"coordinates"]) {
        [self setMarkerWithLocation:CLLocationCoordinate2DMake([dict[@"coordinates"][@"lat"] doubleValue], [dict[@"coordinates"][@"lon"] doubleValue])];
    }
    else{
        [SERVICES getLocationWithAddress:dict[@"location"] handler:^(NSDictionary *response, NSError *error) {
            if (response) {
                NSDictionary *location = [UF getLocationFromGMSResult:response];
                if (location) {
                    [self setMarkerWithLocation:CLLocationCoordinate2DMake([location[@"lat"] doubleValue], [location[@"lon"] doubleValue])];
                }
            }
        }];
    }
}

-(void)setMarkerWithLocation:(CLLocationCoordinate2D)coordHeadman{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordHeadman;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.icon = [IonIcons imageWithIcon:ion_location size:75 color:CLR_DARK_PUPRPLE];
    marker.title = LocalizedString(@"Muhtar");
    marker.snippet = dictHeadman[@"full_name"];
    marker.map = map;
    
    [map setCamera:[GMSCameraPosition cameraWithLatitude:coordHeadman.latitude longitude:coordHeadman.longitude zoom:9]];
    
    REMOVE_HUD
    [self.view setHidden:NO];
}

-(IBAction)actGoIdeas:(id)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLocalizedStrings{
    [[self navigationItem] setTitleView:[UF titleViewWithTitle:LocalizedString(@"my-headman")]];
    [btnHoodIdeas setTitle:[LocalizedString(@"go-ideas") toUpper]];
}

@end
