#import <Foundation/Foundation.h>
#import "bb_UserEntity.h"
#import "bb_EventEntity.h"
#import "bb_DriverForEventEntity.h"

@interface bb_ServiceManager : NSObject

/**
*  Retrieves all events whose start date has not passed
*
*  @return An array of bb_EventEntitys
*/
-(NSArray*)queryForAllEvents;

/**
 *  Retrieves all drivers for a given event
 *
 *  @param event An event which will be used for querying drivers
 *
 *  @return An array of bb_DriverForEventEntitys
 */
-(NSArray*)queryForDriversForEvent:(bb_EventEntity*)event;

/**
 *  Retrieves all passengers for a given event and driver
 *
 *  @param event  An event associated with a given driver
 *  @param driver A driver for a given event
 *
 *  @return An array of bb_UserEntitys
 */
-(NSArray*)queryPassengersForEvent:(bb_EventEntity*)event withDriver:(bb_UserEntity*)driver;

/**
 *  Retrieves all events that match a given search term
 *
 *  @param searchTerm A search term to be used to query with
 *
 *  @return An array of bb_EventEntitys
 */
-(NSArray*)queryForSearchTerm:(NSString*)searchTerm;

/**
 *  Registers a user as a driver for an event, requires number of seats and a vehicle type (0 or 1)
 *
 *  @param user  User to be registered as a driver
 *  @param event The event a user will be registered as a driver for
 *  @param seats The number of available seats the driver's vehicle
 *  @param type  The type of trip (0 = To, 1 = From, 3 = Roundtrip)
 */
-(void)registerUser:(bb_UserEntity*)user AsDriverForEvent:(bb_EventEntity*)event withNumberOfSeats:(NSInteger)seats andTripType:(NSInteger)type;

/**
 *  Registers a user as a passenger of a driver for a given event
 *
 *  @param user   The user who is signing up to be a passenger
 *  @param event  The event the user is assiging themselves as a passengers for
 *  @param driver The driver who the user will be a passenger for
 */
-(void)registerUser:(bb_UserEntity*)user AsPassengerForEvent:(bb_EventEntity*)event withDriver:(bb_DriverForEventEntity*)driver;

/**
 *  Saves an event
 *
 *  @param event The event that is to be saved
 */
-(void)saveEvent:(bb_EventEntity*)event;

/**
 *  Retrieves user information and saves it within currentLoggedInUser viarable of the UserConfigSingleton
 *
 *  @param facebookID  The username for the logged in person (e.g., Facebook user John Doe's ID is JohnDoe)
 */
-(void)getUserInfoFromFacebookID:(NSString*)facebookID;


/**
 *  Verifies a Facebook user is registered with Rideazon
 *
 *  @param facebookID  The username for the logged in person (e.g., Facebook user John Doe's ID is JohnDoe)
 */
-(BOOL)isUserRegistered:(NSString*)facebookID;


/**
 *  Registers a user with Rideazon
 *
 *  @param user  The user who will be registered with Rideazon, user MUST have an Email and userID
 */
-(void)registerUser:(bb_UserEntity*)user;

@end