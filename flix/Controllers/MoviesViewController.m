//
//  MoviesViewController.m
//  flix
//
//  Created by Connor Clancy on 6/27/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "Movie.h"
#import "MovieApiManager.h"


@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *mainActivityMonitor;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mainActivityMonitor startAnimating];


    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // [self fetchMovies];
    
    // FAVORITES PAGE
    
    // CREATE REFRESH CONTROL
    
    //self.refreshControl = [[UIRefreshControl alloc] init];
    //[self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    //[self.tableView insertSubview:self.refreshControl atIndex:0];
    // self.movies = (NSArray *)self.favorites;
    [self.mainActivityMonitor stopAnimating];
    
    //NSLog(@"HERE!!!!!");
    /*
    for (int i=0; i < self.favorites.count; i++) {
        NSString *title = self.favorites[i][@"title"];
        //NSLog(title);
    */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.movies = [defaults objectForKey:@"movies"];
    [self.tableView reloadData];
    
   
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *movieArray = [defaults objectForKey:@"movies"];
    self.movies = [NSMutableArray arrayWithArray:[Movie moviesWithDictionaries:movieArray]];
    
    [self.tableView reloadData];
    
}

- (void)fetchMovies {
    [self.mainActivityMonitor startAnimating];
    [self.view bringSubviewToFront:self.mainActivityMonitor];
    /*
    // network call
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            UIAlertAction *retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self fetchMovies];
            }];
            NSLog(@"HERE!!!!");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Request Failed" message:@"Check your internet and retry" preferredStyle:(UIAlertControllerStyleAlert)];
            [alert addAction:retry];
            [self presentViewController:alert animated:YES completion:^{
                [self fetchMovies];
            }];
        }
        
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            //NSLog(@"%@", dataDictionary); // print data
            
            self.movies = [NSMutableArray arrayWithArray:[Movie moviesWithDictionaries:dataDictionary[@"results"]]];

            
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
        [self.mainActivityMonitor stopAnimating];
    }];
     */
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        self.movies = [NSMutableArray arrayWithArray:movies];
        [self.tableView reloadData];
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    //NSLog(@"%@", self.movies[0][@"title"]);
    Movie *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie.title;
    cell.synopsisLabel.text = movie.overview;
    
    // Adding Poster Photo
    NSURL *posterURL = movie.posterURL;
    cell.posterImage.image = nil;
    [cell.posterImage setImageWithURL:posterURL];
    */
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    cell.movie = self.movies[indexPath.row];
    
    return cell;
}

// Delete Favorite
- (void)deleteMovie:(NSString*)title {
    // Create User Defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *localMovies = [defaults objectForKey:@"movies"];
    NSMutableArray *temp = [NSMutableArray arrayWithArray:localMovies];
    // Gather Items to delete
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    // NSLog(@"number %lu", temp.count);
    for (int i = 0; i < temp.count; i++) {
        if (temp[i][@"title"] != title) {
            NSLog(@"I'm here in the thing");
            [finalArray addObject:temp[i]];
        }
    }
    
    // Create data to put back into the user settings
    NSArray *result = [NSArray arrayWithArray:finalArray];
    [defaults setObject:result forKey:@"movies"];
    self.movies = [NSMutableArray arrayWithArray:[Movie moviesWithDictionaries:[defaults objectForKey:@"movies"]]];
    //NSLog(@"here");
}

// TODO FIX BUG WHERE ONLY DELTES TOP MOVIE
/*
- (IBAction)deleteFavorite:(id)sender {
    NSLog(@"IM HERE!!!");
    UITableViewCell *swipedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:swipedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    [self deleteMovie:movie[@"title"]];
    [self.tableView reloadData];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.movies = [defaults objectForKey:@"movies"];
    [self.tableView reloadData];
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath =[self.tableView indexPathForCell:tappedCell];
    Movie *movie = self.movies[indexPath.row];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    
}


@end
