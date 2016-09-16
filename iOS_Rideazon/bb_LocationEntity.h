#import <Foundation/Foundation.h>
#import "bb_DataModelEntity.h"
#import "bb_DataModelProtocol.h"
#import "bb_AddressEntity.h"
#import "bb_CoordinatesEntity.h"

@interface bb_LocationEntity : bb_DataModelEntity <bb_DataModelProtocol>

@property (strong, nonatomic) bb_CoordinatesEntity* locationCoordinates;
@property (strong, nonatomic) bb_AddressEntity* locationAddress;

@end
