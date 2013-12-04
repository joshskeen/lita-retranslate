require "lita"

module Lita
  module Handlers
    class Retranslate < Handler

      def self.default_config(config)
        config.command_only = true
      end

      route %r{(retranslate) (.+)}i, :retranslate, help: {"retranslate" => "invokes retranslatebot in an attempt to discover the lexical underpinnings of a given phrase"}

      def retranslate(response)
        generate_retranslation(response)
      end

      private

      def generate_retranslation(response, text_to_translate: nil)
        return if Lita.config.handlers.retranslate.command_only && !response.message.command?

        text_to_translate ||= response.matches[0][1]
        translation = {starting_phrase: text_to_translate}

        http_resp = http.post(
            'http://retranslatebot.herokuapp.com/translations',
            api: true,
            translation: translation,
        )
        response.reply http_resp.body
      end

      Lita.register_handler(Retranslate)
    end
  end
end