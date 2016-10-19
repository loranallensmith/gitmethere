# GitMeThere

This gem is a wrapper for Scott Chacon's [ruby-git](https://github.com/schacon/ruby-git) gem with commands that streamline the process of creating repositories in a given state.  Its primary purpose is for demonstrating common Git scenarios, but it is handy for scripting basic repository operations.

## Installation

```
> gem install gitmethere
```

## Usage

Use this gem to write Ruby scripts that automate repository creation.

```ruby

# A sample script for generating a repository with a merge-conflict on the horizon.

require 'gitmethere'

setup = {
  name: "merge-conflict",
  explanation:
    "# Merge Conflicts

    This repository demonstrates how merge conflicts occur."
}

scenario = GitMeThere::Scenario.new(name = setup[:name], explanation = setup[:explanation])
other_author = GitMeThere::Author.new("Other Developer", "test@example.com")

scenario.checkout_branch('feature')

scenario.pause("Pausing between steps for an explanation...")

scenario.append_to_file(
  file="README.md",
  content="A feature branch was created off of the `Initial commit`.
        This line was added to the file on the feature branch."
)

scenario.stage_changes

scenario.commit('Add line to feature branch.', author=other_author)

scenario.checkout_branch('master')

scenario.append_to_file(
  file="README.md",
  content="A feature branch was created off of the initial commit.
        However, work on `master` progressed in parallel to the work on `feature`.
        Since both branches contain commits after their common ancestor, the `master` and `feature` branches have now diverged.
        This is not always a problem, but since the same line (this line) was modified on both branches, Git does not know which version is the correct one.
        At this point, if you try to merge `feature` into `master`, you will encounter a merge conflict.")

scenario.stage_changes

scenario.commit('Add line to master branch')

```

## Contributing

1. Fork it ( https://github.com/loranallensmith/gitmethere/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Write tests for your changes
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Make sure all tests are passing
7. Create a new Pull Request
