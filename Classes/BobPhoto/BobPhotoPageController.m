#import "BobPhotoPageController.h"
#import "BobPageImage.h"
#import "BobDiskPhoto.h"
#import "BobPhotoPage.h"

@implementation BobPhotoPageController

@synthesize operationQueue;

-(id) initWithPhotos:(NSMutableArray *)photos andCurrentIndex:(NSUInteger)index {
    self = [super init];
	if (self) {
		_photos = [photos retain];
        _photoOperations = [[NSMutableDictionary alloc] init];
        bobCache = [[BobCache alloc] initWithCapacity:3];
		
		currentIndex = index;
	}
	
	return self;
}

- (void)dealloc {
	[_bobPageScrollView release];
	[_photos release];
    [_photoOperations release];
    [super dealloc];
}

-(void) loadView {
	[super loadView];	
	[self setWantsFullScreenLayout:YES];
	
	_bobPageScrollView = [[BobPageScrollView alloc] initWithFrame:CGRectMake(0.0f,0.0f,self.view.frame.size.width, self.view.frame.size.height)];
	_bobPageScrollView.padding = 10.0f;
	_bobPageScrollView.datasource = self;
	_bobPageScrollView.currentIndex = currentIndex;
	
	[self.view addSubview:_bobPageScrollView];
	
	[_bobPageScrollView reloadData];
}

-(void) setCurrentIndex:(NSUInteger)index {
	[_bobPageScrollView reloadData];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//	
//	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//	
///}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
										 duration:(NSTimeInterval)duration {
	//[_bobPageScrollView reloadData];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [_bobPageScrollView reloadData];
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark -
#pragma mark BobPageScrollViewDatasource methods

-(NSUInteger) numberOfPages {
	return [_photos count];
}

-(BobPage *) bobPageScrollView:(BobPageScrollView *)bobPageScrollView pageForIndex:(NSUInteger)index {
	static NSString *reuseIdentifier = @"PhotoPage";
	NSLog(@"TEST %d", index);
	BobPhotoPage *page = (BobPhotoPage *)[bobPageScrollView dequeueReusablePageWithIdentifier:reuseIdentifier];
	if (!page) {
		page = [[[BobPhotoPage alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f) andReuseIdentifier:reuseIdentifier] autorelease];
        page.bobCache = bobCache;
        page.operationQueue = operationQueue;
	}
	
	BobDiskPhoto *photo = (BobDiskPhoto *)[_photos objectAtIndex:index];
    //BobDiskLoadOperation *bobDiskLoadOperation = (BobDiskLoadOperation *)[_photoOperations objectForKey:[NSNumber numberWithInt:index]];
   
    
    [page setPath:[photo imageLocation]];
	
	return page;
}

@end
