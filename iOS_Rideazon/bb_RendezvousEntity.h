#import <Foundation/Foundation.h>
#import "bb_DataModelEntity.h"
#import "bb_DataModelProtocol.h"
#import "bb_DriverForEventEntity.h"
#import "bb_LocationEntity.h"

@interface bb_RendezvousEntity : bb_DataModelEntity <bb_DataModelProtocol>

@property (strong, nonatomic) bb_DriverForEventEntity* rendezvousDriverAndEventInfo;
@property (strong, nonatomic) bb_LocationEntity* rendezvousRendezvousLocation;
@property (strong, nonatomic) NSNumber* rendezvousType;
@property (strong, nonatomic) NSString* rendezvousDriverMessage;
@property (strong, nonatomic) NSString* rendesvousDepartureTime;

@end
