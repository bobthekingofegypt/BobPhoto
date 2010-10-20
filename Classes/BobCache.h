//
//  BobCache.h
//  BobPhoto
//
//  Created by Richard Martin on 12/03/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BobCache : NSObject {
    @private
    NSMutableArray *keys;
    NSMutableDictionary *entries;
    NSUInteger capacity_;
    NSLock *lock;
}

-(id) initWithCapacity:(NSUInteger) capacity;
-(id) objectForKey:(NSString *) key;
-(void) addObject:(id) object forKey:(NSString *)key;

@end
