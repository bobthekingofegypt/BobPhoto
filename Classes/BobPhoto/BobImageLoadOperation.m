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
    NSString *mimeType = nil;
    
    if ([[photoSource_ location] hasPrefix:@"http"]) {
        NSData *imageData = [self getStoredImage];
        if (imageData) {
            dataProvider = CGDataProviderCreateWithCFData((CFDataRef)imageData);
        } else {
            NSURL *url = [NSURL URLWithString:[photoSource_ location]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            NSError *error;
            NSURLResponse *response;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]; 
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            mimeType = [response MIMEType];
            
            dataProvider = CGDataProviderCreateWithCFData((CFDataRef)result);
            
            [self cache:result];
        }
    } else {
        dataProvider = CGDataProviderCreateWithFilename([[photoSource_ location] UTF8String]);
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
    [delegate loadImage:i];
}

-(void)cache:(NSData *)imageData {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
	NSString* imagesDirectory = [NSString stringWithFormat:@"%@/bobphoto",[paths objectAtIndex:0]];
	
	NSFileManager *fileman = [[NSFileManager alloc] init];
	if (![fileman fileExistsAtPath:imagesDirectory]) {
		[fileman createDirectoryAtPath:imagesDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}
	[fileman release];
	
	NSString *withoutHTTP = [[photoSource_ location] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	NSString *withoutSlash = [withoutHTTP stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
	NSString* filenameStr = [imagesDirectory
							 stringByAppendingPathComponent:withoutSlash];
    
	[imageData writeToFile:filenameStr atomically:YES];
}


-(NSData*) getStoredImage {
	if ([photoSource_ location] == (id)[NSNull null]) return nil;
	
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
														 NSUserDomainMask, YES); 
	NSString* imagesDirectory = [NSString stringWithFormat:@"%@/bobphoto",[paths objectAtIndex:0]];
	NSString *withoutHTTP = [[photoSource_ location] stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	NSString *withoutSlash = [withoutHTTP stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	NSString* filenameStr = [imagesDirectory
							 stringByAppendingPathComponent:withoutSlash];
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	NSData *imageData = nil;
	
	if ([fileManager fileExistsAtPath:filenameStr]) {
		imageData = [NSData dataWithContentsOfFile:filenameStr];
	}
	
	[fileManager release];
	return imageData;	
}

@end
