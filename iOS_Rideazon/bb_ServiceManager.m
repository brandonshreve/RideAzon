#import "bb_ServiceManager.h"
#import "bb_UserConfigSingleton.h"
#import "bb_ErrorEntity.h"
#import "bb_DriverForEventEntity.h"
#import "bb_RendezvousEntity.h"

@implementation bb_ServiceManager {
    bb_UserConfigSingleton* _userConfigSingleton;
}

static NSString* kBaseURL = @"http://rideazon.azurewebsites.net/API.svc/";

-(id)init {
    self = [super init];
    if (self) {
        _userConfigSingleton = [bb_UserConfigSingleton sharedSingleton];
    }
    return self;
}

#pragma mark - Public Methods
-(NSArray*)queryForAllEvents {
    NSString* fullURL = [kBaseURL stringByAppendingString:@"Events"];
    NSURL* url = [[NSURL alloc] initWithString:fullURL];

    return [self getJSON_Events:url];
}

-(void)saveEvent:(bb_EventEntity*)event {
    NSString* fullURL = [kBaseURL stringByAppendingString:@"Events"];

    [self postJSON:[event constructJsonDictinaryFromEntity] withURL:fullURL];
}

-(void)getUserInfoFromFacebookID:(NSString*)facebookID {
    if (facebookID == NULL) {
        NSLog(@"%s - facebookID was NULL", __PRETTY_FUNCTION__);
        return;
    }

    NSString* searchQuery = [NSString stringWithFormat:@"Users?username=%@", facebookID];

    NSString* fullURL = [kBaseURL stringByAppendingString:searchQuery];
    NSURL* url = [NSURL URLWithString:fullURL];

    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [request setHTTPMethod:@"GET"];
    [request setURL:url];

    NSError* error = [NSError new];
    NSHTTPURLResponse* responseCode = nil;

    NSData* oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
    }

    if (oResponseData != nil) {
        NSError* jsonSerializationError;
        NSDictionary* allKeys = [NSJSONSerialization JSONObjectWithData:oResponseData options:NSJSONReadingAllowFragments error:&jsonSerializationError];

        NSDictionary* resultDict = allKeys[@"Result"];
        NSDictionary* contractDict = resultDict[@"Contract"];

        if ((BOOL)resultDict[@"IsSuccessful"]) {
            _userConfigSingleton.currentLoggedInUser = [bb_UserEntity initEntityFromJSON:contractDict];
        }
    }
}

-(BOOL)isUserRegistered:(NSString*)facebookID {
    if (facebookID == NULL) {
        return NO;
    }

    NSString* searchQuery = [NSString stringWithFormat:@"Users?username=%@", facebookID];

    NSString* fullURL = [kBaseURL stringByAppendingString:searchQuery];
    NSURL* url = [NSURL URLWithString:fullURL];

    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [request setHTTPMethod:@"GET"];
    [request setURL:url];

    NSError* error = [NSError new];
    NSHTTPURLResponse* responseCode = nil;

    NSData* oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
    }

    if (oResponseData) {
        NSError* jsonSerializationError;
        NSDictionary* allKeys = [NSJSONSerialization JSONObjectWithData:oResponseData options:NSJSONReadingAllowFragments error:&jsonSerializationError];

        NSDictionary* resultDict = allKeys[@"Result"];
        NSNumber* isSuccessful = (NSNumber*)resultDict[@"IsSuccessful"];

        return [isSuccessful boolValue];
    }
    return NO;
}

-(void)registerUser:(bb_UserEntity*)user {
    if (user == nil) {
        // do something
    }

    NSString* fullURL = [kBaseURL stringByAppendingString:@"Users"];
    [self postJSON:[user constructJsonDictinaryFromEntity] withURL:fullURL];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self getUserInfoFromFacebookID:user.userName];
    });
}

-(NSArray*)queryForDriversForEvent:(bb_EventEntity*)event {
    NSString* fullURL = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"Events/Drivers?eventID=%@", event.eventID]];
    NSURL* url = [[NSURL alloc] initWithString:fullURL];

    return [self getJSON_DriversForEvent:url];
}

-(NSArray*)queryPassengersForEvent:(bb_EventEntity*)event withDriver:(bb_UserEntity*)driver {
    NSString* fullURL = [kBaseURL stringByAppendingString:[NSString stringWithFormat:@"Events/Drivers/Passengers?eventID=%@&driverID=%@", event.eventID, driver.userID]];
    NSURL* url = [[NSURL alloc] initWithString:fullURL];

    return [self getJSON_Passengers:url];
}

