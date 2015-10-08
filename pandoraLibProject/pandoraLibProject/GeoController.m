//
//  GeoController.m
//  MyFences
//
//  Created by developer on 21/02/14.
//  Copyright (c) 2014 CICtourGUNE. All rights reserved.
//

#import "GeoController.h"


@implementation GeoController
@synthesize locationManager;
@synthesize delegate;

-(id) init{
    self=[super init];
    if(self!=nil){
        self.locationManager=[[CLLocationManager alloc]init];
        self.locationManager.delegate=self;
        //Controlar la versión de iOS para el tracking de localización
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            //[self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        }

        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.pausesLocationUpdatesAutomatically = NO;
        locationManager.distanceFilter= 30.0f;//30 metros
        conf=[Configuration configuration];
        bat=[[BatteryController alloc]init];
    }
    return self;
}
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    latitud=[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    longitud=[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    //Los valores de NSUserDefaults están asignados en AppDelegate.m
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
        
    if(bat.getBatteryLevel <= 15){
        [self stopService];
    }else{
        if ([token length]!=0) {
                
            latitud=[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
            longitud=[NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
                
            NSData *jsonData;
            NSString *jsonString;
                
            NSString *iduser = [self generateUserID];
                
            [conf setDtoken:token];
                
            NSArray *keys=[NSArray arrayWithObjects: @"id", @"longitude", @"latitude", @"appleToken", nil];
            NSArray *objects = [NSArray arrayWithObjects:iduser,longitud,latitud,token,nil];
                
            NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
                
                
            if([NSJSONSerialization isValidJSONObject:jsonDictionary])
            {
                jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
                jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
                    
            }
                
            NSLog(@"json puntos a enviar al servidor: %@", jsonString);
            [self sendPostToServer:jsonData];
        }
            
    }
    
}


- (void) sendPostToServer:(NSData *)jsonData{
    NSURL *url;
    if (!([conf dtoken]==NULL)) {

        NSString *urlString=[NSString stringWithFormat:@"%@%@",@"http://dominio:80/pandora/open/sdk/user",[conf queryDKey]];
       
        NSLog(@"URL %@",urlString);
        url = [[NSURL alloc] initWithString:urlString];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: jsonData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        //NSLog(@"request %@", request);
        NSError *errorReturned = nil;
        NSURLResponse *theResponse =[[NSURLResponse alloc]init];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
        NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result %@", result);
        
    }
    
}

- (void)stopService{
    [self.locationManager stopUpdatingLocation];
}

-(NSString *) generateUserID{
    NSString *ident = [[NSUserDefaults standardUserDefaults] objectForKey:@"unique identifier stored for app"];
    if (!ident) {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        ident = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
        CFRelease(uuidStringRef);
        [[NSUserDefaults standardUserDefaults] setObject:ident forKey:@"unique identifier stored for app"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return ident;
}

@end
