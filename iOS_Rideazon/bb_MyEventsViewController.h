#import <UIKit/UIKit.h>

@interface bb_MyEventsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView* tableview;

@end