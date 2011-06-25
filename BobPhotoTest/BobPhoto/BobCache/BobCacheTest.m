//
//  BobCacheTest.m
//  BobPhoto
//
//  Created by Richard Martin on 20/06/2011.
//  Copyright 2011 Richard Martin. All rights reserved.
//

#import "BobCacheTest.h"


@implementation BobCacheTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}

#endif

@end
