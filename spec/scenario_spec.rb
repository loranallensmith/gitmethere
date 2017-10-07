require 'gitmethere'
require 'fakefs/spec_helpers'

RSpec.describe GitMeThere::Scenario do

  before(:each) do
    include FakeFS::SpecHelpers
    FileUtils.mkdir('spec-temp')
    FileUtils.cd('spec-temp')
  end

  describe ".new()" do

    before(:each) do
      @scenario = GitMeThere::Scenario.new()
    end

    it "should create a default scenario directory" do
      expect(File.directory?('my-scenario')).to eq(true)
    end

    it "should have a README.md file" do
      expect(File.exist?('my-scenario/README.md')).to eq(true)
    end

    it "should have an empty readme file" do
      expect(File.read('my-scenario/README.md')).to be_empty
    end

  end

  describe ".new(args)" do

    let(:repo) { "named-repo" }
    let(:content) { "content" }

    before(:each) do
      @scenario = GitMeThere::Scenario.new(
        name=repo,
        explanation=content)
    end

    it "should create a directory with the specified name" do
      expect(File.directory?(repo)).to eq(true)
    end

    it "should have a README.md file" do
      expect(File.exist?("#{repo}/README.md")).to eq(true)
    end

    it "should have the specified content in the README.md file" do
      expect(File.read("#{repo}/README.md")).to eq("#{content}\n")
    end

  end

  describe ".g" do

    before(:each) do
      @scenario = GitMeThere::Scenario.new()
    end

    it 'should return Git::Base object' do
      expect(@scenario.g.class).to eq(Git::Base)
    end

  end

  describe ".create_file()" do

    before(:each) do
      @scenario = GitMeThere::Scenario.new()
    end

    it "without arguments" do
      @scenario.create_file()
      expect(File.exist?("my-scenario/my-file.md")).to eq(true)
    end

    it "with arguments" do
      @scenario.create_file(name="named-file.md", content="This is the content.")
      expect(File.read("my-scenario/named-file.md")).to eq("This is the content.\n")
    end

  end

  describe ".append_to_file()" do

    before(:each) do
      @scenario = GitMeThere::Scenario.new()
      @scenario.create_file()
    end

    it "without arguments" do
      @scenario.append_to_file()
      expect(File.read("my-scenario/my-file.md")).to include("Adding a bit more content")
    end

    it "with arguments" do
      @scenario.append_to_file(name="appended-file.md", content="Added some content.")
      expect(File.read("my-scenario/appended-file.md")).to include("Added some content.")
    end

  end

  describe ".rename_file()" do

    before(:each) do
      @scenario = GitMeThere::Scenario.new()
      @scenario.create_file(name="my-file.md", content="content")
    end

    it "without arguments" do
      @scenario.rename_file()
      expect(File.read("my-scenario/my-new-file.md")).to include("content")
    end

    it "with arguments" do
      @scenario.rename_file(source="my-file.md", target="renamed-file.md")
      expect(File.read("my-scenario/renamed-file.md")).to include("content")
    end

  end

  describe ".delete_file()" do

    before(:each) do
      @scenario = GitMeThere::Scenario.new()
    end

    it "without arguments" do
      @scenario.create_file()
      @scenario.delete_file()
      expect(File.file?("my-scenario/my-file.md")).to be false
    end

    it "with arguments" do
      @scenario.create_file(name="file-name")
      @scenario.delete_file(name="file-name")
      expect(File.file?("my-scenario/file-name")).to be false
    end

  end

  describe '.checkout_branch()' do
    before(:each) do
      @scenario = GitMeThere::Scenario.new(
        name="test-checkout",
        explanation="testing the checkout command"
      )
    end

    it "with new branch" do
      @scenario.checkout_branch("feature")
      expect(@scenario.instance_variable_get(:@g).current_branch).to eq("feature")
    end

    it "with existing branch" do
      @scenario.instance_variable_get(:@g).branch("test-branch")
      @scenario.checkout_branch("test-branch")
      expect(@scenario.instance_variable_get(:@g).current_branch).to eq("test-branch")
    end

  end

  describe ".stage_changes()" do

    before(:each) do
      @scenario = GitMeThere::Scenario.new(
        name = "test-staging",
        explanation = "Testing the .stage_changes() method"
      )
    end

    it "all changes" do
      @scenario.create_file(
        name = "test-staging-files.md",
        content = "Stage this file."
      )
      @scenario.stage_changes
      expect(@scenario.instance_variable_get(:@g).status.added.keys).to include("test-staging-files.md")
    end

  end

  describe ".commit()" do
    before(:each) do
      @scenario = GitMeThere::Scenario.new(
        name = "test-commit",
        explanation = "Testing the commit function"
      )
    end

    it "with message" do
      @scenario.create_file(
        name = "test-commit-file",
        content = "commit this file."
      )
      @scenario.stage_changes
      @scenario.commit("Testing the commit function")
      expect(@scenario.instance_variable_get(:@g).log.first.message).to eq("Testing the commit function")
    end

    it "with message and author" do
      author = GitMeThere::Author.new("Test User", "test@example.com")
      @scenario.create_file(
        name = "test-commit-file",
        content = "commit this file."
      )
      @scenario.stage_changes
      @scenario.commit("Testing the commit function with a different user", author)
      expect(@scenario.instance_variable_get(:@g).log.first.message).to eq("Testing the commit function with a different user")
      expect(@scenario.instance_variable_get(:@g).log.first.author.name).to eq(author.name)
      expect(@scenario.instance_variable_get(:@g).log.first.author.email).to eq(author.email)
    end
  end

  after(:each) do
    FileUtils.cd('..')
    FileUtils.rm_rf('spec-temp')
  end

end
