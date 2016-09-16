#import <Foundation/Foundation.h>
#import "bb_DataModelEntity.h"
#import "bb_DataModelProtocol.h"
#import "bb_LocationEntity.h"

static NSString* kReminderRemindMe = @"Remind Me";
static NSString* kReminderCancelReminder = @"Cancel Reminder";

@interface bb_EventEntity : bb_DataModelEntity <bb_DataModelProtocol>

@property (strong, nonatomic) NSNumber* eventID;
@property (strong, nonatomic) NSString* eventTitle;
@property (strong, nonatomic) NSString* eventDescription;
@property (strong, nonatomic) NSDate* eventStartDateTime;
@property (strong, nonatomic) NSDate* eventEndDateTime;
@property (strong, nonatomic) NSDate* eventCreatedOn;
@property (strong, nonatomic) NSArray* eventDrivers;
@property (strong, nonatomic) bb_LocationEntity* eventLocation;

+(NSDateFormatter*)getUniversalDateFormatterForModel;
+(NSDateFormatter*)getLocalDateFormatterForModel;
+(NSDate*)convertUniversalRawTimeToLocal:(NSString*)string;
+(NSString*)convertLocalTimeToUniversal:(NSDate*)date;

@end
