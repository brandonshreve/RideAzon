#import "bb_ErrorEntity.h"

@implementation bb_ErrorEntity

-(id)init {
    if ((self = [super init])) {
        _errorMessage = @"";
        _errorHasError = [NSNumber numberWithInt:0];
        _errorCode = [NSNumber numberWithInt:0];;
    }
    return self;
}

-(BOOL)evaluateError {
    if ([self.errorHasError boolValue] == YES) {
        return YES;
    }
    return NO;
}

-(NSDictionary*)constructJsonDictinaryFromEntity {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Incorrect use of ErrorEntity. Errors are never POSTed, so no constructing of JSON is ever needed."
                                 userInfo:nil];
}

+(bb_ErrorEntity*)initEntityFromJSON:(id)json {
    if (json == NULL || [json isKindOfClass:[NSNull class]]) {
        NSLog(@"%s - json object was null", __PRETTY_FUNCTION__);
        return NULL;
    }

    bb_ErrorEntity* entity = [bb_ErrorEntity new];

    bb_ErrorEntity* errorEntity = [bb_ErrorEntity new];
    errorEntity.errorMessage = json[@"Message"];
    errorEntity.errorCode = json[@"Type"];
    errorEntity.errorHasError = json[@"HasError"];

    return entity;
}

@end
