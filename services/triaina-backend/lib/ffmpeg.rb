module Ffmpeg
  require "shellwords"
  require "tempfile"

  # input_blob: ActiveStorage::Blob
  def self.extract_audio(input_blob)
    file_name = input_blob.filename.to_s

    temp_input_file = Tempfile.new(
      [ "#{File.basename(file_name, '.*')}_input_#{Time.now.strftime('%Y%m%d%H%M%S')}", File.extname(file_name) ],
      binmode: true
    )

    temp_input_file.write(input_blob.download)
    temp_input_file.flush # Write to disk immediately
    temp_input_file.rewind

    temp_output_file = Tempfile.new(
      [ "#{File.basename(file_name, '.*')}_audio_#{Time.now.strftime('%Y%m%d%H%M%S')}", ".wav" ],
      binmode: true
    )

    cmd = "ffmpeg -y -i #{Shellwords.escape(temp_input_file.path)} -vn -ac 1 -ar 16000 -b:a 64k -acodec libmp3lame #{Shellwords.escape(temp_output_file.path)}"
    system(cmd) or raise "FFmpeg audio extraction failed"

    temp_output_file.rewind
    temp_output_file
  ensure
    temp_input_file.close!
  end
end
