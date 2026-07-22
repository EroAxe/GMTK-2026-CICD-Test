# GMTK-2026-CICD-Test

---
Disclaimer, some of if not most of this is probably obvious. But in my opinion, better safe than sorry. So I put it all in anyway. The more info the easier it is for people to add stuff.
---

## Quick Rundown

- Initial Godot project is setup on v4.7.1 (Might get updated if we want a feature, but should be pretty set)
- There's a CI/CD pipeline live (courtesy of @brainfartstudio in the Discord). What that means is a couple things:
   1. Do NOT work directly on "main", "development" or "feat/cicd". Those branches are auto-built, so we're only doing things there with PRs.
   2. With that though, we have auto builds. Meaning for playtesting there's a page we can direct playtesters to. More info on that in the Discord for anyone that wants it.

# Contributing

First off some quick rules.
1. To reiterate. Do NOT work on "main", "development" or "feat/cicd". Any PRs/changes to those branches will be denied without prior confirmation.
2. Make PRs (Pull Requests) to commit your changes to the main repo. Minimal direct commit access if any will be given.
3. If you're unsure what to work on, check Issues. There's likely something.

## How to Contribute/Add Code etc.

As a quick rundown for how to contribute you should first get yourself a [fork of the repo](https://docs.github.com/en/pull-requests/how-tos/work-with-forks/fork-a-repo) to then make PRs from. The link should help, but if not, it should be as simple as the "Fork" button just above the Description. 

With a fork you can do whatever you want there, *on your own branches* (and/or any besides the 3 previously mentioned), and making PRs should be as simple as hitting the popup on your repo (image to come) or heading to the Pull Request tab and creating one there. 

## Pull Request Guidelines/Tips

1. The more specific you can be about what your PR does the better. Linking to issues with #{Issue Number} for example #1, #2 can be very helpful for knowing what it's in reference to since Github automatically links those. As well as sends notifications for people involved.
2. Avoid editing anything outside of what you _specifically_ need. That can either be done by selectively commiting or just fully working on different issues at different times. That's up to preference.
