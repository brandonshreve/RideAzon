#import "bb_EventEntity.h"
#import "bb_LocationEntity.h"
#import "bb_UserEntity.h"

@implementation bb_EventEntity

-(id)init {
    if ((self = [super init])) {
        _eventID = [NSNumber numberWithInt:1000];
        _eventTitle = @"";
        _eventDescription = @"";
        _eventStartDateTime = [NSDate date];
        _eventEndDateTime = [NSDate date];
        _eventCreatedOn = [NSDate date];
        _eventLocation = [bb_LocationEntity new];
    }
    return self;
}

-(NSDictionary*)constructJsonDictinaryFromEntity {
    NSMutableDictionary* jsonDict = [NSMutableDictionary new];

    [jsonDict setValue:_eventID forKey:@"ID"];
    [jsonDict setValue:_eventTitle forKey:@"Title"];
    [jsonDict setValue:_eventDescription forKey:@"Description"];
    [jsonDict setValue:[bb_EventEntity convertLocalTimeToUniversal:_eventStartDateTime] forKey:@"StartsOn"];
    [jsonDict setValue:[bb_EventEntity convertLocalTimeToUniversal:_eventEndDateTime] forKey:@"EndsOn"];

    [jsonDict setValue:[_eventLocation constructJsonDictinaryFromEntity] forKey:@"EventLocation"];

    // TODO: Drivers
    [jsonDict setValue:@"" forKey:@"Drivers"];

    return [jsonDict copy];
}

+(bb_EventEntity*)initEntityFromJSON:(id)json {
    if (json == NULL) {
        NSLog(@"%s - json object was null", __PRETTY_FUNCTION__);
        return NULL;
    }

    bb_EventEntity* entity = [bb_EventEntity new];
    NSMutableArray* driversBuffer = [NSMutableArray new];

    id location = json[@"EventLocation"];
    id drivers = json[@"Drivers"];

    if (![drivers isKindOfClass:[NSNull class]]) {
        for (id driver in drivers) {
            id driverInfo = driver[@"DriverInfo"];
            bb_UserEntity* entity = [bb_UserEntity initEntityFromJSON:driverInfo];

            [driversBuffer addObject:entity];
        }
    }

    entity.eventID = json[@"ID"];
    entity.eventTitle = json[@"Title"];
    entity.eventDescription = json[@"Description"];
    entity.eventLocation = [bb_LocationEntity initEntityFromJSON:location];

    entity.eventStartDateTime = [bb_EventEntity convertUniversalRawTimeToLocal:json[@"StartsOn"]];
    entity.eventEndDateTime = [bb_EventEntity convertUniversalRawTimeToLocal:json[@"EndsOn"]];
    entity.eventCreatedOn = [bb_EventEntity convertUniversalRawTimeToLocal:json[@"PostedOn"]];
    entity.eventDrivers = [driversBuffer copy];

    return entity;
}

//TODO: Move everything below this point into an NSDate Category
+(NSDateFormatter*)getUniversalDateFormatterForModel {
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return formatter;
}

+(NSDateFormatter*)getLocalDateFormatterForModel {
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return formatter;
}

+(NSDate*)convertUniversalRawTimeToLocal:(NSString*)string {
    NSString* temp = [string stringByReplacingOccurrencesOfString:@"Z" withString:@""];

    NSDateFormatter* formatter = [bb_EventEntity getLocalDateFormatterForModel];
    NSDate* parsedDate = [formatter dateFromString:temp];
    return parsedDate;
}

+(NSString*)convertLocalTimeToUniversal:(NSDate*)date {
    NSDateFormatter* formatter = [bb_EventEntity getUniversalDateFormatterForModel];
    NSString* rawDateString = [formatter stringFromDate:date];
    NSString* temp = [rawDateString stringByAppendingString:@"Z"];
    return temp;
}

@end
