//
//  BobCache.m
//  BobPhoto
//
//  Created by Richard Martin on 12/03/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import "BobCache.h"


@implementation BobCache

-(id) initWithCapacity:(NSUInteger) capacity {
    self = [super init];
    if (self) {
        capacity_ = capacity;
        keys = [[NSMutableArray alloc] initWithCapacity:capacity];
        entries = [[NSMutableDictionary alloc] initWithCapacity:capacity];
        
        lock = [[NSLock alloc] init];
    }
    
    return self;
}

-(id) objectForKey:(NSString *) key {
    [lock lock];    
    id object = [entries objectForKey:key];
    //NSLog(@"CACHE reqest for key - %@", key);
    if (object != nil) {
        //NSLog(@"CACHE HIT for key - %@", key);
        [keys removeObject:key];
        [keys insertObject:key atIndex:0];
    }
    [lock unlock];
    return object;
}

-(void) addObject:(id) object forKey:(NSString *)key {
    [lock lock];
    //NSLog(@"add for key - %@", key);
    if (capacity_ == keys.count) {
         
        id lastKey = [keys lastObject];
        [keys removeLastObject];
        [entries removeObjectForKey:lastKey];
         
    }
    
    [keys insertObject:key atIndex:0];
    [entries setValue:object forKey:key];
    [lock unlock];
}

@end
