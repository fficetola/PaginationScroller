//
//  ViewController.m
//  PaginationScroller
//


#import "ViewController.h"
#import "Object.h"
#import "ASIHTTPRequest.h"

const int numberCells = 20;

@interface ViewController ()
@property (nonatomic, retain) NSMutableArray *objects;

@end

@implementation ViewController

@synthesize objects = _objects;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.objects = [NSMutableArray array];
    _lastIndex = 0;
    
    
    [self loadData];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [_objects release];
    
    [super dealloc];
}

#pragma mark - UITableViewDatasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Object *object = [self.objects objectAtIndex:indexPath.row];
    cell.textLabel.text = object.name;
    cell.detailTextLabel.text = object.description;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //check last cell in uitable
    if(indexPath.row==self.objects.count-1){
        
        //Create and add the Activity Indicator to splashView
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.alpha = 1.0;
        //activityIndicator.center = CGPointMake(160, 360);
        activityIndicator.hidesWhenStopped = NO;
        [activityIndicator startAnimating];
        
        self.tableView.tableFooterView = activityIndicator;
        
        //arrest condition
         if(_currentPage<_totalPages){
             
             _lastIndex = indexPath.row+1;
             //timer...
             [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadData) userInfo:nil repeats:NO];
             
         }
         else{
             [activityIndicator stopAnimating];
             self.tableView.tableFooterView = nil;
         }
         
         [activityIndicator release];

    }
}

#pragma mark - fetching

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
     NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    NSData *responseData = request.responseData;
    
    NSDictionary *responsejson = [NSJSONSerialization
                             JSONObjectWithData:responseData
                             options:kNilOptions error:nil];
    
    NSLog(@"responsejson %@", responsejson);
    
    _totalPages = [[responsejson objectForKey:@"total_pages"] intValue];
    _currentPage = [[responsejson objectForKey:@"current_page"] intValue];
    
    for (id objectDictionary in [responsejson objectForKey:@"objects"]) {
        Object *object = [[Object alloc] initWithDictionary:objectDictionary];
        if (![self.objects containsObject:object]) {
            [self.objects addObject:object];
        }
        
        [Object release];
    }
    
    [self.tableView reloadData];

}


- (void)requestFailed:(ASIHTTPRequest *)request{
    //ERROR
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([[request error] code] == ASIConnectionFailureErrorType  ||
        [[request error] code] == ASIRequestTimedOutErrorType){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", nil) message: NSLocalizedString(@"CONNECTION_FAILED",nil)
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
        //return;
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR",nil) message: NSLocalizedString(@"GENERIC_ERROR",nil)
                                                       delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
        [alert show];
        [alert release];
        //return;
    }
}

-(void) loadData{
    
    NSString *urlString = [NSString stringWithFormat:@"http://francescoficetola.it/ios-test/test-paging.php?idx_last_element=%d&block_size_paging=%d", _lastIndex, numberCells];
        
    NSLog(@"URLSERVICE  %@",urlString);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:@"GET"];
    //[request setPostValue:@"" forKey:@""];
    
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8;"];
    [request setDelegate:self];
    
    [request startAsynchronous];

    
}



@end
