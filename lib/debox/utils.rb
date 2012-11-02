module Debox
  module Utils

    def email_regex
      /^([^@\s]+)@((?:[-a-z0-9_]+\.)+[a-z]{2,})$/i
    end

    # md5 and hash
    #----------------------------------------------------------------------

    def md5_str(str)
      Digest::MD5.hexdigest str
    end

    def md5_file(filename)
      Digest::MD5.file(filename)
    end


    # file edit
    #----------------------------------------------------------------------
    def edit_file(content)
      tmp_file = Tempfile.new "debox"
      tmp_file.write content
      tmp_file.close
      editor = ENV['EDITOR'] || 'nano'
      system "#{editor} #{tmp_file.path}"
      edited_file = File.open tmp_file.path
      edited_file.read
    end

    # Ask for console input
    #----------------------------------------------------------------------

    def ask_email
      ask("email:  ") do |q|
        q.validate = email_regex
        q.responses[:not_valid] = "<%= color('Email is not well formed', :red) %>"
      end
    end

    def ask_password
      ask("password:  "){ |q| q.echo = '*' }
    end

    def ask_password_with_confirmation
      ask("password:  ") do |q|
        q.echo = '*'
        q.verify_match = true
        q.gather = {"password:  " => '',
          "password confirmation:  " => ''}
      end
    end


    # Errors and warnings
    #----------------------------------------------------------------------

    def notice(msg)
      puts msg
    end

    def alert(msg)
    end

    def error_and_exit(msg)
      puts msg
      exit 1
    end

    def exit_ok(msg=nil)
      puts msg if msg
      exit 0
    end

  end
end
