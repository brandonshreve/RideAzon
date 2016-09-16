#import "bb_LoginViewController.h"
#import "bb_EventsViewController.h"
#import "bb_UserConfigSingleton.h"
#import "bb_ServiceManager.h"

@implementation bb_LoginViewController {
    NSString* _userNameToSave;
    NSString* _emailToSave;
    NSString* _facebookID;
    UIAlertView* _alertView;
    BOOL _alertViewIsPresented;

    bb_UserConfigSingleton* _userConfigSingleton;
    bb_EventsViewController* _searchView;
    bb_ServiceManager* _serviceManager;
    BOOL _seguedHasOccured;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    _userConfigSingleton = [bb_UserConfigSingleton sharedSingleton];
    _serviceManager = [bb_ServiceManager new];
    _userNameToSave = [NSString new];
    _emailToSave = [NSString new];
    _facebookID = [NSString new];
    _alertViewIsPresented = NO;

    // Setting up Facebook Login Button
    FBSDKLoginButton* loginButton = [FBSDKLoginButton new];
    loginButton.delegate = self;
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];

    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];

    _seguedHasOccured = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [_activityIndicator stopAnimating];

    _seguedHasOccured = NO;

    if ([FBSDKAccessToken currentAccessToken]) {
        [_activityIndicator startAnimating];

        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setValue:@"id,name,email" forKey:@"fields"];

        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection* connection,
                                      id result, NSError* error) {

             _userNameToSave = result[@"name"];
             _emailToSave = result[@"email"];
             _userNameToSave = [_userNameToSave stringByReplacingOccurrencesOfString:@" " withString:@""];
             _facebookID = result[@"id"];

             // Verify user is registered with Rideazon
             if ([_serviceManager isUserRegistered:_userNameToSave] && !_seguedHasOccured) {
                 // Populate information for logged in user
                [_serviceManager getUserInfoFromFacebookID:_userNameToSave];
                _userConfigSingleton.currentLoggedInUser.userFacebookID = _facebookID;
                [self performSegueWithIdentifier:@"showEvents" sender:self];
                 _seguedHasOccured = YES;
             }
             else { // Ask if user would like to be registered
                 NSString* alertMessage = [NSString stringWithFormat:@"Hello, %@. It appears you have not registered with Rideazon. You will be registered if you proceed.", _userNameToSave];

                 _alertView = [[UIAlertView alloc] initWithTitle:@"Registration" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];

                 if (!_alertViewIsPresented) {
                     _alertViewIsPresented = YES;
                     [_alertView show];
                 }
             }
         }];
    }
}

#pragma mark - FBSDKLoginButtonDelegate
-(void)loginButton:(FBSDKLoginButton*)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult*)result error:(NSError*)error {
    if (!error) {
        if ([FBSDKAccessToken currentAccessToken]) {
            [_activityIndicator startAnimating];

            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,first_name, last_name"}]

             startWithCompletionHandler:^(FBSDKGraphRequestConnection* connection, id result, NSError* error) {
                 if (!error) {
                     _userNameToSave = [NSString stringWithFormat:@"%@%@", result[@"first_name"], result[@"last_name"]];
                     _emailToSave = result[@"email"];
                     _facebookID = result[@"id"];

                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                         // Verify user is registered with Rideazon
                         if ([_serviceManager isUserRegistered:_userNameToSave] && !_seguedHasOccured) {
                             // Populate information for logged in user
                             [_serviceManager getUserInfoFromFacebookID:_userNameToSave];
                             _userConfigSingleton.currentLoggedInUser.userFacebookID = _facebookID;
                             [self performSegueWithIdentifier:@"showEvents" sender:self];
                             _seguedHasOccured = YES;
                         }
                         else { // Ask if user would like to be registered
                             NSString* alertMessage = [NSString stringWithFormat:@"Hello, %@. It appears you have not registered with Rideazon. You will be registered if you proceed.", _userNameToSave];

                             _alertView = [[UIAlertView alloc] initWithTitle:@"Registration" message:alertMessage delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Okay", nil];

                             if (!_alertViewIsPresented && !_seguedHasOccured) {
                                _alertViewIsPresented = YES;
                               [_alertView show];
                             }
                         }
                     });

                 }
             }];
        }
    }
    else if (result.isCancelled) {
        // To something about user canceling login
    }
    else {
        // Error occured
    }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton*)loginButton {
    // User logged out
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (!_seguedHasOccured) {
            // User refused registration, so we should log them out of Facebook
            FBSDKLoginManager* loginManager = [FBSDKLoginManager new];
            [loginManager logOut];

            [_activityIndicator stopAnimating];
        }
    }
    else {
        // User agreed to have be registered... so... do it.
        bb_UserEntity* newUser = [bb_UserEntity new];
        newUser.userName = _userNameToSave;
        newUser.userEmail = _emailToSave;

        [_serviceManager registerUser:newUser];

        if (!_seguedHasOccured) {
            [self performSegueWithIdentifier:@"showEvents" sender:self];
            _seguedHasOccured = YES;
        }
    }
    _alertViewIsPresented = NO;
}


@end