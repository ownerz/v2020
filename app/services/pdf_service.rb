require 'singleton'
require 'rmagick'
require 'rake'

class PdfService
  include Singleton

  def initialize()
  end

  def convert(pdf_path)
    # pdf_path = "lib/e_100136749.pdf"
    # image = Magick::Image.read(pdf_path) do
    #   self.quality = 100
    #   self.density = 400
    # end
    # ret = image[0].write(pdf_path.ext('png'))
    # # ret.filename

    return pdf_path if Rails.env.development? 
    image = Magick::Image.read(pdf_path) do
      self.quality = 100
      self.density = 400
    end
    ret = image[0].write(pdf_path.ext('png'))
    ret.filename
  end
end
