# A reasonable Emacs config (customized)

**This is [an emacs configuration from purcell](https://github.com/purcell/emacs.d) that's been customized by [rudolfolah](https://github.com/rudolfolah).**

This is my emacs configuration tree, continually used and tweaked
since 2000, and it may be a good starting point for other Emacs
users, especially those who are web developers. These days it's
somewhat geared towards OS X, but it is known to also work on Linux
and Windows.

Emacs itself comes with support for many programming languages. This
config adds improved defaults and extended support for the following:

* Ruby / Ruby on Rails
* CSS / LESS / SASS / SCSS
* HAML / Markdown / Textile / ERB
* Javascript / Coffeescript
* Python
* Common Lisp (with Slime)

In particular, there's a nice config for *tab autocompletion*, and
`flycheck` is used to immediately highlight syntax errors in Ruby,
HAML, Python, Javascript, and a number of other languages.

Includes [projectile](https://github.com/bbatsov/projectile) for easy
project navigation using find-file. It is enabled *globally*. Check
projectile's [Basic Setup section in the README](https://github.com/bbatsov/projectile#basic-setup)
to enable it for select modes.

**Check [init-local.el](lisp/init-local.el) for additional local settings!**

Init-local is right now loading these things:
* monokai-theme
* yasnippet
* web-mode
* org-doing

In the future those should probably go into the appropriate init-*.el
files.

## Supported Emacs versions

The config should run on Emacs 23.3 or greater and is designed to
degrade smoothly - see the Travis build - but note that Emacs 24 and
above is required for an increasing number of key packages, including
`magit` and `flycheck`, so to get full you should use the latest Emacs
version available to you.

## Other requirements

To make the most of the programming language-specific support in this
config, further programs will likely be required, particularly those
that [flycheck](https://github.com/flycheck/flycheck) uses to provide
on-the-fly syntax checking.

## Installation

To install, clone this repo to `~/.emacs.d`, i.e. ensure that the
`init.el` contained in this repo ends up at `~/.emacs.d/init.el`:

```
git clone https://github.com/rudolfolah/emacs.d.git ~/.emacs.d
```

Upon starting up Emacs for the first time, further third-party
packages will be automatically downloaded and installed. If you
encounter any errors at that stage, try restarting Emacs, and possibly
running `M-x package-refresh-contents` before doing so.



## Important note about `ido`

This config enables `ido-mode` completion in the minibuffer wherever
possible, which might confuse you when trying to open files using
<kbd>C-x C-f</kbd>, e.g. when you want to open a directory to use
`dired` -- if you get stuck, use <kbd>C-f</kbd> to drop into the
regular `find-file` prompt. (You might want to customize the
`ido-show-dot-for-dired` variable if this is an issue for you.)

## Updates

Update the config with `git pull`. You'll probably also want/need to update
the third-party packages regularly too:

<kbd>M-x package-list-packages</kbd>, then <kbd>U</kbd> followed by <kbd>x</kbd>.

## Adding your own customization

To add your own customization, use <kbd>M-x customize</kbd> and/or
create a file `~/.emacs.d/lisp/init-local.el` which looks like this:

```el
... your code here ...

(provide 'init-local)
```

If you need initialisation code which executes earlier in the startup process,
you can also create an `~/.emacs.d/lisp/init-preload-local.el` file.

If you plan to customize things more extensively, you should probably
just fork the repo and hack away at the config to make it your own!

## Similar configs

You might also want to check out `emacs-starter-kit` and `prelude`.

## Support / issues

### Customized Fork
[Report issues for the customized repo](https://github.com/rudolfolah/emacs.d/issues)

- Rudolf

[![](http://www.linkedin.com/img/webpromo/btn_liprofile_blue_80x15.png)](https://www.linkedin.com/in/rolah/)

[rudolfolah.com](https://rudolfolah.com/)

[@rudolf_olah](https://twitter.com/rudolf_olah)

### Original Repo
If you hit any problems, please first ensure that you are using the latest version
of this code, and that you have updated your packages to the most recent available
versions (see "Updates" above). If you still experience problems, go ahead and
[file an issue on the github project](https://github.com/purcell/emacs.d).

-Steve Purcell

[![](http://www.linkedin.com/img/webpromo/btn_liprofile_blue_80x15.png)](http://uk.linkedin.com/in/stevepurcell)

[sanityinc.com](http://www.sanityinc.com/)

[@sanityinc](https://twitter.com/)
