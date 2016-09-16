#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import "CLPlacemark+HNKAdditions.h"


@interface bb_SelectLocationViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

/**
 *  Table View of all locations based on the search query
 */
@property (weak, nonatomic) IBOutlet UITableView* tableView;

/**
 *  Search Bar for searches for a specific location
 */
@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;

/**
 *  Google Places Autocomplete object, that the searchBar text is queried against.
 */
@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery* searchQuery;

/**
 *  Map View to display a pressed location
 */
@property (weak, nonatomic) IBOutlet MKMapView* mapView;

/**
 *  All locations retrieved from the Google Places search query
 */
@property (strong, nonatomic) NSArray* searchResults;

-(IBAction)didSelectDone:(id)sender;

@end
