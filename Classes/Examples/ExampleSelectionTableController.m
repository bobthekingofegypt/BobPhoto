#import "ExampleSelectionTableController.h"
#import "DiskGalleryController.h"
#import "RemoteGalleryController.h"

@implementation ExampleSelectionTableController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.frame = [[UIScreen mainScreen] bounds];
    self.title = @"Test Selection";
	self.wantsFullScreenLayout = YES;
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
}

-(void) viewWillAppear:(BOOL)animated {	
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


#define kDiskLoadedImages 0
#define kWebLoadedImages 1

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ExampleSelectionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	if (indexPath.row == kDiskLoadedImages) {
		cell.textLabel.text = @"Disk based gallery";
	} else if (indexPath.row == kWebLoadedImages) {
		cell.textLabel.text = @"Web based gallery";
	}
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == kDiskLoadedImages) {
		DiskGalleryController *controller = [[DiskGalleryController alloc] init];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	} else if (indexPath.row == kWebLoadedImages) {
        RemoteGalleryController *controller = [[RemoteGalleryController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}


- (void)dealloc {
    [super dealloc];
}


@end

