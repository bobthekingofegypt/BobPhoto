#import "BobImageLoadOperation.h"


@interface BobImageLoadOperation()
-(void)cache:(NSData *)imageData;
-(NSData*) getStoredImage;
@end

@implementation BobImageLoadOperation

@synthesize image = image_, delegate, bobCache;

-(id) initWithPhotoSource:(id<BobPhotoSource>) photoSource {
    self = [super init];
    if (self) {
        photoSource_ = [photoSource retain];
    }
    
    return self;
}

-(void) dealloc {
    [photoSource_ release];
    [image_ release];
    [bobCache release];
    
    [super dealloc];
}

-(void)main {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    CGDataProviderRef dataProvider;
    bool success = NO;
    NSString *mimeType = nil;
    //NSLog(@"%@", [photoSource_ location]);
    if ([[photoSource_ location] hasPrefix:@"http"]) {
        NSData *imageData = [self getStoredImage];
        if (imageData) {
            success = YES;
            dataProvider = CGDataProviderCreateWithCFData((CFDataRef)imageData);
        } else {
            NSURL *url = [NSURL URLWithString:[photoSource_ location]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            NSError *error;
            NSURLResponse *response;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]; 
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            //NSLog(@"Status code %d", [httpResponse statusCode] );
            if ([httpResponse statusCode] == 200) {
                success = YES;
                mimeType = [response MIMEType];
            
                dataProvider = CGDataProviderCreateWithCFData((CFDataRef)result);
            
                [self cache:result];
            }
        }
    } else {

        success = YES;

        dataProvider = CGDataProviderCreateWithFilename([[photoSource_ location] UTF8String]);
    }
    
    if (!success) {
        NSLog(@"No data provider");
        return;
    }
    
    CGImageRef image;
    
    if ([[photoSource_ location] hasSuffix:@".png"] || [mimeType isEqualToString:@"image/png"]) {
        image = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, 
                                         kCGRenderingIntentDefault);
    } else {
        //image = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, NO, 
        //                                 kCGRenderingIntentDefault);
        image = CGImageCreateWithPNGDataProvider(dataProvider, NULL, NO, 
                                                 kCGRenderingIntentDefault);
    }
    
    CGDataProviderRelease(dataProvider);
    
    [self performSelectorOnMainThread:@selector(preloadImage:) 
                           withObject:[NSValue valueWithPointer:image] waitUntilDone:YES];
    
    CGImageRelease(image);
    [pool release];
    
    return;
}

-(void) preloadImage:(NSValue *) value  {
    CGImageRef imageRef = [value pointerValue];
    UIImage *i = nil;
    if ([photoSource_ retina]) {
        i = [UIImage imageWithCGImage:imageRef scale:2.0f orientation:UIImageOrientationUp];
    } else {
        i = [UIImage imageWithCGImage:imageRef];
    }
    [bobCache addObject:i forKey:[photoSource_ location]];
    if (i) {
        [delegate loadImage:i];
    }
}

-(void)cache:(NSData *)imageData {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString* imagesDirectory = [NSString stringWithFormat:@"%@/bobphoto",[paths objectAtIndex:0]];
	
	NSFileManager *fileman = [[NSFileManager alloc] init];
	if (![fileman fileExistsAtPath:imagesDirectory]) {
		[fileman createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}
	[fileman release];
	
    NSString *key = [photoSource_ cacheKey];
	NSString* filenameStr = [imagesDirectory
							 stringByAppendingPathComponent:key];
    
	[imageData writeToFile:filenameStr atomically:YES];
}


-(NSData*) getStoredImage {
	if ([photoSource_ location] == (id)[NSNull null]) return nil;
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
														 NSUserDomainMask, YES); 
	NSString* imagesDirectory = [NSString stringWithFormat:@"%@/bobphoto",[paths objectAtIndex:0]];
    NSString *key = [photoSource_ cacheKey];

	NSString* filenameStr = [imagesDirectory
							 stringByAppendingPathComponent:key];
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSData *imageData = nil;
	
	if ([fileManager fileExistsAtPath:filenameStr]) {
		imageData = [NSData dataWithContentsOfFile:filenameStr];
	}
	
	[fileManager release];
	return imageData;	
}

@end
