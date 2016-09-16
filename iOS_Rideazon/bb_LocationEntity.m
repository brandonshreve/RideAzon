#import "bb_LocationEntity.h"
#import "bb_AddressEntity.h"
#import "bb_CoordinatesEntity.h"

@implementation bb_LocationEntity

-(id)init {
    if ((self = [super init])) {
        _locationCoordinates = [bb_CoordinatesEntity new];
        _locationAddress = [bb_AddressEntity new];
    }
    return self;
}

-(NSDictionary*)constructJsonDictinaryFromEntity {
    NSMutableDictionary* jsonDict = [NSMutableDictionary new];

    [jsonDict setValue:[_locationAddress constructJsonDictinaryFromEntity] forKey:@"LocationAddress"];
    [jsonDict setValue:[_locationCoordinates constructJsonDictinaryFromEntity] forKey:@"LocationCoordinates"];

    //TODO: LocationEvents and LocationRendezvous
    [jsonDict setValue:@"" forKey:@"LocationEvents"];
    [jsonDict setValue:@"" forKey:@"LocationRendezvous"];

    return [jsonDict copy];
}

+(bb_LocationEntity*)initEntityFromJSON:(id)json {
    if (json == NULL || [json isKindOfClass:[NSNull class]]) {
        NSLog(@"%s - json object was null", __PRETTY_FUNCTION__);
        return NULL;
    }

    id coordinates = json[@"LocationCoordinates"];
    id address = json[@"LocationAddress"];

    bb_LocationEntity* entity = [bb_LocationEntity new];
    entity.locationCoordinates = [bb_CoordinatesEntity initEntityFromJSON:coordinates];
    entity.locationAddress = [bb_AddressEntity initEntityFromJSON:address];

    return entity;
}

@end
