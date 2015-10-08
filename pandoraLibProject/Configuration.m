//
//  Configuration.m
//  MyFences
//
//  Created by developer on 21/02/14.
//  Copyright (c) 2014 CICtourGUNE. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration
@synthesize dtoken;
@synthesize dkey;
@synthesize batteryLevel;
@synthesize queryDKey;

+(Configuration *)configuration
{
    
    static Configuration *var = nil;
    @synchronized(self)
    {
        if(!var)
        {
            var = [[Configuration alloc] init];
            
        }
    }
    return var;
    
}


@end
