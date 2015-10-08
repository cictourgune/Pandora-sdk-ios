//
//  MyFencesSDK.h
//  MyFences
//
//  Created by developer on 21/02/14.
//  Copyright (c) 2014 CICtourGUNE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configuration.h"
#import "GeoController.h"
#import "IBeaconController.h"

@interface PandoraSDK : UIViewController{
    Configuration *conf;
    GeoController *geo;
    IBeaconController *ibeacon;
}
/**
 * Método que inicializa el tracking
 * @param dkey El developer Key
 */
@property (nonatomic, retain) CLLocationManager *locationManager;
-(void) start :(NSString *)dkey;
-(void) start :(NSString *)dkey :(BOOL) ibeaconTrack;
@end
