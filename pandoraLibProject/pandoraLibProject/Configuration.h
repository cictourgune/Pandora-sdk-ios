//
//  Configuration.h
//  MyFences
//
//  Created by developer on 21/02/14.
//  Copyright (c) 2014 CICtourGUNE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject{
    
}
@property (nonatomic, assign) int batteryLevel;
@property (nonatomic, assign) NSString *dtoken;
@property (nonatomic, assign) NSString *dkey;
@property (nonatomic, strong) NSString * queryDKey;

/**
 * Singleton
 * Para obtener los valores de las variables globales
 */
+(Configuration *)configuration;

@end
