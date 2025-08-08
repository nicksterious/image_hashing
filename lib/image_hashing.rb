# frozen_string_literal: true

require_relative "image_hashing/version"
# require "vips"
# require "image_processing/vips"
# require "json"
# require "digest"
# require "dhash-vips"

module ImageHashing
  class Error < StandardError; end

  class ImageHash
    def initialize(file_name)
      @image = ::Vips::Image.new_from_file(file_name)
      @output = {
          file_name: file_name,
          file_size_bytes: File.size(file_name),
          file_md5_hash: ::Digest::MD5.file(file_name).hexdigest,
          width: @image.width,
          height: @image.height,
          format: @image.format,
          original: {
              dhash: ::DHashVips::DHash.calculate(@image).to_s,
              idhash: ::DHashVips::IDHash.fingerprint(@image).to_s,
              histogram: get_histogram(@image)
          }
      }
    end
    

    def generate
      # get some metadata based on several other resolutions
      image = ::ImageProcessing::Vips.source(@image)
      image = image.convert("png")
      [800, 400, 200, 100, 50].each do |size|
          resized_image = image.resize_to_limit(size, size).call(save: false)
          @output["#{size}x#{size}"] = {
              size: size,
              dhash: ::DHashVips::DHash.calculate(resized_image).to_s,
              idhash: ::DHashVips::IDHash.fingerprint(resized_image).to_s,
              histogram: get_histogram(resized_image)
          }
      end
      @output
    end # hash


    def get_rgb_qties(i)
        image = i
        if image.format.to_s != "uchar"  
            image = image.colourspace(:rgb)  # Convert to RGB if necessary
        end

        # Split the image into R, G, and B channels
        red, green, blue = image.bandsplit

        # Calculate histograms for each channel
        red_hist = red.hist_find_indexed(0)
        green_hist = green.hist_find_indexed(0)
        blue_hist = blue.hist_find_indexed(0)

        # Total number of pixels for each color channel is the sum of the histogram
        {
            red: red_hist.to_a.first.first.first,
            green: green_hist.to_a.first.first.first,
            blue: blue_hist.to_a.first.first.first
        }  
    end # get_rgb_qties

    def get_histogram(image)
        begin
            return get_rgb_qties(image)
        rescue
           nil
        end
        return { red: 0, green: 0, blue: 0 }
    end # get_histogram

  end # class
end
