//
//  MovieApiManager.h
//  flix
//
//  Created by Connor Clancy on 7/2/18.
//  Copyright © 2018 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieApiManager : NSObject
- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion;
@end
