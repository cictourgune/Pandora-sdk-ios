//
//  GeoController.h
//  MyFences
//
//  Created by developer on 21/02/14.
//  Copyright (c) 2014 CICtourGUNE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Configuration.h"
#import "BatteryController.h"

@interface GeoController : NSObject <CLLocationManagerDelegate>{
    NSString *latitud;
    NSString *longitud;
    Configuration *conf;
    BatteryController *bat;
    NSDate * timestamp;
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) id delegate;

/**
 * Método que obtiene la localización
 * @param manager
 * @param locations un array que contiene la localización nueva y la anterior
 */
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
/**
 * Método que para el servicio de tracking
 */
- (void) stopService;

@end
