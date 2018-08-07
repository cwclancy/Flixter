//
//  GridViewController.m
//  flix
//
//  Created by Connor Clancy on 6/28/18.
//  Copyright © 2018 codepath. All rights reserved.
//

/*
    THERE REMEMBER ERRORS MIGHT BE COMING FROM CHANGING TYPE OF MOVIES TO NSMUTABLE ARRAY
    IF NECESSARY CHANGE THAT
 */

#import "GridViewController.h"
#import "MovieCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "Movie.h"
#import "MovieApiManager.h"
#import "MovieCell.h"


@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) NSArray *movieTitles;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;
@property (strong, nonatomic) NSMutableArray *favorites;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityMonitor;

@end

@implementation GridViewController

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self fetchMovies];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Now Playing";
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:refreshControl atIndex:0];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.searchBar.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat postersPerLine = 2;
    CGFloat itemWidth = self.collectionView.frame.size.width/postersPerLine;
    CGFloat itemHeight = 1.5 * itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    [self fetchMovies];
    self.filteredData = self.movies;
    //self.movieTitles = [self getMovieTitles:self.movies];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchMovies {
    
    [self.activityMonitor startAnimating];
    [self.view bringSubviewToFront:self.activityMonitor];
    
    // new is an alternative syntax to calling alloc init.
    
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        self.movies = [NSMutableArray arrayWithArray:movies];
         NSLog([NSString stringWithFormat:@"IM HERE %lu", self.movies.count]);
        self.filteredData = self.movies;
        [self.collectionView reloadData];
        NSLog(@"here");
    }];
    
    
    
    
    [self.activityMonitor stopAnimating];

    
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
            
            // Initialize Movies Array
            self.movies = [NSMutableArray arrayWithArray:[Movie moviesWithDictionaries:dataDictionary[@"results"]]];
            // self.movies = dataDictionary[@"results"];
            self.filteredData = self.movies;
            [self.collectionView reloadData];
            // TODO: Get the array of movies
            
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
        //[self.refreshControl endRefreshing];
        [self.activityMonitor stopAnimating];
    }];
    */
    [self.collectionView reloadData];

}

// SEGUE

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    NSDictionary *movie = self.filteredData[indexPath.item];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = [[Movie alloc] initWithDictionary:movie];
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    Movie *movie = self.filteredData[indexPath.item];
    NSLog(@"here too");
    
    /*
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    */
    
    NSURL *posterURL = movie.posterURL;
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    NSLog(@"here too");
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog([NSString stringWithFormat:@"IM HERE IN COLLECITON VIEW %lu", self.filteredData.count]);
    return self.filteredData.count;
}

// Search Bar Functions

/*
- (NSArray *)getMovieTitles:(NSArray *)movies {
    NSMutableArray *result = [NSMutableArray new];
    for (int i = 0; i < self.movies.count; i++) {
        NSString *title = self.movies[i][@"title"];
        [result addObject:title];
    }
    return (NSArray *)result;
}
*/


// TODO: Change this funciton to account for new movie model
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        self.filteredData = [self.movies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(title contains[c] %@)", searchText]];
        
        NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.movies;
    }
    
    [self.collectionView reloadData];
    
}

- (IBAction)swipeToCancel:(id)sender {
    self.filteredData = self.movies;
    [self.collectionView reloadData];
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    NSLog(@"SWIPER IM SWIPING!!!");
}


@end
