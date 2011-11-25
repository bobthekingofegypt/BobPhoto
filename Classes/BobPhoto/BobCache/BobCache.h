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
-(void) clear;

@end
