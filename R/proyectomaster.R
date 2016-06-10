#' Title
#' 
#' @return
#' @export
#' @param
#' @examples
get_blacklist_abuse<-function() {
  l <- read.table("https://sslbl.abuse.ch/blacklist/sslipblacklist_aggressive.rules", header = TRUE, sep = " ")
  ip<- substring(as.character(l[,6]),2,nchar(as.character(l[,6]))-1)
  ip_decimal<-ip_to_numeric(ip)
  protocolo<-l[,2]
  puerto<-l[,7]
  blacklist<-data.frame(ip_decimal,ip,protocolo,puerto, stringsAsFactors = FALSE)
}

#' Title
#' 
#' @return
#' @export
#' @param
#' @examples
show_bl<-function(){
  View(blacklist)
}

#' Title
#' 
#' @return
#' @export
#' @param
#' @examples
get_ip_countries<-function(){
  download.file(url="http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip", destfile="paises.zip")
  unzip("paises.zip")
  p <- read.table("GeoIPCountryWhois.csv",header = TRUE, sep = ",")
  de1<-p[,3]
  de2<-p[,4]
  pa<-as.character(p[,5])
  psa<-as.character(p[,6])
  ipcountry<-data.frame(de1,de2,pa,psa, stringsAsFactors = FALSE)
}


#' Title
#' 
#' @return
#' @export
#' @param
#' @examples
blacklist_countries<-function(){
  pais<-matrix(nrow = nrow(blacklist),ncol = 1)
  paisl<-matrix(nrow = nrow(blacklist),ncol = 1)
  for (i in 1:nrow(blacklist)){
    compare <- ((ipcountry$de1 <= blacklist$ip_decimal[i]) & (blacklist$ip_decimal[i] <= ipcountry$de2))
    pais[i,1]<-ipcountry[compare,4]
    paisl[i,1]<-ipcountry[compare,3]
  }
  paisf<-data.frame(pais, paisl)
  blacklist<-cbind(blacklist,paisf)
}

#' Title
#' 
#' @return
#' @export
#' @param
#' @examples
show_bl_coutry<-function(){
  View(a)
}

##creacion de mapa
#' Title
#' 
#' @return
#' @export
#' @param
#' @examples
plot_map<-function(){
  ##total cantidad por pais
  a  <- dplyr::count(blacklist, paisl) 
  ##crea el mapa
  map  <- joinCountryData2Map(a,
                              joinCode = "ISO2",
                              nameJoinColumn = "paisl",
                              suggestForFailedCodes = T,
                              mapResolution = "coarse",
                              projection = NA, 
                              verbose = T)
  ##parametros del mapa
  mapParams<-mapCountryData(map, missingCountryCol="gray99", oceanCol="aliceblue",
                            nameColumnToPlot="n",
                            mapTitle="SSL IPBL for Suricata / Snort (Aggressive) / for Country",
                            mapRegion="world",
                            colourPalette = c("Gray87","lightblue1","lightskyblue","royalblue1","royalblue3","royalblue4" ),
                            borderCol="azure4",
                            addLegend=F,
                            catMethod="dategorical",
                            
  )
  ##aplica los parametros en el mapa
  do.call( addMapLegend, c( mapParams
                            , legendLabels="all"
                            , legendWidth=0.7)
  )
  
}

