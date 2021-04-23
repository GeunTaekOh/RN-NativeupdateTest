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


RCT_EXPORT_METHOD(nativeUpdateLogic)
{
  [UpdateManager nativeUpdateLogic];
  
  
  NSLog(@"React Native Call nativeUpdateLogic");
}

RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(getName)
{
  return [[UIDevice currentDevice] name];
}

@end
