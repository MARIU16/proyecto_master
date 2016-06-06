get_blacklist_abuse<-function() {
  l <- read.table("https://sslbl.abuse.ch/blacklist/sslipblacklist_aggressive.rules", header = TRUE, sep = " ")
  ip<- substring(as.character(l[,6]),2,nchar(as.character(l[,6]))-1)
  ip_decimal<-ip_to_numeric(ip)
  protocolo<-l[,2]
  puerto<-l[,7]
  tabla1<-data.frame(ip_decimal,ip,protocolo,puerto, stringsAsFactors = FALSE)
}

get_ip_countries<-function(){
  download.file(url="http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip", destfile="paises.zip")
  unzip("paises.zip")
  p <- read.table("GeoIPCountryWhois.csv",header = TRUE, sep = ",")
  de1<-p[,3]
  de2<-p[,4]
  pa<-as.character(p[,5])
  psa<-as.character(p[,6])
  tabla2<-data.frame(de1,de2,pa,psa, stringsAsFactors = FALSE)
}


blacklist_countries<-function(){
  pais<-matrix(nrow = nrow(tabla1),ncol = 1)
  paisl<-matrix(nrow = nrow(tabla1),ncol = 1)
  for (i in 1:nrow(tabla1)){
    compare <- ((tabla2$de1 <= tabla1$ip_decimal[i]) & (tabla1$ip_decimal[i] <= tabla2$de2))
    pais[i,1]<-tabla2[compare,4]
    paisl[i,1]<-tabla2[compare,3]
  }
  paisf<-data.frame(pais, paisl)
  tabla1<-cbind(tabla1,paisf)
}
##Sumar por pais fuente: https://view.officeapps.live.com/op/view.aspx?src=http://personales.unican.es/gonzaleof/Itop/jaime/Pract_1_R.doc
tt<-summary.factor(pais, data=tabla1)
total_pais<-data.frame(tt)
View(total_pais)