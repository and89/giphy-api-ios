#import "ResultTableViewController.h"
#import "ResultTableViewCell.h"
#import "PreviewViewController.h"
#import "ItemManager.h"
#import "ImageManager.h"
#import "CellPresenter.h"
#import "GiphyItem.h"

static NSString * const kShowFullSizeSegue = @"showFullSizeSegue";
static NSString * const kCellIdentifier = @"previewCell";
static const CGFloat kCellHeight = 200.0f;

@interface ResultTableViewController ()

@property (atomic, assign) BOOL loadMoreInited;
@property (nonatomic, strong) GiphyItem *selectedItem;
@property (nonatomic, strong) NSMutableDictionary<NSString *, CellPresenter *> *presenters;

- (void)checkLoadMoreForIndexPath:(NSIndexPath *)path;

@end

@implementation ResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.loadMoreInited = false;
	self.selectedItem = nil;
	self.presenters = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [ItemManager sharedInstance].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
	
	GiphyItem *item = [[ItemManager sharedInstance] itemForIndexPath:indexPath];
	CellPresenter *presenter = self.presenters[item.ident];
	if (!presenter) {
		presenter = [[CellPresenter alloc] init];
		presenter.item = item;
		[self.presenters setObject:presenter forKey:item.ident];
	}
	presenter.cell = cell;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	GiphyItem *item = [[ItemManager sharedInstance] itemForIndexPath:indexPath];
	CellPresenter *presenter = self.presenters[item.ident];
	presenter.cell = (ResultTableViewCell *)cell;
	[presenter configureCell];
	[self checkLoadMoreForIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	GiphyItem *item = [[ItemManager sharedInstance] itemForIndexPath:indexPath];
	CellPresenter *presenter = self.presenters[item.ident];
	presenter.cell = nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	self.selectedItem = [[ItemManager sharedInstance] itemForIndexPath:indexPath];
	[self performSegueWithIdentifier:kShowFullSizeSegue sender:self];
}

- (void)checkLoadMoreForIndexPath:(NSIndexPath *)path {
	CGFloat currentItem = path.row;
	CGFloat allItems = [ItemManager sharedInstance].items.count;
	BOOL needLoadMore = currentItem > allItems * 0.7f;
	if (needLoadMore && !self.loadMoreInited) {
		self.loadMoreInited = YES;
		__weak typeof(self) welf = self;
		[[ItemManager sharedInstance] loadMoreItemsWithResultBlock:^(NSArray<GiphyItem *> *items, NSError *error) {
			if (items.count) {
				[[NSOperationQueue mainQueue] addOperationWithBlock:^{
					[welf.tableView reloadData];
				}];
			}
			welf.loadMoreInited = NO;
		}];
	}
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
	PreviewViewController *dest = segue.destinationViewController;
	dest.selectedItem = self.selectedItem;
}

@end
