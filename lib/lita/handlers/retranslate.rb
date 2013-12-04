require "lita"

module Lita
  module Handlers
    class Retranslate < Handler

      def self.default_config(config)
        config.command_only = true
      end

      route %r{(retranslate) (.+)}i, :retranslate,           help: { "retranslate" => "invokes retranslatebot in an attempt to discover the lexical underpinnings of a given phrase"}

      def retranslate(response)
        generate_retranslation(response)
      end

      private

      def generate_retranslation(response, text_to_translate: nil)
        return if Lita.config.handlers.retranslate.command_only && !response.message.command?

        text_to_translate ||= response.matches[0][0]

        http_resp = http.post(
          'http://retranslatebot.herokuapp.com',
          api: true,
          translation: text_to_translate,
        )
        if http_resp.status == 200
          response.reply http_resp.body
        end
      end

      Lita.register_handler(Retranslate)
    end
  end
