require 'gitmethere'
require 'fakefs/spec_helpers'

RSpec.describe GitMeThere::Author do

  before(:each) do
    @author = GitMeThere::Author.new("Test User", "test@example.com")
  end

  describe ".new()" do

    it "should create an author with the specified name and email" do
      expect(@author.name).to eq("Test User")
      expect(@author.email).to eq("test@example.com")
    end

  end

  describe ".git_author()" do

    it 'should return a valid git author identifier (name <email>)' do
      expect(@author.git_author).to eq("Test User <test@example.com>")
    end

  end

end
