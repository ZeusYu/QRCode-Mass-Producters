#QRCode Mass Producters
一个极其简陋的玩具

###这东西是这么用滴：

1. 安装[Ruby 1.8.7](http://rubyinstaller.org/downloads)（安装时记得把tcl/tk支持选上）
2. 安装[ActiveTcl](http://www.activestate.com/activetcl/downloads)
3. 安装‘rqrcode_png’这个最主要的gem

4. 执行QRCoder_Maker.rb
5. 要编译成exe文件，请先安装ocra gem install ocra，然后执行ocra [rb file] [ruby/tk path] --add-all-core --windows --no-autoload --gem-full
6. 或者不搭建环境，直接执行QRCoder_Maker.exe

###不是计划的计划

1. 继续macruby之路，抛开gem，直接调google api生成QRCode
2. 水印的中好像有些问题，打包出来的exe好像缺字体
3. 看看能不能抛开对Imagick的依赖，真正成为绿色版

###以下纯吐槽：
写这个东西完全是属于本末倒置的，先是看到一个能生成二维码的gem包，用ruby写了一段批量生成二维码的脚步，于是头昏脑热打算用ruby写个有图形化界面的工具方便其他人在没有ruby环境的情况下批量制作二维码。

最初选择了macruby来进行开发，后来发现这个gem包在1.9.2的ruby环境下有乱码的情况，于是只好作罢，退到1.8.7，用TK+ruby来写这些东西，东西不多，主要就是把原来的ruby脚本和图形界面做了一下关联，因为头一次用tk，所以非常不熟练，尤其是最后打包发布成可执行文件这一步，最是坑爹。很多工具都是好几年前的，连ruby1.8.7都不支持，幸亏最后找了一个[ocra](http://ocra.rubyforge.org/)，这才拯救了我，总算是能搞出来个东西

缺憾是明显的，比如性能、比如各种bug、比如为了打包方面，把功能和界面的代码扔到了一块儿，但总算是学到了些东西-无论这些东西到底有没有用。