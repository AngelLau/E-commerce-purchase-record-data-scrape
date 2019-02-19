setwd("D:/Users/angel.lau/Desktop")
yonghu=c("666")
filefile=c("ÎÒµÄ¶©µ¥.html")
getwd()
library(XML)
library(stringr)
library(miscTools)
parseamz<-htmlParse(file = filefile ,encoding = "UTF-8")

#orderid
sink("amzid.txt")
orderid=getNodeSet(parseamz,'//div/div/div/div/div/div[2]/div[1]/span[@class="a-color-secondary value"]/text()')
print(orderid)
sink()
data=read.table(file="amzid.txt", sep="\t",fill = TRUE,encoding = "UTF-8")
data=as.matrix(data[1:(dim(data)[1]-2),])
dim(data)=c(3,dim(data)[1]/3)
data=t(data)
amzid=data[1:dim(data)[1],2]
amzid=as.matrix(str_sub(amzid,5))

#sumprice
sink("amzsum.txt")
sum=getNodeSet(parseamz,'//div[5]/div/div/div/div/div/div[1]/div/div[2]/div[2]/span/text()')
print(sum)
sink()
data=read.table(file="amzsum.txt", sep="\t",fill = TRUE)
data=as.matrix(data[1:(dim(data)[1]-2),])
dim(data)=c(3,dim(data)[1]/3)
data=t(data)
sum=data[1:dim(data)[1],2]
sum=as.matrix(sum)
sum=as.matrix(str_sub(sum,6))

#purchasetime
sink("amztime.txt")
time=getNodeSet(parseamz,'//div[5]/div/div/div/div/div/div[1]/div/div[1]/div[2]/span/text()')
print(time)
sink()
data=read.table(file="amztime.txt",sep="\t",fill=TRUE)
data=as.matrix(data[1:(dim(data)[1]-2),])
dim(data)=c(3,dim(data)[1]/3)
data=t(data)
time=data[1:dim(data)[1],2]
time=as.matrix(time)

sink("amzshop.txt")
shop=getNodeSet(parseamz,'//div[5]/div/div[2]/div/div[2]/div/div[1]/div[1]/div/div/div[2]/div[3]/span/text()')
print(shop)
sink()
data=read.table(file="amzshop.txt",fill=TRUE)
data=as.matrix(data[1:(dim(data)[1]-3),])
dim(data)=c(3,dim(data)[1]/3)
data=t(data)
shop=data[1:dim(data)[1],3]
shop=as.matrix(shop)

#goodname
sink("amzgood.txt")
good=getNodeSet(parseamz,'//div/div/div[5]/div/div[2]/div/div[2]/div/div[1]/div/div/div/div[2]/div[1]/a/text()')
print(good)
sink()
data=read.table(file="amzgood.txt",sep="\t",fill=TRUE)
data=as.matrix(data[1:(dim(data)[1]-2),])
dim(data)=c(3,dim(data)[1]/3)
data=t(data)
good=data[1:dim(data)[1],2]
good=as.matrix(good)

sink("amzprice.txt")
price=getNodeSet(parseamz,'//div/div/div[5]/div/div[2]/div/div[2]/div/div[1]/div[1]/div/div/div[2]/div[5]/span/text()')
print(price)
sink()
data=read.table(file="amzprice.txt",sep="\t",fill=TRUE)
data=as.matrix(data[1:(dim(data)[1]-2),])
dim(data)=c(3,dim(data)[1]/3)
data=t(data)
price=data[1:dim(data)[1],2]
price=as.matrix(price)
price=as.matrix(str_sub(price,6))


id=getNodeSet(parseamz,'//div/div/div[5]/div/div[2]/div/div[2]/div/div[1]/div/div/div/div[2]/div[8]/div/span[@data-a-modal]')
id=sapply(id, function(el) xmlGetAttr(el, "data-a-modal"))
id=as.matrix(id)
id=as.matrix(str_sub(id,314,332))

yonghuid=rep(yonghu,times=dim(id)[1])
fileid=rep(filefile,times=dim(id)[1])

a=cbind(amzid,sum,time)
b=cbind(id,good,price,shop,yonghuid,fileid)
colnames(a)=c("amzid","sumprice","time")
colnames(b)=c("id","goods","price","shop","yonghuid","fileid")
final=merge(a,b, by.x = "amzid",by.y="id",all = TRUE)
write.table(final,file = "D:/Users/angel.lau/Desktop/amz-order.csv",sep = ",",append = TRUE,row.names = TRUE,col.names = TRUE)


