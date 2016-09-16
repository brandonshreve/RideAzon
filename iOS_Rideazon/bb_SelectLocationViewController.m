#import "bb_SelectLocationViewController.h"
#import "bb_UserConfigSingleton.h"

static NSString* const kSelectAddressSearchResultsCellIdentifier = @"SelectAddressSearchResultsCellIdentifier";

@implementation bb_SelectLocationViewController {
    UIAlertView* _selectLocationAlert;
    bb_UserConfigSingleton* _userConfigSingleton;
    BOOL _selectedALocation;
}

#pragma mark - View Lifecycle
-(void)viewDidLoad {
    [super viewDidLoad];

    _selectedALocation = NO;
    _searchBar.delegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    _userConfigSingleton = [bb_UserConfigSingleton sharedSingleton];
}

#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchResults.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kSelectAddressSearchResultsCellIdentifier forIndexPath:indexPath];

    HNKGooglePlacesAutocompletePlace* thisPlace = _searchResults[indexPath.row];
    cell.textLabel.text = thisPlace.name;
    return cell;
}

#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];

    HNKGooglePlacesAutocompletePlace* selectedPlace = _searchResults[indexPath.row];


    [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                       apiKey: _searchQuery.apiKey
                                   completion:^(CLPlacemark* placemark, NSString* addressString, NSError* error) {
                                       if (placemark) {
                                           [_tableView setHidden: YES];
                                           [self addPlacemarkAnnotationToMap:placemark addressString:addressString];
                                           [self recenterMapToPlacemark:placemark];
                                           [_tableView deselectRowAtIndexPath:indexPath animated:NO];
                                       }
                                   }];
}

#pragma mark - UISearchBar Delegate
-(void)searchBarTextDidBeginEditing:(UISearchBar*)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString*)searchText {
    if(searchText.length > 0) {
        [_tableView setHidden:NO];

        [_searchQuery fetchPlacesForSearchQuery: searchText
                                         completion:^(NSArray *places, NSError *error) {
                                             if (error) {
                                                 NSLog(@"ERROR: %@", error);
                                                 [self handleSearchError:error];
                                             } else {
                                                 _searchResults = places;
                                                 [_tableView reloadData];
                                             }
                                         }];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar {
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [_tableView setHidden:YES];
}

#pragma mark - Helpers
-(void)addPlacemarkAnnotationToMap:(CLPlacemark*)placemark addressString:(NSString*)address {
    [_mapView removeAnnotations:_mapView.annotations];

    MKPointAnnotation* annotation = [MKPointAnnotation new];
    annotation.coordinate = placemark.location.coordinate;
    annotation.title = address;

    NSNumber* longitude = [NSNumber numberWithDouble:placemark.location.coordinate.longitude];
    NSNumber* latitude = [NSNumber numberWithDouble:placemark.location.coordinate.latitude];

    _userConfigSingleton.locationToSave.locationCoordinates.coordinatesLatitude = [latitude stringValue];
    _userConfigSingleton.locationToSave.locationCoordinates.coordinatesLongitude = [longitude stringValue];

    NSArray* addressAttributes = [address componentsSeparatedByString:@","];

    _userConfigSingleton.locationToSave.locationAddress.addressDescription = address;

    // If the location has full location information, add that information.
    if (addressAttributes.count == 4) {
        NSArray* addressZipAndState = [addressAttributes[2] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray* addressStreet = [addressAttributes[0] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

        if (addressStreet.count >= 3) {
            _userConfigSingleton.locationToSave.locationAddress.addressStreetNumber = addressStreet[0];
            _userConfigSingleton.locationToSave.locationAddress.addressStreetName = addressStreet[2];
        }
        _userConfigSingleton.locationToSave.locationAddress.addressCity = addressAttributes[1];
        _userConfigSingleton.locationToSave.locationAddress.addressCountry = addressAttributes[3];

        if (addressZipAndState.count >= 3) {
            _userConfigSingleton.locationToSave.locationAddress.addressPostalCode = addressZipAndState[2];
            _userConfigSingleton.locationToSave.locationAddress.addressState = addressZipAndState[1];
        }
    }

    [_mapView addAnnotation:annotation];

    _selectedALocation = YES;
}

-(void)recenterMapToPlacemark:(CLPlacemark*)placemark {
    MKCoordinateRegion region;
    MKCoordinateSpan span;

    span.latitudeDelta = 0.02;
    span.longitudeDelta = 0.02;

    region.span = span;
    region.center = placemark.location.coordinate;

    [_mapView setRegion:region animated:YES];
}

-(void)handleSearchError:(NSError*)error {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - User Actions
-(IBAction)didSelectDone:(id)sender {
    if (_selectedALocation) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        _selectLocationAlert = [[UIAlertView alloc] initWithTitle:@"Select a Location" message:@"No location is currently selected" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [_selectLocationAlert show];
    }
}

@end