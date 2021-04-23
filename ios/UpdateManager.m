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
  
  
  NSDictionary * test = [[NSBundle mainBundle] infoDictionary];
  
  
  NSString * currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  
  NSLog(@"current version : %@",currentVersion);
  NSLog(@"server version : %@",serverVersion);
  
  //if(currentVersion < serverVersion){
  if([currentVersion isEqual:@"1.0.0"] || [currentVersion isEqual:@"1.0"]){
    NSLog(@"start version update");
    
    NSString * urlString = [[NSString alloc] init];
    //        urlString = [NSString stringWithFormat:@"%@%@%@",@"https://autowayapps.hyundai.net/appstore/app/downloadApp.bin?osCode=iOS&file=updatetest_",serverVersion,@".ipa"];
    urlString = [NSString stringWithFormat:@"%@",@"https://autowayapps.hyundai.net/appstore/app/downloadApp.bin?osCode=iOS&file=hmg_test_app.ipa"];
    NSLog(@"url string : %@",urlString);
    
    
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

@end
