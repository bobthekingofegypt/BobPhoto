#import "DiskGalleryController.h"
#import "BobPhoto.h"
#import "ThumbnailEntryView.h"
#import "BobPhotoSourceImpl.h"

@interface DiskGalleryController(Private) 
-(BobPhoto *) createBobPhotoWithThumbnail:(NSString *)thumbnail 
									 andImage:(NSString *)image;
-(NSMutableArray *) createPhotoArray;
@end

@implementation DiskGalleryController

-(id) init {
	if ((self = [super initWithPhotos:[self createPhotoArray]])) {
		self.title = @"Disk Gallery";
        self.maximumConcurrentlyLoadingThumbnails = 1;
	}
	return self;
}

-(void) loadView {
	[super loadView];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark 
#pragma mark Photo array setup methods
#pragma mark

-(NSString*) highResVersion:(NSString *)filename {
    NSString *path = [filename pathExtension];
    NSInteger index = [filename length] - ([path length] + 1);
    
    NSString *highDefPath = [NSString stringWithFormat:@"%@@2x%@",[filename substringToIndex:index], [filename substringFromIndex:index]];
    
    return highDefPath;
}

-(NSMutableArray *) createPhotoArray {
    NSMutableArray *photos = [NSMutableArray array];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5212023604_f20ea1fb5d_o_medium.jpg_thumb.png" andImage:@"5212023604_f20ea1fb5d_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5212030714_14f06c4504_o_medium.jpg_thumb.png" andImage:@"5212030714_14f06c4504_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5212033470_abe76aaf15_o_medium.jpg_thumb.png" andImage:@"5212033470_abe76aaf15_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5218372851_b9f657f10c_o_medium.jpg_thumb.png" andImage:@"5218372851_b9f657f10c_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5218380599_1050d95a1e_o_medium.jpg_thumb.png" andImage:@"5218380599_1050d95a1e_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5219074692_5e785d98aa_o_medium.jpg_thumb.png" andImage:@"5219074692_5e785d98aa_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5227347452_13d71ed231_o_medium.jpg_thumb.png" andImage:@"5227347452_13d71ed231_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5241206469_1d5947b243_o_medium.jpg_thumb.png" andImage:@"5241206469_1d5947b243_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5241208111_67eecbf86d_o_medium.jpg_thumb.png" andImage:@"5241208111_67eecbf86d_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5241211391_cf5e79c0c6_o_medium.jpg_thumb.png" andImage:@"5241211391_cf5e79c0c6_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5280561405_5cb743e793_o_medium.jpg_thumb.png" andImage:@"5280561405_5cb743e793_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5280567889_c18cf3a47e_o_medium.jpg_thumb.png" andImage:@"5280567889_c18cf3a47e_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5281165102_4e42d80968_o_medium.jpg_thumb.png" andImage:@"5281165102_4e42d80968_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5281166102_821d06f4a0_o_medium.jpg_thumb.png" andImage:@"5281166102_821d06f4a0_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5281167314_d5d99a1d1f_o_medium.jpg_thumb.png" andImage:@"5281167314_d5d99a1d1f_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5339164464_140552fb63_o_medium.jpg_thumb.png" andImage:@"5339164464_140552fb63_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5346462571_d25e70bd0c_o_medium.jpg_thumb.png" andImage:@"5346462571_d25e70bd0c_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5351281697_7072b78311_o_medium.jpg_thumb.png" andImage:@"5351281697_7072b78311_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5351895342_84711192ec_o_medium.jpg_thumb.png" andImage:@"5351895342_84711192ec_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5372765997_a3c98199a7_o_medium.jpg_thumb.png" andImage:@"5372765997_a3c98199a7_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5372767587_99f165b8dd_o_medium.jpg_thumb.png" andImage:@"5372767587_99f165b8dd_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5393063381_12353314dc_o_medium.jpg_thumb.png" andImage:@"5393063381_12353314dc_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5409932849_876c3e2931_o_medium.jpg_thumb.png" andImage:@"5409932849_876c3e2931_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5417049458_9dd9d93abd_o_medium.jpg_thumb.png" andImage:@"5417049458_9dd9d93abd_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5436649431_9c0d2040c6_o_medium.jpg_thumb.png" andImage:@"5436649431_9c0d2040c6_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5436666157_2f8e6b1256_o_medium.jpg_thumb.png" andImage:@"5436666157_2f8e6b1256_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5436703461_a63a6db043_o_medium.jpg_thumb.png" andImage:@"5436703461_a63a6db043_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5442347311_44b071782e_o_medium.jpg_thumb.png" andImage:@"5442347311_44b071782e_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5443074592_8b2205b7e7_o_medium.jpg_thumb.png" andImage:@"5443074592_8b2205b7e7_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5455333979_fb7d2d4e21_o_medium.jpg_thumb.png" andImage:@"5455333979_fb7d2d4e21_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500158109_557b41fa3d_o_medium.jpg_thumb.png" andImage:@"5500158109_557b41fa3d_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500163871_455c3c81f6_o_medium.jpg_thumb.png" andImage:@"5500163871_455c3c81f6_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500165985_bb74df5a7c_o_medium.jpg_thumb.png" andImage:@"5500165985_bb74df5a7c_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500170839_af09759339_o_medium.jpg_thumb.png" andImage:@"5500170839_af09759339_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500756660_7a78284f88_o_medium.jpg_thumb.png" andImage:@"5500756660_7a78284f88_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500763356_2dc348453d_o_medium.jpg_thumb.png" andImage:@"5500763356_2dc348453d_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500769892_64b6639866_o_medium.jpg_thumb.png" andImage:@"5500769892_64b6639866_o_medium.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500774964_cdd61f55c3_o_medium.jpg_thumb.png" andImage:@"5500774964_cdd61f55c3_o_medium.jpg"]];
    
    [photos addObject:[self createBobPhotoWithThumbnail:@"5212023604_f20ea1fb5d_o_medium_2.jpg_thumb.png" andImage:@"5212023604_f20ea1fb5d_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5212030714_14f06c4504_o_medium_2.jpg_thumb.png" andImage:@"5212030714_14f06c4504_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5212033470_abe76aaf15_o_medium_2.jpg_thumb.png" andImage:@"5212033470_abe76aaf15_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5218372851_b9f657f10c_o_medium_2.jpg_thumb.png" andImage:@"5218372851_b9f657f10c_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5218380599_1050d95a1e_o_medium_2.jpg_thumb.png" andImage:@"5218380599_1050d95a1e_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5219074692_5e785d98aa_o_medium_2.jpg_thumb.png" andImage:@"5219074692_5e785d98aa_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5227347452_13d71ed231_o_medium_2.jpg_thumb.png" andImage:@"5227347452_13d71ed231_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5241206469_1d5947b243_o_medium_2.jpg_thumb.png" andImage:@"5241206469_1d5947b243_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5241208111_67eecbf86d_o_medium_2.jpg_thumb.png" andImage:@"5241208111_67eecbf86d_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5241211391_cf5e79c0c6_o_medium_2.jpg_thumb.png" andImage:@"5241211391_cf5e79c0c6_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5280561405_5cb743e793_o_medium_2.jpg_thumb.png" andImage:@"5280561405_5cb743e793_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5280567889_c18cf3a47e_o_medium_2.jpg_thumb.png" andImage:@"5280567889_c18cf3a47e_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5281165102_4e42d80968_o_medium_2.jpg_thumb.png" andImage:@"5281165102_4e42d80968_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5281166102_821d06f4a0_o_medium_2.jpg_thumb.png" andImage:@"5281166102_821d06f4a0_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5281167314_d5d99a1d1f_o_medium_2.jpg_thumb.png" andImage:@"5281167314_d5d99a1d1f_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5339164464_140552fb63_o_medium_2.jpg_thumb.png" andImage:@"5339164464_140552fb63_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5346462571_d25e70bd0c_o_medium_2.jpg_thumb.png" andImage:@"5346462571_d25e70bd0c_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5351281697_7072b78311_o_medium_2.jpg_thumb.png" andImage:@"5351281697_7072b78311_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5351895342_84711192ec_o_medium_2.jpg_thumb.png" andImage:@"5351895342_84711192ec_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5372765997_a3c98199a7_o_medium_2.jpg_thumb.png" andImage:@"5372765997_a3c98199a7_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5372767587_99f165b8dd_o_medium_2.jpg_thumb.png" andImage:@"5372767587_99f165b8dd_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5393063381_12353314dc_o_medium_2.jpg_thumb.png" andImage:@"5393063381_12353314dc_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5409932849_876c3e2931_o_medium_2.jpg_thumb.png" andImage:@"5409932849_876c3e2931_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5417049458_9dd9d93abd_o_medium_2.jpg_thumb.png" andImage:@"5417049458_9dd9d93abd_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5436649431_9c0d2040c6_o_medium_2.jpg_thumb.png" andImage:@"5436649431_9c0d2040c6_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5436666157_2f8e6b1256_o_medium_2.jpg_thumb.png" andImage:@"5436666157_2f8e6b1256_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5436703461_a63a6db043_o_medium_2.jpg_thumb.png" andImage:@"5436703461_a63a6db043_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5442347311_44b071782e_o_medium_2.jpg_thumb.png" andImage:@"5442347311_44b071782e_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5443074592_8b2205b7e7_o_medium_2.jpg_thumb.png" andImage:@"5443074592_8b2205b7e7_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5455333979_fb7d2d4e21_o_medium_2.jpg_thumb.png" andImage:@"5455333979_fb7d2d4e21_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500158109_557b41fa3d_o_medium_2.jpg_thumb.png" andImage:@"5500158109_557b41fa3d_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500163871_455c3c81f6_o_medium_2.jpg_thumb.png" andImage:@"5500163871_455c3c81f6_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500165985_bb74df5a7c_o_medium_2.jpg_thumb.png" andImage:@"5500165985_bb74df5a7c_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500170839_af09759339_o_medium_2.jpg_thumb.png" andImage:@"5500170839_af09759339_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500756660_7a78284f88_o_medium_2.jpg_thumb.png" andImage:@"5500756660_7a78284f88_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500763356_2dc348453d_o_medium_2.jpg_thumb.png" andImage:@"5500763356_2dc348453d_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500769892_64b6639866_o_medium_2.jpg_thumb.png" andImage:@"5500769892_64b6639866_o_medium_2.jpg"]];
    [photos addObject:[self createBobPhotoWithThumbnail:@"5500774964_cdd61f55c3_o_medium_2.jpg_thumb.png" andImage:@"5500774964_cdd61f55c3_o_medium_2.jpg"]];
    
    return photos;
}

-(BobPhoto *) createBobPhotoWithThumbnail:(NSString *)thumbnail 
									 andImage:(NSString *)image {
    BobPhotoSourceImpl *imagePhotoSource = [[[BobPhotoSourceImpl alloc] init] autorelease];
	imagePhotoSource.imageLocation = [[NSBundle mainBundle] pathForResource:image ofType:nil];
    imagePhotoSource.imageLocationRetina = [[NSBundle mainBundle] pathForResource:[self highResVersion:image] ofType:nil];
    BobPhotoSourceImpl *thumbnailPhotoSource = [[[BobPhotoSourceImpl alloc] init] autorelease];
	thumbnailPhotoSource.imageLocation = [[NSBundle mainBundle] pathForResource:thumbnail ofType:nil];
    thumbnailPhotoSource.imageLocationRetina = [[NSBundle mainBundle] pathForResource:[self highResVersion:thumbnail] ofType:nil];
	
	return [BobPhoto bobPhotoWithThumbnail:thumbnailPhotoSource andImage:imagePhotoSource];
}

@end
