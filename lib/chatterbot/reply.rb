module Chatterbot

  #
  # reply method for responding to tweets
  module Reply

    # handle replies for the bot
    def replies(&block)
      return unless require_login

      debug "check for replies since #{since_id_reply}"

      opts = {}
      if since_id_reply > 0
        opts[:since_id] = since_id_reply
      elsif since_id > 0
        opts[:since_id] = since_id
      end
      opts[:count] = 200

      results = client.mentions_timeline(opts)
      results.each { |s|
        update_since_id_reply(s)
        unless ! block_given? || on_blacklist?(s) || skip_me?(s)
          yield s         
        end
      }
    end
  end
end
