# Change Log
All notable changes to this project will be documented in this file. Un-notable changes have already
been forgotten by the time I went to write these notes. Obviously they weren't important, right?
This project adheres to [Semantic Versioning](http://semver.org/) starting when version 1.0.0 is released.

## [v0.0.7] : 2017-2-5
### Changed
- Navbar
  - Several unused chunks of code were removed and unnecessary stuff trimmed out somewhat. 
  - The navbar is now using `contianer-fluid` because it was beginning to feel crowded with everything
  pushed in towards the middle of the page.
  - This should leave room for more stuff that I plan to release in v1.1.0! (If I make it there, 
  you know how it goes with these things..)
- Size of user avatars
  - The user and repository pages have now had some more work done on them, they look less crappy now
  hopefully. 
- Commit message filtering
  - Filter words are now properly escaped so that they don't inadvertantly get parsed as part of the
  regular expression.
  - Fixed some broken JS that interacted with query parameters. TBH I'm pretty sure there's a more 
  elegant way to solve my problems with keeping a multiselect in sync with the page content across
  reloads. Ehhh, this works. If I hear about a better way I'll rewrite it.
- Truncating
  - Commit messages, usernames, and repository names are all truncated to help keep the UI looking
  more consistent. This should *hopefully* fix the horrendous horizontal scrollbar crap.
  
## [v0.0.6] : 2017-2-5
### Added
- Keyword highlighting
  - This uses javascript. A commit message:
    ```
    Hoooooly fuck. FUCK JAVASCRIPT THIS IS THE DEVIL'S LANGUAGE. 
    I swear it was designed by post-lobotomy patients and monkeys. 
    Uck I can't understand how anyone would *want* to choose to work in this language. 
    Everything is completly fucky. /rage
    ```
    I make this sacrifice for you, the readers of documents like this. The *real* users.
    The people who understand the struggle.
  
## [v0.0.5] : 2017-1-20
### Added
- Overhauled Navbar Kindof
  - Multiselect dropdown
    - Allows users to select which `Category` they want to use.
    - I *hate* `JavaScript`.
    - Caveat: You cannot see unfiltered commits on the main page. Implementing that seems harder than it's worth
      due to the extra logic needed to figure out that someone specifically requested NO filters.
      Mainly because I don't feel like figuring it out right now, it's probably not that bad.
    - This forced me to get creative with `SQL` and I found [Scuttle.io](http://www.scuttle.io/) to be *extremely* 
      helpful in my quest to build `ActiveRecord` queries. Funny how it usually goes the other way, but sometimes
      the `SQL` is easier to figure out than AR relationship stuff when things get complicated.
- Several new default filters
  - I built the list of words by hand for most of them so if you have any suggestions please make a PR to add to the lists!
- Controllers for models that shouldn't have controllers
  - These are placeholders and will likely be removed later. Or maybe I'll flesh out the UI.. Who knows.
- New format for `Filtersets`
  - Now these `Filtersets` can be imported from a yaml file which is pretty slick. The import script automatically
  creates the `Category` if it doesn't exist already and
- Caching in some places. Still need to do more caching in the views etc.
  
### Removed
- The concept of "Whitelists" and "Blacklists" from Filtersets
    - It was stupid and didn't make the filters any more usable. It added confusion to something that didn't need to be
    confusing.
    
### Changed
- Default sort order for the index on `Commit`.`utc_commit_time`. This might help performance. Maybe. Though I'm sure
other parts of the app are un-optimized enough to negate any possible speed improvements gains. Oh well.
- Some logging supression was disabled. They'll be squelched again soon.


## [v0.0.4] : 2017-1-3
### Added
- Filtersets
  - Based on principles from the [Obscenity gem](https://github.com/tjackiw/obscenity).
  I built blacklists (words that trigger the filter) and whitelists (words specifically ignored). 
  The whitelist is a bit redundant but I'll revisit that later.
- Filter Categories
  - These will be used to classify `Filtersets` once I get more framework built out for that stuff.
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
