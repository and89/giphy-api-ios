#import "MainViewController.h"
#import "ResultTableViewController.h"
#import "ItemManager.h"

static NSString * const kShowResultSegue = @"showResultSegue";

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.activityIndicator.hidden = YES;
}

- (IBAction)didTapButton:(id)sender {
	
	if (!self.searchText.text.length) {
		return;
	}
	
	self.searchButton.enabled = NO;
	self.activityIndicator.hidden = NO;
	[self.activityIndicator startAnimating];
	[[ItemManager sharedInstance] cleanUp];
	__weak typeof(self) welf = self;
	[[ItemManager sharedInstance] requestItemsWithName:self.searchText.text andResultBlock:^(NSArray<GiphyItem *> *items, NSError *error) {
		[[NSOperationQueue mainQueue] addOperationWithBlock:^{
			__strong typeof(self) strongRef = welf;
			[strongRef.activityIndicator startAnimating];
			strongRef.activityIndicator.hidden = YES;
			strongRef.searchButton.enabled = YES;
		}];
		
		if (items.count) {
			[[NSOperationQueue mainQueue] addOperationWithBlock:^{
				[welf performSegueWithIdentifier:kShowResultSegue sender:self];
			}];
			
		}
	}];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	UIViewController *dest = segue.destinationViewController;
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		dest.navigationItem.title = self.searchText.text;
	}];
}

@end
