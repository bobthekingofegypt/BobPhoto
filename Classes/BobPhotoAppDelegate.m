#import "BobPhotoAppDelegate.h"
#import "ExampleSelectionTableController.h"

@implementation BobPhotoAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	ExampleSelectionTableController *exampleSelectionTableController = 
                                        [[ExampleSelectionTableController alloc] initWithStyle:UITableViewStylePlain];
	exampleNavigationController = [[UINavigationController alloc] initWithRootViewController:exampleSelectionTableController];
	[exampleSelectionTableController release];
	
	[window addSubview:exampleNavigationController.view];
    [window makeKeyAndVisible];
	
	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"MEMORY WARNING !!!!!!!");
}


- (void)dealloc {
	[exampleNavigationController release];
    [window release];
    [super dealloc];
}


@end
