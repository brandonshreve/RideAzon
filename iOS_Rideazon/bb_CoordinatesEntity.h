#import <Foundation/Foundation.h>
#import "bb_DataModelEntity.h"
#import "bb_DataModelProtocol.h"

@interface bb_CoordinatesEntity : bb_DataModelEntity <bb_DataModelProtocol>

@property(strong, nonatomic) NSString* coordinatesLongitude;
@property(strong, nonatomic) NSString* coordinatesLatitude;

@end
