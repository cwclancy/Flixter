# Project 2 - Flix

Flix is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is complete:

- [y] User can view a list of movies currently playing in theaters from The Movie Database.
- [y] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [y] User sees a loading state while waiting for the movies API.
- [y] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [y] User sees an error message when there's a networking error.
- [y] Movies are displayed using a CollectionView instead of a TableView.
- [y] User can search for a movie.
- [n] All images fade in as they are loading.
- [n] User can view the large movie poster by tapping on a cell.
- [n] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [n] Customize the selection effect of the cell.
- [y] Customize the navigation bar.
- [y] Customize the UI.

The following **additional** features are implemented:

- [ ] User can select "favorite movies" that load whenever they load the app
- [ ] User can remove "favortie movies" 
- [ ] User can swipe away to get rid of the text bar
- [ ] User can tap the movie poster an see a trailer for that video

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. how can I make the favorites better
2. check on implementing custom segue effects

## Video Walkthrough

Here's a walkthrough of implemented user stories:
<img src='https://imgur.com/5ZPH9Vh.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='https://imgur.com/JbRdVtz.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='https://imgur.com/ObYRPXl.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

Learned a lot implementing things with user data and had to learn about some of the quirks of objective C.
Some string formatting issues came up.

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright 2018 Connor Clancy

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
