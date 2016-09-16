#import "bb_UserEntity.h"

@implementation bb_UserEntity

-(id)init {
    if ((self = [super init])) {
        _userFacebookID = @"";
        _userID = @"";
        _userName = @"";
        _userEmail = @"";
        _userIsActive = [NSNumber numberWithBool:YES];
        _userCreatedOn = [NSDate date];
        _userLastLogin = [NSDate date];
    }
    return self;
}

-(NSDictionary*)constructJsonDictinaryFromEntity {
    NSMutableDictionary* jsonDict = [NSMutableDictionary new];

//    [jsonDict setValue:_userID forKey:@"ID"];
    [jsonDict setValue:_userName forKey:@"Username"];
    [jsonDict setValue:_userEmail forKey:@"Email"];
//    [jsonDict setValue:_userIsActive forKey:@"isActive"];
//    [jsonDict setValue:_userCreatedOn forKey:@"PostedOn"];
//    [jsonDict setValue:_userLastLogin forKey:@"LastLogin"];

    // TODO : DriverForEvents and PassengerOfDriversForEvent
//    [jsonDict setValue:@"" forKey:@"DriverForEvents"];
//    [jsonDict setValue:@"" forKey:@"PassengerOfDriversForEvent"];


    return [jsonDict copy];
}

+(bb_UserEntity*)initEntityFromJSON:(id)json {
    if (json == NULL || [json isKindOfClass:[NSNull class]]) {
        NSLog(@"%s - json object was null", __PRETTY_FUNCTION__);
        return NULL;
    }

    bb_UserEntity* entity = [bb_UserEntity new];

    entity.userID = json[@"ID"];
    entity.userName = json[@"Username"];
    entity.userEmail = json[@"Email"];
    entity.userIsActive = json[@"isActive"];
    entity.userCreatedOn = [bb_EventEntity convertUniversalRawTimeToLocal:json[@"PostedOn"]];
    entity.userLastLogin = [bb_EventEntity convertUniversalRawTimeToLocal:json[@"LastLogin"]];


    return entity;
}

@end
