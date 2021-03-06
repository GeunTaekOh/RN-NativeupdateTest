//
//  RCTUpdateModule.m
//  NativeUpdateTest
//
//  Created by 오근택 on 2021/04/23.
//

#import <Foundation/Foundation.h>
#import "RCTUpdateModule.h"
#import "UpdateManager.h"
#import <React/RCTLog.h>

@implementation RCTUpdateModule

// To export a module named RCTCalendarModule
RCT_EXPORT_MODULE();


RCT_EXPORT_METHOD(nativeUpdateLogic:(RCTResponseSenderBlock)callback)
{
  [UpdateManager nativeUpdateLogic:callback];
  NSLog(@"React Native Call nativeUpdateLogic");
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getiOSNativeVersion){
  return [UpdateManager getiOSNativeVersion];
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getName)
{
  return [[UIDevice currentDevice] name];
}

//RCT_EXPORT_METHOD(canNotUpdateCallback:(RCTResponseSenderBlock)callback)
//{
//  NSString * value = [NSString stringWithFormat:@"%@",@"hello"];
//  callback(@[[NSNull null], value]);
//}
//

@end
