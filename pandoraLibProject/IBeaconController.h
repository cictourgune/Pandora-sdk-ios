//
//  IBeaconController.h
//  pandora
//
//  Created by developer on 21/08/14.
//  Copyright (c) 2014 CICtourGUNE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configuration.h"

@interface IBeaconController : UIViewController {
    NSMutableArray *beaconsNow;
    NSMutableArray *beaconsThen;
    NSMutableArray *ibeaconsToSend;
    Configuration *conf;
}
/**
 * Método que inicializa el tracking de los iBeacons
 */
-(void) startBeaconsLocation;
@end
