#import <Foundation/Foundation.h>
#import "bb_DataModelEntity.h"
#import "bb_DataModelProtocol.h"

@interface bb_ErrorEntity : bb_DataModelEntity <bb_DataModelProtocol>

@property (strong, nonatomic) NSString* errorMessage;
@property (strong, nonatomic) NSNumber* errorHasError;
@property (strong, nonatomic) NSNumber* errorCode;

-(BOOL)evaluateError;

@end
