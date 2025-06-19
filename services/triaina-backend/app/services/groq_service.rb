require "net/http"
require "uri"
require "json"

class GroqService
  GROQ_API_URL = URI("https://api.groq.com/openai/v1/audio/transcriptions")
  MODEL = "distil-whisper-large-v3-en"

  def initialize(api_key = ENV["GROQ_API_KEY"])
    @api_key = api_key
  end

  def transcribe(audio_file)
    raise ArgumentError, "Audio file must be provided" if audio_file.nil?

    request = Net::HTTP::Post.new(GROQ_API_URL)
    request["Authorization"] = "Bearer #{@api_key}"

    request.set_form(
      [
        [ "file", audio_file ],
        [ "model", MODEL ],
        [ "language", "en" ],
        [ "response_format", "verbose_json" ]
      ],
      "multipart/form-data"
    )

    response = Net::HTTP.start(GROQ_API_URL.hostname, GROQ_API_URL.port, use_ssl: true) do |http|
      http.request(request)
    end

    raise "Groq transcription failed: #{response.code} #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    response.body
  end

  def summarize(text)
    raise ArgumentError, "Text to summarize must be provided" if text.nil? || text.strip.empty?

    uri = URI("https://api.groq.com/openai/v1/chat/completions")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@api_key}"
    request["Content-Type"] = "application/json"

    prompt = "Summarize the following transcript into a study summary with correct formatting that could be studied that doesn't miss any key points or add anything from outside the transcript:\n\n#{text}"

    request.body = {
      model: "gemma2-9b-it",
      messages: [
        { role: "user", content: prompt }
      ]
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    raise "Groq summarization failed: #{response.code} #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body).dig("choices", 0, "message", "content")
  end
end
