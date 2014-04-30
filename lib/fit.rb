require "fit/version"

module Fit
  class CLI
    def self.run(args)
      new.run(args.first, *args[1..-1] || [])
    end

    def run(action, args)
      unless respond_to?(action)
        raise "#{action} is not a supported action."
      end

      send(action, *args)
    end

    def checkout(ticket_number)
      refname = refname_for_ticket(ticket_number)
      log "Found ref '#{refname}'"
      run_git "checkout #{refname}"
    end

    private

    # ticket_number is the JIRA issue id, including project acronym: DEV-12345
    def refname_for_ticket(ticket_number)
      %x[git branch -r | grep 'DEV-36583'].split("\n").map(&:strip).first
    end

    def log(message)
      puts "[fit] #{message}"
    end

    def run_git(command_string)
      command_string = "git #{command_string}"
      log command_string
      `#{command_string}`
    end
  end
end
