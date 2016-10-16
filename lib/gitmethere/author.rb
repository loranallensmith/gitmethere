module GitMeThere
  class Author
    attr_reader :name, :email

    def initialize(name, email)
      @name = name
      @email = email
    end

    def git_author
      "#{name} <#{email}>"
    end
  end
end
