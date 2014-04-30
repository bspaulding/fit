require "fit/version"

module Fit
  class CLI
    def self.run(args)
      new.run(args.first, *args[1..-1] || [])
    end

    def runner
      @runner ||= ->(command_string) { `#{command_string}` }
    end

    def runner=(new_runner)
      @runner = new_runner
    end

    def run(action, args)
      unless respond_to?(action)
        raise "#{action} is not a supported action."
      end

      send(action, *args)
    end

    def checkout(substring)
      refname = refname_for_substring(substring)
      log "Found ref '#{refname}'"
      run_git "checkout #{refname}"
    end

    private

    def refname_for_substring(substring)
      %x[git branch -r | grep '#{substring}'].split("\n").map(&:strip).first
    end

    def log(message)
      puts "[fit] #{message}"
    end

    def run_git(command_string)
      command_string = "git #{command_string}"
      log command_string
      runner.call(command_string)
    end
  end
end
