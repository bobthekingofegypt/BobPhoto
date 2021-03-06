#import "BobPhotoPageController.h"
//#import "BobPageImage.h"
#import "BobPhoto.h"
#import "BobPhotoPage.h"

@protocol UIApplicationDeprecatedMethods
- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
@end

@interface BobPhotoPageController()
-(void) setupArrows;
-(void) updateChrome;
-(void) setPageTitle;
@end

@implementation BobPhotoPageController

@synthesize operationQueue, bobThumbnailCache;

-(id) initWithPhotos:(NSMutableArray *)photos andCurrentIndex:(NSUInteger)index {
    self = [super init];
	if (self) {
		photos_ = [photos retain];
        bobCache = [[BobCache alloc] initWithCapacity:3];
		
		currentIndex = index;
        showingChrome = YES;
	}
	
	return self;
}

- (void)dealloc {
    [left release];
    [play release];
    [right release];
    [bobCache release];
    [operationQueue release];
	[bobPageScrollView_ release];
	[photos_ release];
    [super dealloc];
}

#pragma mark
#pragma mark View lifecycle methods 
#pragma mark

-(void) loadView {
	[super loadView];	
	[self setWantsFullScreenLayout:YES];
    
	bobPageScrollView_ = [[BobPagedScrollView alloc] initWithFrame:CGRectMake(0.0f,0.0f,self.view.frame.size.width, self.view.frame.size.height)];
	bobPageScrollView_.padding = 10.0f;
	bobPageScrollView_.datasource = self;
    bobPageScrollView_.delegate = self;
    [bobPageScrollView_ scrollToPage:currentIndex animated:NO];
    [bobPageScrollView_ reloadData];
   
	[self.view addSubview:bobPageScrollView_];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonPressed)];
    play = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play.png"] style:UIBarButtonItemStylePlain target:self action:@selector(playSlideShow)];
    right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonPressed)];
    self.toolbarItems = [NSArray arrayWithObjects:space, left, space, play, space, right, space, nil];
    
    [space release];
    [self setupArrows];
    [self setPageTitle];
}

-(void) viewWillAppear:(BOOL)animated {
    [bobPageScrollView_ reloadData];
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark
#pragma mark Autorotation methods
#pragma mark

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark
#pragma mark Interaction button and title methods
#pragma mark

-(void) setPageTitle {
    self.title = [NSString stringWithFormat:@"%d of %d", currentIndex + 1, [photos_ count]];
}

-(void) setupArrows {
    [self setPageTitle];
    left.enabled = YES;
    right.enabled = YES;
    if (currentIndex == 0) {
        left.enabled = NO;
    } 
    if (currentIndex == ([photos_ count] - 1)) {
        right.enabled = NO;
    }
}

-(void) leftButtonPressed {
    if (currentIndex  > 0) {
        currentIndex = currentIndex - 1;
        [bobPageScrollView_ scrollToPage:(currentIndex) animated:NO];
        [self setupArrows];
    }
}

-(void) rightButtonPressed {
    if (currentIndex  < ([photos_ count] - 1)) {
        currentIndex = currentIndex + 1;
        [bobPageScrollView_ scrollToPage:(currentIndex) animated:NO];
        [self setupArrows];
    }
}

-(void) changePage {
    playingSlideshow = YES;
    [self rightButtonPressed];
}

-(void) playSlideShow {
    if (playingSlideshow) {
        if (slideshowTimer) {
            [slideshowTimer invalidate];
            [slideshowTimer release], slideshowTimer = nil;
            playingSlideshow = NO;
        }
    } else {
        if (!slideshowTimer) {
            slideshowTimer = [[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changePage) userInfo:nil repeats:YES] retain];
        }
        [play setImage:[UIImage imageNamed:@"pause.png"]];
        showingChrome = NO;
        [self updateChrome];
        playingSlideshow = YES;
    }
}

-(void) setCurrentIndex:(NSUInteger)index {
	[bobPageScrollView_ reloadData];
}

-(void) bobPagedScrollView:(BobPagedScrollView *)bobPageScrollView settledOnPage:(NSUInteger) index {
    currentIndex = index;
    [self setupArrows];
}



-(void) updateChrome {
    if([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide]; 
    } else { 
        id<UIApplicationDeprecatedMethods> app = (id)[UIApplication sharedApplication];
        [app setStatusBarHidden:!showingChrome animated:YES];
    }
    [self.navigationController setNavigationBarHidden:!showingChrome animated:YES];
    [self.navigationController setToolbarHidden:!showingChrome animated:YES];
}

#pragma mark -
#pragma mark BobPageScrollViewDatasource methods

-(NSUInteger) numberOfPages {
	return [photos_ count];
}

-(BobPage *) bobPagedScrollView:(BobPagedScrollView *)bobPageScrollView pageForIndex:(NSUInteger)index {
	static NSString *reuseIdentifier = @"PhotoPage";
	BobPhotoPage *page = (BobPhotoPage *)[bobPageScrollView dequeueReusablePageWithIdentifier:reuseIdentifier];
	if (!page) {
        page = [[[BobPhotoPage alloc] initWithFrame:CGRectMake(0.0f,0.0f,self.view.frame.size.width, self.view.frame.size.height) andReuseIdentifier:reuseIdentifier] autorelease];
        page.bobCache = bobCache;
        page.bobThumbnailCache = bobThumbnailCache;
        page.operationQueue = operationQueue;
        page.touchDelegate = self;
	}
	
	BobPhoto *photo = (BobPhoto *)[photos_ objectAtIndex:index];
    [page setPhoto:photo];
    
	
	return page;
}

-(void) photoViewTouched:(BobPhotoPage *)bobPhotoPage {
    showingChrome = showingChrome ? NO : YES;
    
    if (slideshowTimer) {
        [slideshowTimer invalidate];
        [slideshowTimer release], slideshowTimer = nil;
        playingSlideshow = NO;
        [play setImage:[UIImage imageNamed:@"play.png"]];
    }
    
    [self updateChrome];
}

@end
