//
//  UpdateManager.m
//  NativeUpdateTest
//
//  Created by 오근택 on 2021/04/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UpdateManager.h"

#define IsAtLeastiOSVersion(X) ([[[UIDevice currentDevice] systemVersion] compare:X options:NSNumericSearch] != NSOrderedAscending)

@implementation UpdateManager

+ (void)nativeUpdateLogic{
  
  NSLog(@"iOS Native // nativeUpdateLogic in!");
  
  NSDictionary * versionDic = [self getDataFrom:@"https://autowaymobile.hyundai.net/version.json"];
  NSString * serverVersion = [versionDic objectForKey:@"version"];
  
  NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  
  NSLog(@"current version : %@",currentVersion);
  NSLog(@"server version : %@",serverVersion);
  
  NSArray * curAppVersion = [UpdateManager strVersionToArray:currentVersion];
  NSArray * serverAppVersion = [UpdateManager strVersionToArray:currentVersion];
  
  BOOL isUpdate = [UpdateManager isUpdate:curAppVersion serverVersion:serverAppVersion];
  
  if(isUpdate){
    NSLog(@"start version update");
    NSString * urlString = [[NSString alloc] init];
    
    //itms-services://?action=download-manifest&url=https://autowaymobile.hmc.co.kr/appstore.app/file/download.bin?filename=hmc_test_app.plist&osCode=iOS
//    urlString = [NSString stringWithFormat:@"%@",@"itms-services://?action=download-manifest&url=https://autowaymobile.hmc.co.kr:443/autoway.app/ios/update/nativeupdatetest_"];
    urlString = [NSString stringWithFormat:@"%@",@"itms-services://?action=download-manifest&url=https://autowaymobile.hyundai.net:443/autoway.app/ios/update/nativeupdatetest_"];

//                 _test_app.plist&osCode=iOS"];
    
    urlString = [urlString stringByAppendingString:serverVersion];
    //urlString = [urlString stringByAppendingString:@".plist"];
    urlString = [urlString stringByAppendingString:@".plist"];
    
    NSLog(@"url string : %@",urlString);
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if(IsAtLeastiOSVersion(@"10.0")){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
          if(!success){
            //불가능한 메시지 출력
            NSLog(@"fail!!!!!!!");
          }else{
            NSLog(@"success!!!!!");
          }
        }];
      }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        //몇초동안 반응없으면 앱설치 안된다고 감지해야함
      }
    });
    
  }else{
    NSLog(@"업데이트 대상이 아닙니다.");
  }
}

+ (NSDictionary *) getDataFrom:(NSString *)baseUrl{
  
  dispatch_semaphore_t sem;
  __block NSDictionary* result = [[NSDictionary alloc] init];
  
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setHTTPMethod:@"GET"];
  [request setURL:[NSURL URLWithString:baseUrl]];
  
  sem = dispatch_semaphore_create(0);
  
  [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
    ^(NSData * _Nullable data,
      NSURLResponse * _Nullable response,
      NSError * _Nullable error) {
    
    NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    
    result = dict;
    
    dispatch_semaphore_signal(sem);
  }] resume];
  
  dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
  
  return result;
}

+ (NSArray *)strVersionToArray:(NSString *) strVersion{
  NSArray* versionArray = [strVersion componentsSeparatedByString:@"."];
  
  while (versionArray.count < 3) {
    NSMutableArray *additinalVersionArray = [NSMutableArray arrayWithArray:versionArray];
    [additinalVersionArray addObject:@"0"];
    return additinalVersionArray;
  }
  
  return versionArray;
}

+ (BOOL) isUpdate:(NSArray *)curVersion serverVersion : (NSArray*)serverVersion{
  
  BOOL isUpdate = NO;
  if(serverVersion[2] > curVersion[2] || serverVersion[1] > curVersion[1] || serverVersion[0] > curVersion[0]){
    isUpdate = YES;
  }
  return isUpdate;
}

+ (NSString *) getiOSNativeVersion{
  NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  return currentVersion;
}

@end
