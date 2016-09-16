#import <Foundation/Foundation.h>
#import "bb_UserConfigSingleton.h"

@implementation bb_UserConfigSingleton

static bb_UserConfigSingleton* singleton = NULL;

+(bb_UserConfigSingleton*)sharedSingleton {
    @synchronized(self) {
        if (singleton == nil) {
            singleton = [self new];
        }
    }
    return singleton;
}

-(id)init {
    if ((self = [super init])) {
        _currentLoggedInUser = [bb_UserEntity new];
        _currentlySelectedEvent = [bb_EventEntity new];
        _currentlySelectedDriver = [bb_DriverForEventEntity new];
        _locationToSave = [bb_LocationEntity new];
    }
    return self;
}

@end