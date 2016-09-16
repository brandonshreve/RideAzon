#import <UIKit/UIKit.h>

@interface bb_MyProfileViewController : UIViewController <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UITextField* txtField_CreatedOn;
@property (weak, nonatomic) IBOutlet UITextField* txtField_Email;
@property (weak, nonatomic) IBOutlet UITextField* txtField_UserName;
@property (weak, nonatomic) IBOutlet UIImageView* imgView_ProfilePicture;
@property (weak, nonatomic) IBOutlet UIView* facebookButtonPlaceholder;

@end
