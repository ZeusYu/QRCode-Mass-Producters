require 'rubygems'
require 'tk'
#require 'rqrcode_png'
require 'httpclient'
require 'csv'
require 'iconv'
$type = TkVariable.new
$type.value = '1'

def create(content,sizes,path)
  @width = sizes #获取二维码的宽高
  case $type.value
    when '1'
      normal(content,path)
    when '2'
      vcard(content,path)
    end
end
    
def make_vcard()
  #$type = 2
  $description.configure('text'=>"Any line in text field will be encoded as a QRCode vCard,for example:\nBob zhou,eDoctor,Test engineer,18602142887,bob.zhou@edoctor.cn,www.edoctor.cn")
end
    
def make_normal()
  #$type = 1
  $description.configure('text'=>'Any line in text field will be encoded as a QRCode,please separate infomation by comma in a line')
end
    
def normal(content,path)
  $all = CSV.parse(content).length
  CSV.parse(content).each do |i|
    #qr = RQRCode::QRCode.new(i.join(","),:size => 6,:level => :l)
    content = i.join(",")
    encoding_content = Iconv.conv('utf-8','GBK',content)
    url = "http://chart.googleapis.com/chart"
    #png = qr.to_img
    #png.resize(@width,@width).save(path+"/#{i[0]}.png")
    img = $Google_API.get(url,:chs=>"#{@width}x#{@width}",:cht=>"qr",:chl=>encoding_content)
    File.open(path+"/#{i[0]}.png",'wb') do |f|
      f.puts img.body
    end
  end
end
  
def vcard(content,path)
  fieldnames = ["FN", "ORG", "TITLE","TEL;WORK;VOICE","EMAIL;PREF;INTERNET","URL"]
  content.split("\n").each do |line|
    info = line.split(',')
    s = (0...info.length).map do |i|
      fieldnames[i] + ":" + info[i]
    end.join("\n")
    #qr = RQRCode::QRCode.new("BEGIN:VCARD\nVERSION:2.1\n"+s+"\nEND:VCARD",:size => 10,:level => :l)
    content ="BEGIN:VCARD\nVERSION:2.1\n"+s+"\nEND:VCARD"
    encoding_content = Iconv.conv('utf-8','GBK',content)
    url = "http://chart.googleapis.com/chart"
    #png = qr.to_img
    #png.resize(@width,@width).save(path+"/#{info[0]}#{info[3]}.png")
    img = $Google_API.get(url,:chs=>"#{@width}x#{@width}",:cht=>"qr",:chl=>encoding_content)
    File.open(path+"/#{info[0]}#{info[3]}.png",'wb') do |f|
      f.puts img.body
    end
  end
end
    
def valid123(number)
  if number.match(/^[^0]\d+$/)
    return true
  end
  return false
end

background = "#ededed"
sizes = TkVariable.new
sizes.value = '320'

root = TkRoot.new do
  title "QRCoders Maker"
  bg background
end

TkLabel.new(root){
  text 'Contents need to encode:'
  anchor 'w'
  pack :side=>'top',:padx => '20', :fill => 'both'
  font "verdana 14"
  bg background
}#.grid('row'=>1,'column'=>1)
f2 = TkFrame.new{
  bg background
  pack :side =>'top',:padx =>20
}
content = TkText.new(f2){
  width 90
  height 10
  borderwidth 3
  pack :side => 'left'
}#.grid('row'=>2,'column'=>1)

scroll_bar=TkScrollbar.new(f2) do
  orient 'vertical'
  pack :fill=>'both',:side=>'left'
end
scroll_bar.command(proc { |*args|
  content.yview(*args)
})
content.yscrollcommand(proc { |first, last|
  scroll_bar.set(first, last)
})


TkButton.new(root){
  bg background
  text 'Generate'
  pack :side => 'bottom'
  command{
    if valid123(sizes.value)
      path = Tk.chooseDirectory
      if path != ''
        if path !=''
          $Google_API = HTTPClient.new
          create(content.value,sizes.to_i,path) 
        end
        Tk::messageBox :message => "Congretulation! all QRCodes are completed ", :title => 'Completed!'
      end
    else
      Tk::messageBox :message => 'Please input correct size', :title =>'Error！'
    end
  }
}#.grid('row'=>8,'column'=>2)

f1 = TkFrame.new {
  pack :side => 'bottom',:fill => 'both',:padx => '20'
  bg background
}

TkLabel.new(f1){
  bg background
  text 'QRCode Sizes(px)'
  font "arial 14"
  pack :side => 'left'
}#.grid('row'=>6,'column'=>1)

TkEntry.new(f1){
  text sizes
  pack :side => 'left'
}#.grid('row'=>6,'column'=>2)

$description = TkLabel.new(root){
  bg background
  anchor 'w'
  justify 'left'
  text 'Any line in text field will be encoded as a QRCode,please separate infomation by comma in a line'
  font "arial 12"
  pack :side => 'bottom',:padx => '20',:fill => 'both'
  height  2
  width 80
}#.grid('row'=>5,'column'=>1)

TkLabel.new(root){
  bg background
  text 'QRCode Type:'
  pack :side => 'left',:padx =>'20',:pady => '2'
  height 2
  font "arial 14"
}#.grid('row'=>3,'column'=>1)

TkRadiobutton.new(root){
  bg background
  text 'Default'
  variable $type
  value 1
  command{
    make_normal
  }
  pack :side => 'left'
}#.grid('row'=>4,'column'=>1)

TkRadiobutton.new(root){
  bg background
  text 'vCard'
  variable $type
  value 2
  command{
    make_vcard
  }
  pack :side => 'left'
}#.grid('row'=>4,'column'=>2)

Tk.mainloop