require "gitmethere/version"
require "gitmethere/author"

require 'git'
require 'io/console'

module GitMeThere

  class Scenario

    # All scenarios are automatically generated as a fresh repository with a README.md file
    # and an initial commit on the master branch.
    #
    # If an explanation is specified, it will be included as README.md text in the first commit.
    # If no name is specified, the repository will be created with the default name: `my-scenario`.
    #
    # Example:
    #   >> scenario = GitMeThere::Scenario.new(name="my-scenario", explanation="This is my scenario")
    #
    # Arguments:
    #   name: (String)
    #   explanation: (String)
    #

    # Give direct access to the Git::Base object in a scenario
    attr_accessor :git

    def initialize(name="my-scenario", explanation="")
      @name = name
      @git = Git.init(name)

      self.create_file(name='README.md', content=explanation)
      @git.add
      @git.commit("Initial commit")
    end

    def checkout_branch(branch)
      @git.branch(branch).checkout
    end

    def stage_changes
      @git.add
    end

    def create_file(name="my-file.md", content="")
      File.open("#{@name}/#{name}", 'w') do | f |
        unless content.empty?
          f.puts content
        end
      end
    end

    def append_to_file(name="my-file.md", content="Adding a bit more content")
      File.open("#{@name}/#{name}", 'a') do | f |
        f.puts content
      end
    end

    def replace_in_file(name="my-file.md", content="Adding a bit more content", new_content="Replaced content")
      text = File.read("#{@name}/#{name}")
      File.open("#{@name}/#{name}", 'w') do | f |
        f.puts text.gsub(content, new_content)
      end
    end

    def rename_file(source="my-file.md", target="my-new-file.md")
      File.rename("#{@name}/#{source}", "#{@name}/#{target}")
    end

    def delete_file(name="my-file.md")
      File.delete("#{@name}/#{name}")
    end

    def commit(message, author = nil)
      if author.nil?
        @git.commit(message)
      else
        @git.commit(message, author: author.git_author)
      end
    end

    def pause(message = nil)
      STDIN.echo = false
      if message
        puts message
      end
      puts "Press any key to continue..."
      input = STDIN.getch

    ensure
      STDIN.ioflush
      STDIN.echo = true
    end

  end

end
