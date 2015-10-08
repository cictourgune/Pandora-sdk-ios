//
//  BatteryController.h
//  MyFences
//
//  Created by developer on 21/02/14.
//  Copyright (c) 2014 CICtourGUNE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatteryController : UIViewController

/**
 * Método que devuelve el nivel de batería del propio dispositivo
 * @return nivel de batería del dispositivo
 */
-(int)getBatteryLevel;
@end
