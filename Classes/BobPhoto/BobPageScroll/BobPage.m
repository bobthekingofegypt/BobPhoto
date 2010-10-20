#import "BobPage.h"


@implementation BobPage

@synthesize index = _index, reuseIdentifier = _reuseIdentifier;

- (id)initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:frame])) {
        _reuseIdentifier = [reuseIdentifier copy];
    }
    return self;
}

-(void) prepareForReuse {
	
}

- (void)dealloc {
	[_reuseIdentifier release];
    [super dealloc];
}


@end
