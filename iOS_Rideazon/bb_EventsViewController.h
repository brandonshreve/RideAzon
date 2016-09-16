#import <UIKit/UIKit.h>

@interface bb_EventsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tableview;

@end
