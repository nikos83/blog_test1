class ProcessCoverImageJob < ApplicationJob
  queue_as :default

  def perform(record)
    return unless record.cover_image.attached?

    Tempfile.create([ "cover_image" ]) do |tempfile|
      tempfile.binmode
      tempfile.write(record.cover_image.download)
      tempfile.rewind

      processed_image = ImageProcessing::MiniMagick
                          .source(tempfile.path)
                          .resize_to_limit(1200, 1200)
                          .convert("webp") # Zmieniamy na WebP
                          .call

      record.cover_image.attach(
        io: File.open(processed_image.path),
        filename: "cover_image_#{record.id}.webp",
        content_type: "image/webp"
      )
    end
  end
end
