#import "bb_RendezvousEntity.h"
#import "bb_DriverForEventEntity.h"
#import "bb_LocationEntity.h"

@implementation bb_RendezvousEntity

-(id)init {
    if ((self = [super init])) {
        _rendezvousDriverAndEventInfo = [bb_DriverForEventEntity new];
        _rendezvousRendezvousLocation = [bb_LocationEntity new];
        _rendezvousType = [NSNumber numberWithInt:0];
        _rendezvousDriverMessage = @"";
        _rendesvousDepartureTime = @"";
    }
    return self;
}

-(NSDictionary*)constructJsonDictinaryFromEntity {
    NSMutableDictionary* jsonDict = [NSMutableDictionary new];

    [jsonDict setValue:[_rendezvousDriverAndEventInfo constructJsonDictinaryFromEntity] forKey:@"DriverAndEventInfo"];
    [jsonDict setValue:[_rendezvousRendezvousLocation constructJsonDictinaryFromEntity] forKey:@"RendezvousLocation"];
    [jsonDict setValue:_rendezvousType forKey:@"Type"];
    [jsonDict setValue:_rendesvousDepartureTime forKey:@"DepartsOn"];
    [jsonDict setValue:_rendezvousDriverMessage forKey:@"DriverMessage"];

    return [jsonDict copy];
}

+(bb_RendezvousEntity*)initEntityFromJSON:(id)json {
    if (json == NULL || [json isKindOfClass:[NSNull class]]) {
        NSLog(@"%s - json object was null", __PRETTY_FUNCTION__);
        return NULL;
    }

    bb_RendezvousEntity* entity = [bb_RendezvousEntity new];

    id driverForEvent = json[@"DriverAndEventInfo"];
    id location = json[@"RendezvousLocation"];

    entity.rendezvousDriverAndEventInfo = [bb_DriverForEventEntity initEntityFromJSON:driverForEvent];
    entity.rendezvousRendezvousLocation = [bb_LocationEntity initEntityFromJSON:location];
    entity.rendezvousType = json[@"Type"];
    entity.rendezvousDriverMessage = json[@"DriverMessage"];
    entity.rendesvousDepartureTime = json[@"DepartsOn"];

    return entity;
}

@end
