rm(list=ls())
install.packages("magick")
library(grid)
library(magick)
heart <- function(lcolor){
    t=seq(0, 2*pi, by=0.1)
    x=16*sin(t)^3
    y=13*cos(t)-5*cos(2*t)-2*cos(3*t)-cos(4*t)
    a=(x-min(x))/(max(x)-min(x))
    b=(y-min(y))/(max(y)-min(y))
    grid.lines(a,b,gp=gpar(col=lcolor,lty = "solid",lwd = 3))
}
png("嘉博老师节日快乐.png",width=1200,height=1200)
vp <- viewport(.10, .15, w=.3, h=.8)
grid.newpage()
vp1 <- viewport(.3, .5, w=.4, h=.4,angle=15)
pushViewport(vp1)
heart("red")
vp2 <- viewport(0.9, .27, w=.6, h=.6,angle=-15)
pushViewport(vp2)
heart("hotpink")
vp3 <- viewport(1.4, 0.5, w=1.6, h=1.6,angle=-30)
pushViewport(vp3)
heart("red")
grid.text("嘉博老师教师节快乐",
          x=0.2,y =1.2, just = c("center", "bottom"),
          gp = gpar(fontsize=20), vp = vp)
A=image_read("https://raw.githubusercontent.com/liu-xinrui/data/main/jiabo.jpg")
grid.raster(A, x=0.5, y=0.5,height=0.4) #grid包的函数，叠加图片到现有绘图上
dev.off()
