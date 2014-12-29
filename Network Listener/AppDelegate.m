//
//  AppDelegate.m
//  Network Listener
//
//  Created by Mateusz Szlosek on 29.12.2014.
//  Copyright (c) 2014 slozo. All rights reserved.
//

#import "AppDelegate.h"

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define NOT_CONNECTED @"NOT_CONNECTED"
#define DISCONNECT_SCRIPT @".networkDisconnected"
#define CONNECT_SCRIPT @".networkConnected"

void launch_script_with_args(NSString *path, NSArray *arguments)
{
    NSTask *scriptToRun = [[NSTask alloc] init];
    [scriptToRun setLaunchPath:path];
    if (arguments)
    {
        [scriptToRun setArguments:arguments];
    }
    [scriptToRun launch];
}

void switch_ssid_to(NSString *SSID)
{
    AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
    
    NSLog(@"Interface changed to: %@", appDelegate.currentSSID);
    
    NSString *changedFrom = [appDelegate.currentSSID copy];
    appDelegate.currentSSID = SSID ? SSID : NOT_CONNECTED;
    
    NSString *homeDir = NSHomeDirectory();
    NSString *programPath = nil;
    NSArray *argArray = nil;
    
    if ([appDelegate.currentSSID isEqualToString:NOT_CONNECTED])
    {
        programPath = [homeDir stringByAppendingPathComponent:DISCONNECT_SCRIPT];
        argArray = @[changedFrom];
    }
    else
    {
        programPath = [homeDir stringByAppendingPathComponent:CONNECT_SCRIPT];
        argArray = @[changedFrom, appDelegate.currentSSID];
    }
    
    launch_script_with_args(programPath, argArray);
}

void wifi_network_changed(SCDynamicStoreRef store, CFArrayRef changedKeys, void *ctx)
{
    [(__bridge NSArray *)changedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         /* Extract the interface name from the changed key */
         NSString *ifName = [key componentsSeparatedByString:@"/"][3];
         CWInterface *iface = [CWInterface interfaceWithName:ifName];
        
         AppDelegate *appDelegate = [[NSApplication sharedApplication] delegate];
         
         NSString *currentSSID = [appDelegate currentSSID];
         
         if (!([currentSSID isEqualToString:iface.ssid] || ([currentSSID isEqualToString:NOT_CONNECTED] && !iface.ssid)))
         {
             switch_ssid_to(iface.ssid);
         }
     }];
}


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    NSLog(@"Starting SSID change daemon.");
    
    CWInterface *WiFiInterface = [CWInterface interface];
    self.currentSSID = [WiFiInterface ssid] ? [WiFiInterface ssid] : NOT_CONNECTED;
    
    // Following code taken form  http://stackoverflow.com/a/15102521/3488699
    
    /* Get a list of all wifi interfaces, and build an array of SCDynamicStore keys to monitor */
    NSSet *wifiInterfaces = [CWInterface interfaceNames];
    NSMutableArray *scKeys = [[NSMutableArray alloc] init];
    [wifiInterfaces enumerateObjectsUsingBlock:^(NSString *ifName, BOOL *stop)
     {
         [scKeys addObject:
          [NSString stringWithFormat:@"State:/Network/Interface/%@/AirPort", ifName]];
     }];
    
    /* Connect to the dynamic store */
    SCDynamicStoreContext ctx = { 0, NULL, NULL, NULL, NULL };
    SCDynamicStoreRef store = SCDynamicStoreCreate(kCFAllocatorDefault,
                                                   CFSTR("myapp"),
                                                   wifi_network_changed,
                                                   &ctx);
    
    /* Start monitoring */
    SCDynamicStoreSetNotificationKeys(store,
                                      (__bridge CFArrayRef)scKeys,
                                      NULL);
    
    CFRunLoopSourceRef src = SCDynamicStoreCreateRunLoopSource(kCFAllocatorDefault, store, 0);
    CFRunLoopAddSource([[NSRunLoop currentRunLoop] getCFRunLoop],
                       src,
                       kCFRunLoopCommonModes);

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    
    NSLog(@"Finishing SSID change daemon.");
}

@end
