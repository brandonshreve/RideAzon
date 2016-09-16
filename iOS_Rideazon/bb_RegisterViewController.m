#import "bb_RegisterViewController.h"

@implementation bb_RegisterViewController

-(void)viewDidLoad {
    NSLog(@"View Loaded");
}

//Once the user clicks the button we need to make sure that all of the textfields contain the proper data
//TODO: If the fields are not properly filled out then do not seque
- (IBAction)didPressRegister:(id)sender {
    NSLog(@"Entered didPressRegister");

    NSString *potentialUsername;
    NSString *potentialNewPassword;
    NSString *email;


    //Check the text fields for Errors that do not require the database
    //Username should be atleast 8 digits long
    if([self.txtField_Username.text length] >= 8 || self.txtField_Username != nil || [self.txtField_Username isEqual:@""] == FALSE)
    {
        potentialUsername = self.txtField_Username.text;
    }
    else{
        NSLog(@"Error: username does not meet necessary criteria");

    }

    //New Password should be at least 8 characters long...not necessarily alphanumeric
    //If the password is not empty and is equal to the confirm password text field
    if(([self.txtField_NewPassword.text length] >= 8 || self.txtField_NewPassword != nil || [self.txtField_NewPassword isEqual:@""] == FALSE) && [self.txtField_NewPassword isEqual:self.txtField_ConfirmPassword] == TRUE)
    {
        potentialNewPassword = self.txtField_NewPassword.text;
    }
    else{
        NSLog(@"Error: password does not meet criteria");
    }

    //Email address must not be nil.
    //TODO verify the email address.
    if([self.txtField_Username.text length] > 0 || self.txtField_Username != nil || [self.txtField_Username isEqual:@""] == FALSE)
    {
        email = self.txtField_EmailAddress.text;
    }
    else{
        NSLog(@"Error: email address field does not contain a valid email address");
    }

    //Do DB call all at one time to save time and check all of the fields
    //Check if user name is already taken
    //If not then add the user name, with password and email address
}

//If there is anything that needs to be done before moving to the next view controller do it here
//Such as passing data etc.
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    NSLog(@"Prepare for segue");
//
//
//
//}

@end
