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

-(void) dealloc {
    [keys release];
    [entries release];
    [lock release];
    
    [super dealloc];
}

-(void) clear {
    [lock lock];
    [keys removeAllObjects];
    [entries removeAllObjects];
    [lock unlock];
}

-(id) objectForKey:(NSString *) key {
    [lock lock];    
    id object = [entries objectForKey:key];
    if (object != nil) {
        [keys removeObject:key];
        [keys insertObject:key atIndex:0];
    }
    [lock unlock];
    return object;
}

-(void) addObject:(id) object forKey:(NSString *)key {
    [lock lock];
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
