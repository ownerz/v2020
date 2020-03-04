# require 'singleton'
require 'rmagick'
require 'rake'

class PdfService
  # include Singleton

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

# 아래 오류 관련해서 
# Postscript delegate failed `/tmp/c_100135498.pdf': No such file or directory @ error/pdf.c/ReadPDFImage/678
# => 
# https://qiita.com/tady/items/fb6927f9b0031c36332b 
#  에 나와있는대로, ghostscript 와 ImageMagick 을 컴파일 하여 설치해도 동일한 오류가 발생함.
#  /tmp/ 에 파일이 너무 많이 생겨서 발생하는 이슈인가??
# 

