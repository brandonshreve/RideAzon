#import <Foundation/Foundation.h>
#import "bb_DataModelEntity.h"
#import "bb_DataModelProtocol.h"

@interface bb_AddressEntity : bb_DataModelEntity <bb_DataModelProtocol>

@property (strong, nonatomic) NSNumber* addressID;
@property (strong, nonatomic) NSString* addressDescription;
@property (strong, nonatomic) NSString* addressStreetNumber;
@property (strong, nonatomic) NSString* addressStreetName;
@property (strong, nonatomic) NSString* addressCity;
@property (strong, nonatomic) NSString* addressCounty;
@property (strong, nonatomic) NSString* addressState;
@property (strong, nonatomic) NSString* addressCountry;
@property (strong, nonatomic) NSString* addressPostalCode;

@end
