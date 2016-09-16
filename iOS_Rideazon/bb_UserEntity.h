#import <Foundation/Foundation.h>
#import "bb_DataModelEntity.h"
#import "bb_DataModelProtocol.h"
#import "bb_EventEntity.h"

@interface bb_UserEntity : bb_DataModelEntity <bb_DataModelProtocol>

@property (strong, nonatomic) NSString* userFacebookID;
@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSString* userEmail;
@property (strong, nonatomic) NSNumber* userIsActive;
@property (strong, nonatomic) NSDate* userCreatedOn;
@property (strong, nonatomic) NSDate* userLastLogin;

@property (strong, nonatomic) NSArray* userDriverForEvents;
@property (strong, nonatomic) NSArray* userPassengerOfDriversForEvent;

@end
