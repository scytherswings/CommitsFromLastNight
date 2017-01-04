# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/) after version 1.0.0 is released.

## [v0.0.4] : 2017-1-3
### Added
- Filtersets
  - Based on principles from the [Obscenity gem](https://github.com/tjackiw/obscenity).
  I built blacklists (words that trigger the filter) and whitelists (words specifically ignored). 
  The whitelist is a bit redundant but I'll revisit that later.
- Filter Categories
  - These will be used to classify Filtersets once I get more framework built out for that stuff.
    - I'm still deciding if it will be a good idea to let users submit filters and run them.
    Regardless I am building this project to make it easy to pull data out of commit messages so 
    this is just a stepping stone.
    
- Fully async for processing commit messages
  - [Sidekiq](http://sidekiq.org/) is pretty sweet and was really easy to get up and running  
  
### Changed
- Various UI elements
- Sortable tables.

## [v0.0.3] : 2016-12-25
### Changed
- Better user profiles
  - Users have commits totaled.
  - User avatars are more reliably fetched
- Timezone is automatically detected on first visit and stored in a cookie on the user's machine

### Removed
- User name aliases
  - Storing the committer names of users doesn't really add any value since we only care about usernames

## [v0.0.2] : 2016-12-23
### Added
- Too many features to remember
  - Repositories now have pages that show all the users that have ever committed code.
    - Tables can be sorted and show latest commit time from each user

## [v0.0.1] : 2016-12-15
### Added
- Added this changelog and `README.md`.
- Initial webpage layout. This is a work in progress for sure.
