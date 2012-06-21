require 'rubygems'
require 'rqrcode_png'
require 'RMagick'
require 'csv'

def create(content,sizes,path)
  #content = '周子予'#encodingsource.string #获取需要编码的内容
  @width = sizes #获取二维码的宽高
  #path = '/Users/maclion/Desktop'#choose_fold
  case $type.value
    when '1'
      normal(content,path)
    when '2'
      vcard(content,path)
    end
end
    
def make_vcard()
  #$type = 2
  $description.configure('text'=>"ny line in text field will be encoded as a QRCode vCard,for example:\nBob zhou,eDoctor,Test engineer,18602142887,bob.zhou@edoctor.cn,www.edoctor.cn")
end
    
def make_normal()
  #$type = 1
  $description.configure('text'=>'Any line in text field will be encoded as a QRCode,please separate infomation by comma in a line')
end
    
def normal(content,path)
  CSV.parse(content).each do |i|
    qr = RQRCode::QRCode.new(i.join(","),:size => 6,:level => :l)
    png = qr.to_img
    png.resize(@width,@width).save(path+"/#{i[0]}.png")
    watermark(path,"#{i[0]}") if $needwatermark.value == "1"
  end
end
  
def vcard(content,path)
  fieldnames = ["FN", "ORG", "TITLE","TEL;WORK;VOICE","EMAIL;PREF;INTERNET","URL"]
  content.split("\n").each do |line|
    info = line.split(',')
    s = (0...info.length).map do |i|
      fieldnames[i] + ":" + info[i]
    end.join("\n")
    qr = RQRCode::QRCode.new("BEGIN:VCARD\nVERSION:2.1\n"+s+"\nEND:VCARD",:size => 10,:level => :l)
    png = qr.to_img
    png.resize(@width,@width).save(path+"/#{info[0]}#{info[3]}.png")
    watermark(path,"#{info[0]}#{info[3]}") if $needwatermark.value == "1"
  end
end
    
def watermark(path,info)
  Dir.mkdir(path+'/watermark') if !File.directory?(path+'/watermark')
  img=Magick::Image.read(path+'/'+info+'.png').first
  copyright = Magick::Draw.new
  a = @width/15
  copyright.annotate(img,0,0,a,0,"#{info}") do
    self.font='msyh.ttf'
    self.pointsize = a
    self.gravity = Magick::SouthEastGravity
    self.stroke = "none"
  end
  img.write(path+"/watermark/#{info}_marked.png")
end

def valid123(number)
  if number.match(/^[^0]\d+$/)
    return true
  end
  return false
end