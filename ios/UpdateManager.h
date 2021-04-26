//
//  UpdateManager.h
//  NativeUpdateTest
//
//  Created by 오근택 on 2021/04/23.
//

#ifndef UpdateManager_h
#define UpdateManager_h


#endif /* UpdateManager_h */

#import "React/RCTBridgeModule.h"

@interface UpdateManager : NSObject

+ (void)nativeUpdateLogic : (RCTResponseSenderBlock)callback;
+ (NSDictionary *) getDataFrom:(NSString *)baseUrl;
+ (NSArray *)strVersionToArray:(NSString *) strVersion;
+ (BOOL) isUpdate:(NSArray *)curVersion serverVersion : (NSArray*)serverVersion;
+ (NSString *) getiOSNativeVersion;
//+ (void) canNotUpdateCallback:(RCTResponseSenderBlock) callback;
@end

