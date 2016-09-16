#import <UIKit/UIKit.h>

@interface bb_PassengersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tableview;
@property (weak, nonatomic) IBOutlet UILabel* lbl_NoPassengers;

@end
