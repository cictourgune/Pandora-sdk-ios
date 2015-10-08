//
//  MyFencesSDK.m
//  MyFences
//
//  Created by developer on 21/02/14.
//  Copyright (c) 2014 CICtourGUNE. All rights reserved.
//

#import "PandoraSDK.h"
#import "GeoController.h"


@interface PandoraSDK ()
    
@end

@implementation PandoraSDK

-(id) init{
    self=[super init];
    if(self!=nil){
        conf=[Configuration configuration];
        geo=[[GeoController alloc]init];
        ibeacon=[[IBeaconController alloc]init];
        
        
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//-(void) start :(NSString *)dkey :(BOOL) ibeaconStart{
-(void) start :(NSString *)dkey :(BOOL) ibeaconTrack{
    if (!((dkey==NULL)||([dkey isEqual:@""]))) {
        NSString *query=[NSString stringWithFormat:@"%@%@",@"?key=",dkey];
        [conf setQueryDKey:query];
        [conf setDkey:dkey];
        geo.delegate=self;
        [geo.locationManager startUpdatingLocation];
        if (ibeaconTrack) {
             [ibeacon startBeaconsLocation];
        }
    }else{
       NSLog(@"Debe de introducir el Developer Key"); 
    }
}
- (void)stopService{
    [geo stopService];
    
}

@end
