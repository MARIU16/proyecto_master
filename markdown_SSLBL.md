SSL Black List (SSLBL)
========================================================
By:
David Renjifo /
María Eugenia García /
María Eugenia Sánchez

## **Introduction**

Suricata / Snort Ruleset to detect and block bad SSL connections in your network.

Abuses **include** botnets, malware campaigns and banking malware.

Many entries are associated with networks based on popular bots and malware such as Zeus, Shylock and kinships attacks.

The origin source updates every 15 minutes.

**Objective**: Cross the black list obtained from the following [link](https://sslbl.abuse.ch/blacklist/sslipblacklist_aggressive.rules): base on the list of ip's by country to determine the origin of the attacks.

Ip's black list (SSLBL) can be used to compare with any ip's log and know who had visit a page, etc.


**The next table shows the black list.**





```
## Error in as.data.frame(x): objeto 'tabla1' no encontrado
```

The range of ip's by countries was downloaded from: [Geolite web page](http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip): 


```
## Error in nrow(tabla1): objeto 'tabla1' no encontrado
```
Then we realized the matching between the SSLBL and IPS by countries and the following result was obtained


```
## Error in as.data.frame(x): objeto 'a' no encontrado
```
And finally we show the result

## **Map**

```
## Error in group_by_(x, .dots = vars): objeto 'tabla1' no encontrado
```

