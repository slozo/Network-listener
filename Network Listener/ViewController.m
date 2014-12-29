//
//  ViewController.m
//  Network Listener
//
//  Created by Mateusz Szlosek on 29.12.2014.
//  Copyright (c) 2014 slozo. All rights reserved.
//

#import "ViewController.h"

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>
#import <SystemConfiguration/SystemConfiguration.h>

void wifi_network_changed(SCDynamicStoreRef store, CFArrayRef changedKeys, void *ctx)
{
    [(__bridge NSArray *)changedKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         /* Extract the interface name from the changed key */
         NSString *ifName = [key componentsSeparatedByString:@"/"][3];
         CWInterface *iface = [CWInterface interfaceWithName:ifName];
         
         NSLog(@"%@ status changed: current ssid is %@, security is %ld",
               ifName, iface.ssid, iface.security);
     }];
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
