#AppUp -->

AppUp is a little Git wrapper to keep your Rails environment up-to-date.  It will bundle install and migrate as needed.  It is aware of inline gems/engines/applications within your Git repository.


#Usage

AppUp comes with two executables:

- `app_up`: accepts Git SHAs as arguments.  Based on the diff between the SHAs, bundles and migrates (development and test environments).  When given no SHAs, bundles/migrates everywhere.
- `git_up`: A small Git wrapper.  Runs a git command and feeds the starting and ending SHAs to `app_up`.

In general, simply replace a call to `git` with one to `git_up`.  For example:

```
git_up pull --rebase origin master

Running RailsUp
----------
1/6 bundle   : ./apps/blog_app
2/6 bundle   : ./apps/blog_app/engines/comments
3/6 bundle   : ./apps/blog_app/engines/users
4/6 migrate  : ./apps/blog_app
5/6 migrate  : ./apps/blog_app/engines/comments
6/6 migrate  : ./apps/blog_app/engines/users
```

When given no arguments, `git_up`'s default action is to `pull --rebase origin master`.


You can also call `app_up` directly, but this is more rare:

```
app_up HEAD HEAD~3

Running RailsUp
----------
1/2 bundle   : ./apps/blog_app
2/2 migrate  : ./apps/blog_app
```

In the event that you have not created a database, AppUp will create one for you.

If you need to start over:

```
app_up --reset
# bundle installs everywhere
# drops and remigrates all dbs
```
