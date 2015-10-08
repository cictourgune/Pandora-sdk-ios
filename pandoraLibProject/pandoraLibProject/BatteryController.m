//
//  BatteryController.m
//  MyFences
//
//  Created by developer on 21/02/14.
//  Copyright (c) 2014 CICtourGUNE. All rights reserved.
//

#import "BatteryController.h"

@interface BatteryController()

@end

@implementation BatteryController

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

-(int)getBatteryLevel{
    UIDevice *myDevice = [UIDevice currentDevice];
    
    NSString *model=[[UIDevice currentDevice] model];
    [myDevice setBatteryMonitoringEnabled:YES];
    float batLeft = [myDevice batteryLevel];
    int batinfo;
    
    if ([model isEqualToString:@"iPhone Simulator"]) {
        batinfo=100;
    }else{
        batinfo=(batLeft*100);
    }
    
    return batinfo;
}

@end
