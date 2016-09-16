#import "bb_DriverForEventEntity.h"
#import "bb_UserEntity.h"
#import "bb_EventEntity.h"

@implementation bb_DriverForEventEntity

-(id)init {
    if ((self = [super init])) {
        _driverForEventDriver = [bb_UserEntity new];
        _driverForEventEvent = [bb_EventEntity new];
        _driverForEventAvailableSpace = [NSNumber numberWithInt:0];
        _driverForEventType = [NSNumber numberWithInt:0];
    }
    return self;
}

-(NSDictionary*)constructJsonDictinaryFromEntity {
    return [_driverForEventDriver constructJsonDictinaryFromEntity];

//    NSMutableDictionary* jsonDict = [NSMutableDictionary new];

//    [jsonDict setValue:[_driverForEventDriver constructJsonDictinaryFromEntity] forKey:@"DriverInfo"];
//    [jsonDict setValue:[_driverForEventEvent constructJsonDictinaryFromEntity] forKey:@"EventInfo"];
//    [jsonDict setValue:_driverForEventAvailableSpace forKey:@"SpaceAvailable"];
//    [jsonDict setValue:_driverForEventType forKey:@"Type"];

    // TODO : EventRendezvous and EventPassengers
//    [jsonDict setValue:@"" forKey:@"EventRendezvous"];
//    [jsonDict setValue:@"" forKey:@"EventPassengers"];

//    return [jsonDict copy];
}

+(bb_DriverForEventEntity*)initEntityFromJSON:(id)json {
    if (json == NULL || [json isKindOfClass:[NSNull class]]) {
        NSLog(@"%s - json object was null", __PRETTY_FUNCTION__);
        return NULL;
    }

    bb_DriverForEventEntity* entity = [bb_DriverForEventEntity new];

    id user = json[@"DriverInfo"];
    id event = json[@"EventInfo"];

    entity.driverForEventEvent = [bb_EventEntity initEntityFromJSON:event];
    entity.driverForEventDriver = [bb_UserEntity initEntityFromJSON:user];

    entity.driverForEventAvailableSpace = json[@"SpaceAvailable"];
    entity.driverForEventType = json[@"Type"];

    return entity;
}

@end
