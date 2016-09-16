#import <Foundation/Foundation.h>
#import "bb_DataModelEntity.h"
#import "bb_DataModelProtocol.h"
#import "bb_UserEntity.h"
#import "bb_EventEntity.h"

@interface bb_DriverForEventEntity : bb_DataModelEntity <bb_DataModelProtocol>

@property (strong, nonatomic) bb_UserEntity* driverForEventDriver;
@property (strong, nonatomic) bb_EventEntity* driverForEventEvent;
@property (strong, nonatomic) NSNumber* driverForEventAvailableSpace;
@property (strong, nonatomic) NSNumber* driverForEventType;
@property (strong, nonatomic) NSArray* driverForEventEventRednezvous;
@property (strong, nonatomic) NSArray* driverForEventEventPassengers;

@end
