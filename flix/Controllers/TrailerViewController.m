//
//  TrailerViewController.m
//  flix
//
//  Created by Connor Clancy on 6/29/18.
//  Copyright © 2018 codepath. All rights reserved.
//
#import "TrailerViewController.h"

#import "UIImageView+AFNetworking.h"


@interface TrailerViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webKitView;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *movieId = self.movie[@"id"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", movieId]];
    NSLog([NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", movieId]);
    
    
    // Place the URL in a URL Request.
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:10.0];
    // Load Request into WebView.
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", dataDictionary); // print data
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/embed/%@/ecver=2", dataDictionary[@"results"][0][@"key"]]];
            NSLog([NSString stringWithFormat:@"https://www.youtube.com/embed/%@/ecver=2", dataDictionary[@"results"][0][@"key"]]);
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            [self.webKitView loadRequest:request];
            }
        }];
    [task resume];
}



    
    
    
    // Do any additional setup after loading the view.

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
