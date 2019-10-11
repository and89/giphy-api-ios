#import "PreviewViewController.h"
#import "GiphyItem.h"
#import "NetworkManager.h"

@interface PreviewViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *preview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.selectedItem.urlFullSize;
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    __weak typeof(self) welf = self;
    [[NetworkManager sharedInstance] requestImageWithUrl:self.selectedItem.urlFullSize withBlock:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            __strong typeof(self) strongRef = welf;
            [strongRef.activityIndicator stopAnimating];
            strongRef.activityIndicator.hidden = YES;
        }];
        
        if (data && !error) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                welf.preview.image = [UIImage imageWithData:data];
            }];
        } else if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
