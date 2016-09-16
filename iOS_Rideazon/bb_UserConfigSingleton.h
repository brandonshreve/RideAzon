#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "bb_UserEntity.h"
#import "bb_EventEntity.h"
#import "bb_DriverForEventEntity.h"

@interface bb_UserConfigSingleton : NSObject

/**
 *  Shared instance of the bb_UserConfigSingleton class
 *
 *  @return the shared singleton
 */
+(bb_UserConfigSingleton*)sharedSingleton;

/**
 *  Logged in user
 */
@property (strong, nonatomic) bb_UserEntity* currentLoggedInUser;

/**
 *  The user selected an event to display
 */
@property (strong, nonatomic) bb_EventEntity* currentlySelectedEvent;

/**
 *  The user selected a driver to display
 */
@property (strong, nonatomic) bb_DriverForEventEntity* currentlySelectedDriver;


/**
 *  Location a user selected from the "Select Location" view
 */
@property (strong, nonatomic) bb_LocationEntity* locationToSave;

@end
