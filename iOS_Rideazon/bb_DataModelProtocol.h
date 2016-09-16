#import <Foundation/Foundation.h>
#import "bb_DataModelEntity.h"

@protocol bb_DataModelProtocol <NSObject>

@required
-(NSDictionary*)constructJsonDictinaryFromEntity;
+(id<bb_DataModelProtocol>)initEntityFromJSON:(id)json;

@end
