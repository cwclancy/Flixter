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


@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurEffect;
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
    self.movies = (NSArray *)self.favorites;
    [self.mainActivityMonitor stopAnimating];
    NSLog(@"HERE!!!!!");
    for (int i=0; i < self.favorites.count; i++) {
        NSString *title = self.favorites[i][@"title"];
        NSLog(title);
    }
    
   
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.movies = [defaults objectForKey:@"movies"];
    [self.tableView reloadData];
    
}

- (void)fetchMovies {
    [self.mainActivityMonitor startAnimating];
    [self.view bringSubviewToFront:self.mainActivityMonitor];
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
            
            NSLog(@"%@", dataDictionary); // print data
            
            self.movies = dataDictionary[@"results"];
            for (NSDictionary *movie in self.movies) {
                NSLog(@"%@", movie[@"title"]);
            }
            
            [self.tableView reloadData];
            // TODO: Get the array of movies
            
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
        [self.refreshControl endRefreshing];
        [self.mainActivityMonitor stopAnimating];
    }];
    [task resume];
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
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    // Adding Poster Photo
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"backdrop_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterImage.image = nil;
    [cell.posterImage setImageWithURL:posterURL];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath =[self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    
}


@end
