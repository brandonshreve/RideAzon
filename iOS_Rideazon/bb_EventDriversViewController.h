#import <UIKit/UIKit.h>

@interface bb_EventDriversViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UILabel* lbl_NoDrivers;

@end