-(NSArray*)queryForSearchTerm:(NSString*)searchTerm {
    NSString* searchQuery = [NSString stringWithFormat:@"Events?query=%@", searchTerm];
    NSString* fullURL = [kBaseURL stringByAppendingString:searchQuery];
    fullURL = [fullURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    NSURL* url = [[NSURL alloc] initWithString:fullURL];

    return [self getJSON_Events:url];
}

-(void)registerUser:(bb_UserEntity*)user AsDriverForEvent:(bb_EventEntity*)event withNumberOfSeats:(NSInteger)seats andTripType:(NSInteger)type {
    NSString* fullURL = [kBaseURL stringByAppendingString:@"Events/Drivers"];

    NSMutableDictionary* jsonDict = [NSMutableDictionary new];
    NSMutableDictionary* eventInfoDict = [NSMutableDictionary new];
    NSMutableDictionary* driverInfoDict = [NSMutableDictionary new];

    NSNumber* seatsAvailable = [NSNumber numberWithInteger:seats];
    NSNumber* vehicleType = [NSNumber numberWithInteger:type];

    [eventInfoDict setValue:event.eventID forKey:@"ID"];
    [driverInfoDict setValue:user.userID forKey:@"ID"];

    [jsonDict setValue:seatsAvailable forKey:@"SpaceAvailable"];
    [jsonDict setValue:vehicleType forKey:@"Type"];
    [jsonDict setObject:driverInfoDict forKey:@"DriverInfo"];
    [jsonDict setObject:eventInfoDict forKey:@"EventInfo"];

    [self postJSON:jsonDict withURL:fullURL];
}

-(void)registerUser:(bb_UserEntity*)user AsPassengerForEvent:(bb_EventEntity*)event withDriver:(bb_DriverForEventEntity*)driver {
    NSString* fullURL = [kBaseURL stringByAppendingString:@"Events/Drivers/Passengers"];

    NSMutableDictionary* jsonDict = [NSMutableDictionary new];
    NSMutableDictionary* driverContractDict = [NSMutableDictionary new];
    NSMutableDictionary* passengerContractDict = [NSMutableDictionary new];
    NSMutableDictionary* driverInfoDict = [NSMutableDictionary new];
    NSMutableDictionary* eventInfoDict = [NSMutableDictionary new];

    [driverInfoDict setValue:driver.driverForEventDriver.userID forKey:@"ID"];
    [eventInfoDict setValue:event.eventID forKey:@"ID"];
    [passengerContractDict setValue:user.userID forKey:@"ID"];

    [driverContractDict setObject:driverInfoDict forKey:@"DriverInfo"];
    [driverContractDict setObject:eventInfoDict forKey:@"EventInfo"];
    [driverContractDict setValue:driver.driverForEventAvailableSpace forKey:@"SpaceAvailable"];
    [driverContractDict setValue:driver.driverForEventType forKey:@"Type"];

    [jsonDict setObject:driverContractDict forKey:@"DriverContract"];
    [jsonDict setObject:passengerContractDict forKey:@"PassengerContract"];

    [self postJSON:jsonDict withURL:fullURL];
}

#pragma mark - Private Methods
-(NSArray*)getJSON_Events:(NSURL*)url {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    NSMutableArray* events = [NSMutableArray new];

    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];

    NSData* urlData;
    NSURLResponse* response;
    NSError* error;

    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];

    if (urlData) {
        NSError* jsonSerializationError;

        id allKeys = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&jsonSerializationError];

        if (!jsonSerializationError) {
            id result = allKeys[@"Result"];
            id collection = result[@"Collection"];

            if (![collection isKindOfClass:[NSNull class]]) {
                for (id event in collection) {
                    bb_EventEntity* entity = [bb_EventEntity initEntityFromJSON:event];
                    [events addObject:entity];
                }
            }
        }
    }
    return [events copy];
}

-(NSArray*)getJSON_DriversForEvent:(NSURL*)url {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    NSMutableArray* drivers = [NSMutableArray new];


    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];

    NSData* urlData;
    NSURLResponse* response;
    NSError* error;

    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];

    if (urlData) {
        NSError* jsonSerializationError;

        id allKeys = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&jsonSerializationError];

        if (!jsonSerializationError) {
            id result = allKeys[@"Result"];
            id collection = result[@"Collection"];

            for (id driverForEvent in collection) {
                bb_DriverForEventEntity* entity = [bb_DriverForEventEntity initEntityFromJSON:driverForEvent];
                [drivers addObject:entity];
            }
        }
    }
    return [drivers copy];
}

-(NSArray*)getJSON_Passengers:(NSURL*)url {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    NSMutableArray* passengers = [NSMutableArray new];

    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];

    NSData* urlData;
    NSURLResponse* response;
    NSError* error;

    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];

    if (urlData) {
        NSError* jsonSerializationError;
        id allKeys = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&jsonSerializationError];

        id result = allKeys[@"Result"];
        id collection = result[@"Contract"];
        id eventPassengers = collection[@"EventPassengers"];

        for (id passenger in eventPassengers) {
            bb_UserEntity* entity = [bb_UserEntity initEntityFromJSON:passenger];
            if (entity.userID == _userConfigSingleton.currentLoggedInUser.userID) {
                continue;
            }

            [passengers addObject:entity];
        }

        return [passengers copy];
    }
    return NULL;
}

-(BOOL)postJSON:(NSDictionary*)jsonDict withURL:(NSString*)url {
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:url]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];

    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:0
                                                         error:&error];

    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-length"];

    [request setHTTPBody:jsonData];

    NSURLConnection* urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    if (urlConnection) {
        NSLog(@"%s - NSURLConnection succeeded", __PRETTY_FUNCTION__);
        return YES;
    }
    else {
        NSLog(@"%s - NSURLConnection failed", __PRETTY_FUNCTION__);
        return NO;
    }
}

@end