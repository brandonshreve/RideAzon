#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import "bb_UserEntity.h"

@interface bb_LoginViewController : UIViewController <FBSDKLoginButtonDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) bb_UserEntity* user;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activityIndicator;

@end
