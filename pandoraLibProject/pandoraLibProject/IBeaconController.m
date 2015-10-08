//
//  IBeaconController.m
//  pandora
//
//  Created by developer on 21/08/14.
//  Copyright (c) 2014 CICtourGUNE. All rights reserved.
//

#import "IBeaconController.h"
#import "ESTBeaconManager.h"

@interface IBeaconController ()<ESTBeaconManagerDelegate>
    @property (nonatomic, strong) ESTBeaconManager *beaconManager;
@end

@implementation IBeaconController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Estimote beacon manager
        self.beaconManager = [[ESTBeaconManager alloc] init];
        self.beaconManager.delegate = self;
        self.beaconManager.avoidUnknownStateBeacons = YES;
        conf=[Configuration configuration];
        
            }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void) startBeaconsLocation{
    // create sample region object (you can additionaly pass major / minor values)
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID: ESTIMOTE_PROXIMITY_UUID
                                                                  identifier:@"EstimoteSampleRegion"];
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self.beaconManager startRangingBeaconsInRegion:region];

}

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{    
    
    beaconsNow = [[NSMutableArray alloc] init];
    ibeaconsToSend = [[NSMutableArray alloc] init];
    BOOL existNow = false;
    BOOL existThen = false;
    if([beacons count] > 0)
    {
        
        for (int i=0; i<beacons.count; i++)
        {
            ESTBeacon *obj=[[ESTBeacon alloc]init];
            obj=[beacons objectAtIndex:i];
            NSString *becId = [obj.proximityUUID UUIDString];
            NSString *beaconid=[NSString stringWithFormat:@"%@%@%@",becId,obj.major,obj.minor];
            [beaconsNow addObject:beaconid];
            [ibeaconsToSend addObject:beaconid];

        }
        
        
        for (ESTBeacon *beacon in beacons){
            
            NSString *becId = [beacon.proximityUUID UUIDString];
            NSString *beaconid=[NSString stringWithFormat:@"%@%@%@",becId,beacon.major,beacon.minor];
            //ENTRADAS
            //esta en now pero no en then
            if([beaconsNow containsObject:beaconid] && (![beaconsThen containsObject:beaconid]) && (!existThen)){
                NSLog(@"Nuevo iBeacon encontrado %@",beaconid);
                //Aunque haya mas de un ibeacon nuevo solo se mandara una vez
                [self sendiBeaconsToServer:ibeaconsToSend];
                existThen=true;
            }
        }
        for (int i=0;i<beaconsThen.count;i++){
            NSString *beaconid=[beaconsThen objectAtIndex:i];
            //SALIDAS
            //esta en then pero no en now
            if(([beaconsNow containsObject:beaconid]==0)&&(!existNow)){
                NSLog(@"Salida de iBeacon %@",beaconid);
                [self sendiBeaconsToServer:ibeaconsToSend];
                existNow=true;
            }
        }
        
        
        //Volcado de todos los objetos de beaconsNow a beaconsThen
        beaconsThen = [[NSMutableArray alloc] init];
        for (int i=0; i<beaconsNow.count; i++)
        {
            NSString *beaconid = [beaconsNow objectAtIndex:i];
            [beaconsThen addObject:beaconid];
        }
        [beaconsNow removeAllObjects];
        
    }
    
}

- (void) sendiBeaconsToServer: (NSMutableArray *) finalArrayiBeacons{
    
    NSURL *url;
    NSString *token=[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
    NSLog(@"token %@",token);
    if ([token length]!=0) {
        NSData *jsonData;
        NSString *jsonString;
        
        NSString *iduser = [self generateUserID];
        
        NSArray *keys=[NSArray arrayWithObjects: @"id",@"ibeacon_id_list", @"appleToken", nil];
        NSArray *objects = [NSArray arrayWithObjects:iduser,finalArrayiBeacons,token,nil];
        
        NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
        if([NSJSONSerialization isValidJSONObject:jsonDictionary])
        {
            jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:nil];
            jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            
        }
        
        NSLog(@"json puntos a enviar al servidor: %@", jsonString);
        
        
      
        NSString *urlString=[NSString stringWithFormat:@"%@%@",@"http://dominio:80/pandora/open/sdk/user/ibeacon",[conf queryDKey]];

        
        NSLog(@"urlstring %@",urlString);
        url = [[NSURL alloc] initWithString:urlString];
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody: jsonData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        NSError *errorReturned = nil;
        NSURLResponse *theResponse =[[NSURLResponse alloc]init];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result %@", result);
        
    }
    
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
