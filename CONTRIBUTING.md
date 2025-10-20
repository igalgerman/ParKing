# Contributing to ParKing

First off, thank you for considering contributing to ParKing! It's people like you that make ParKing such a great tool.

## Where do I go from here?

If you've noticed a bug or have a feature request, [make one](https://github.com/igalgerman/ParKing/issues/new)! It's generally best if you get confirmation of your bug or approval for your feature request this way before starting to code.

### Fork & create a branch

If this is something you think you can fix, then [fork ParKing](https://github.com/igalgerman/ParKing/fork) and create a branch with a descriptive name.

A good branch name would be (where issue #123 is the ticket you're working on):

```sh
git checkout -b 123-add-a-new-feature
```

### Get the code

```sh
git clone https://github.com/your-username/ParKing.git
cd ParKing
flutter pub get
```

### Follow the Code of Conduct

ParKing follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).

### Implement your fix or feature

At this point, you're ready to make your changes! Feel free to ask for help; everyone is a beginner at first 😸

### Make a Pull Request

At this point, you should switch back to your main branch and make sure it's up to date with ParKing's main branch:

```sh
git remote add upstream git@github.com:igalgerman/ParKing.git
git checkout main
git pull upstream main
```

Then update your feature branch from your local copy of main, and push it!

```sh
git checkout 123-add-a-new-feature
git rebase main
git push --force-with-lease origin 123-add-a-new-feature
```

Finally, go to GitHub and [make a Pull Request](https://github.com/igalgerman/ParKing/compare)

### Keeping your Pull Request updated

If a maintainer asks you to "rebase" your PR, they're saying that a lot of code has changed, and that you need to update your branch so it's easier to merge.

To learn more about rebasing and merging, check out this guide on [syncing a fork](https://help.github.com/articles/syncing-a-fork).
