#import <UIKit/UIKit.h>

@interface bb_RegisterViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField* txtField_Username;
@property (strong, nonatomic) IBOutlet UITextField* txtField_NewPassword;
@property (strong, nonatomic) IBOutlet UITextField* txtField_ConfirmPassword;
@property (strong, nonatomic) IBOutlet UITextField* txtField_EmailAddress;

-(IBAction)didPressRegister:(id)sender;

@end
