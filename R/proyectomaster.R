#' @title 
#' @return
#' @export
#' @param
#' @examples
## descarga la blacklist desde la url y devuelve el resultado en un dataframe
get_blacklist_abuse<-function() {
  l <- read.table("https://sslbl.abuse.ch/blacklist/sslipblacklist_aggressive.rules", header = TRUE, sep = " ")
  ip<- substring(as.character(l[,6]),2,nchar(as.character(l[,6]))-1)
  ip_decimal<-ip_to_numeric(ip)
  protocolo<-l[,2]
  puerto<-l[,7]
  blacklist<-data.frame(ip_decimal,ip,protocolo,puerto, stringsAsFactors = FALSE)
}

#' @Title
#' @return
#' @export
#' @param
#' @examples
## muestra el data frame con la blacklist descargada desde la fuente
show_blacklist<-function(){
  bl<-get_blacklist_abuse()
  View(bl)
}

#' @Title
#' @return
#' @export
#' @param
#' @examples
## descarga las ip por paises y lo devuelve en un dataframe
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

#' @Title
#' @return
#' @export
#' @param
#' @examples
## muestra el dataframe con las ip por paises
show_ip_countries<-function(){
    ip<-get_ip_countries()
    View(ip)
  }


#' @Title
#' @return
#' @export
#' @param
#' @examples
## añade al blacklis las columnas de los paises segun las ips
get_blacklist_countries<-function(){
  bl<-get_blacklist_abuse()
  bl_c<-get_ip_countries()
  pais<-matrix(nrow = nrow(bl),ncol = 1)
  paisl<-matrix(nrow = nrow(bl),ncol = 1)
  for (i in 1:nrow(bl)){
    compare <- ((bl_c$de1 <= bl$ip_decimal[i]) & (bl$ip_decimal[i] <= bl_c$de2))
    pais[i,1]<-bl_c[compare,4]
    paisl[i,1]<-bl_c[compare,3]
  }
  paisf<-data.frame(pais, paisl)
  bl<-cbind(bl,paisf)
}

#' @Title
#' @return
#' @export
#' @param
#' @examples
## muestra el dataframe del blacklist + los paises 
show_blacklist_coutries<-function(){
    blc<-get_blacklist_countries()
    View(blc)
  }

#' @Title
#' @return
#' @export
#' @param
#' @examples
## devuelve en un dataframe la cantida de ip por cada país encontrados en el blacklist
get_number_blackip_coutry<-function(){
  bl<-get_blacklist_abuse()
  bl_c<-get_blacklist_countries()
  a  <- dplyr::count(bl,bl_c$paisl) 

}

#' @Title
#' @return
#' @export
#' @param
#' @examples
## muestra el data frame con la cantidad de ip por cada país encontrados en el blacklist
show_number_blackip_coutry<-function(){
  nbl<-get_number_blackip_coutry()
  View(nbl)
}



#' @Title
#' @return
#' @export
#' @param
#' @examples
## creación de mapa
plot_map<-function(){
  ##total cantidad por pais

  a<-get_number_blackip_coutry()

  ##crea el mapa
  map  <- joinCountryData2Map(a,
                              joinCode = "ISO2",
                              nameJoinColumn = "bl_c$paisl",
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
                            catMethod="dategorical")
  
  ##aplica los parametros en el mapa
  do.call( addMapLegend, c( mapParams
                            , legendLabels="all"
                            , legendWidth=0.7)
  )
  
}

