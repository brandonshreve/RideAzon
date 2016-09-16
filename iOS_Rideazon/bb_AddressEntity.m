#import "bb_AddressEntity.h"

@implementation bb_AddressEntity

-(id)init {
    if ((self = [super init])) {
        _addressID = [NSNumber numberWithInt:0];
        _addressDescription = @"";
        _addressStreetNumber = @"";
        _addressStreetName = @"";
        _addressCity = @"";
        _addressCounty = @"";
        _addressState = @"";
        _addressCountry = @"";
        _addressPostalCode = @"";
    }
    return self;
}

-(NSDictionary*)constructJsonDictinaryFromEntity {
    NSMutableDictionary* jsonDict = [NSMutableDictionary new];

    [jsonDict setValue:_addressCity forKey:@"City"];
    [jsonDict setValue:_addressCountry forKey:@"Country"];
    [jsonDict setValue:_addressCounty forKey:@"County"];
    [jsonDict setValue:_addressDescription forKey:@"Description"];
    [jsonDict setValue:_addressPostalCode forKey:@"PostalCode"];
    [jsonDict setValue:_addressState forKey:@"State"];
    [jsonDict setValue:_addressStreetName forKey:@"StreetName"];
    [jsonDict setValue:_addressStreetNumber forKey:@"StreetNumber"];

    return [jsonDict copy];
}

+(bb_AddressEntity*)initEntityFromJSON:(id)json {
    if (json == NULL || [json isKindOfClass:[NSNull class]]) {
        NSLog(@"%s - json object was null", __PRETTY_FUNCTION__);
        return NULL;
    }

    bb_AddressEntity* entity = [bb_AddressEntity new];

    entity.addressID = json[@"ID"];
    entity.addressDescription = json[@"Description"];
    entity.addressStreetNumber = json[@"StreetNumber"];
    entity.addressStreetName = json[@"StreetName"];
    entity.addressCity = json[@"City"];
    entity.addressCounty = json[@"County"];
    entity.addressState = json[@"State"];
    entity.addressPostalCode = json[@"PostalCode"];

    // Don't add Locations[]. I don't want to fight circular dependencies.

    return entity;
}

@end
