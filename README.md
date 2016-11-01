# Project 3 - *Twitter*

**Twitter** is a basic twitter app to read and compose tweets from the [Twitter API](https://apps.twitter.com/).

Time spent: **16** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.

The following **optional** features are implemented:

- [ ] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I would like to learn of common UI widgets that my peers used to make the app more pretty and user friendly to the eyes.
2. I would like to learn how my peers organized their storyboards to manage the various screen given that there are multiple ways of getting to the compose tweet screen.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/1PckodI.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://i.imgur.com/3He7gVw.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://i.imgur.com/ljz23my.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />
<img src='http://i.imgur.com/D43c7I4.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

The Twitter API was frustrating to use. In particular the favorite and re-tweeting functionality with the API. The docs appeared either out of date or not in sync with my response payload. Also, the whole issue of multiple "favorite" spellings threw me off and I wasted some time on that as well. Finally, I spent more time designing my storyboard because there are re-usable scenes so I had to programmatically make navigational segues.

## License

    Copyright [2016] [Mike Tehranian]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
