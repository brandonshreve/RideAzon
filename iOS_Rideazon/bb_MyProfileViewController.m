#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "bb_MyProfileViewController.h"
#import "bb_UserConfigSingleton.h"
#import "bb_EventEntity.h"

@implementation bb_MyProfileViewController {
    bb_UserConfigSingleton* _userSingleton;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    _userSingleton = [bb_UserConfigSingleton sharedSingleton];

    NSURL* pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", _userSingleton.currentLoggedInUser.userFacebookID]];
    NSData* imageData = [NSData dataWithContentsOfURL:pictureURL];
    UIImage* fbImage = [UIImage imageWithData:imageData];

    _imgView_ProfilePicture.image = fbImage;
    _txtField_Email.text = _userSingleton.currentLoggedInUser.userEmail;
    _txtField_UserName.text = _userSingleton.currentLoggedInUser.userName;

    NSDateFormatter* dateFormatter = [bb_EventEntity getLocalDateFormatterForModel];
    _txtField_CreatedOn.text = [dateFormatter stringFromDate:_userSingleton.currentLoggedInUser.userCreatedOn];

    _imgView_ProfilePicture.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _imgView_ProfilePicture.layer.cornerRadius = 65;
    _imgView_ProfilePicture.layer.borderWidth = 0.5;
    _imgView_ProfilePicture.layer.masksToBounds = YES;
    _imgView_ProfilePicture.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    // Setting up Facebook Login Button
    FBSDKLoginButton* loginButton = [FBSDKLoginButton new];
    loginButton.delegate = self;
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];

    CGPoint someCenter = self.view.center;
    someCenter.y += 200;

    loginButton.center = someCenter;
    [self.view addSubview:loginButton];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FBSDKLoginButtonDelegate
-(void)loginButton:(FBSDKLoginButton*)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult*)result error:(NSError*)error {
    // Do nothing. There should be no logging in within this view.
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton*)loginButton {
    // User logged out. Pop views off stack back to root view.
    [self.navigationController popViewControllerAnimated:YES];
}

@end
