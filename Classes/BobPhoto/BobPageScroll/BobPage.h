#import <UIKit/UIKit.h>


@interface BobPage : UIView {
	@private
	NSUInteger _index;
	NSString *_reuseIdentifier;
}

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, readonly) NSString *reuseIdentifier;

-(id)initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier;
-(void) prepareForReuse;

@end
