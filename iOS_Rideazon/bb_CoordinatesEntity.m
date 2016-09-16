#import "bb_CoordinatesEntity.h"

@implementation bb_CoordinatesEntity

-(id)init {
    if ((self = [super init])) {
        _coordinatesLongitude = @"";
        _coordinatesLatitude = @"";
    }
    return self;
}

-(NSDictionary*)constructJsonDictinaryFromEntity {
    NSMutableDictionary* jsonDict = [NSMutableDictionary new];

    [jsonDict setValue:_coordinatesLatitude forKey:@"Latitude"];
    [jsonDict setValue:_coordinatesLongitude forKey:@"Longitude"];

    return [jsonDict copy];
}

+(bb_CoordinatesEntity*)initEntityFromJSON:(id)json {
    if (json == NULL || [json isKindOfClass:[NSNull class]]) {
        NSLog(@"%s - json object was null", __PRETTY_FUNCTION__);
        return NULL;
    }

    bb_CoordinatesEntity* entity = [bb_CoordinatesEntity new];

    entity.coordinatesLatitude = json[@"Latitude"];
    entity.coordinatesLongitude = json[@"Longitude"];

    return entity;
}

@end
