# Want to programmatically access MODIS subsets? Learn to access MODIS Webservice in R, Py, Perl etc.

*Date: March 20th 2018*  
*Contact: Contact for ORNL DAAC: uso@daac.ornl.gov*

### Keywords: MDOIS, Python, R, Perl, Matlab

## Overview:  

Using the sample codes provide users can access the ORNL DAAC MODIS Web Service users. The sample codes will provide scripts to   

•	Retrieve MODIS land product subsets through command line operation
•	Get subsets directly into software into client-side workflow
•	Write custom code to use the subsets for visualization or data reformatting

The sample codes are provided with inline comments. Users can download the sample code directly from [this github repository](https://github.com/ornldaac/modis/tree/master/MODIS-SOAP-Web-Service) and customized to meet user specific needs. Users are welcome to share their code back to the ORNL DAAC. 

Figure: 
![MODIS Web Service img](https://daac.ornl.gov/LAND_VAL/guides/MODIS_Web_Service_C6_Fig1.png)
 

## Source Data:  
https://daac.ornl.gov/cgi-bin/dsviewer.pl?ds_id=1557 

## Prerequisites and Procedure:  

### Perl client

The MODIS land product subset perl script is an easy to use perl implementation of the SOAP based interface to the ORNL DAAC MODIS data. The code was originally developed and contributed by [Dr. Koen Hufkens](http://www.khufkens.com/). Additional code contributions have been made by Dr. Stef Lhermitte to include a geographic header. These clients are written in Perl and use SOAP-Lite Perl module. The Perl client example allows users to submit request for a subset. The interface could be customized further to add more complex operations at the client end. 

### Python client

This client uses [SUDS](https://pypi.python.org/pypi/suds/0.4) python module. The python [client example](https://github.com/ornldaac/modis/blob/master/MODIS-SOAP-Web-Service/MODIS-python-client.py) allows users to submit request for a subset. The interface could be customized further to add more complex operations at the client end. The python client is written by Dr. Tristan Quaife, University of Reading, UK. 

### R
Download the MODISTools package [here](https://github.com/ornldaac/modis/blob/master/MODIS-SOAP-Web-Service/MODISTools2.tar.gz).
Install the downloaded package:
```
install.packages("MODISTools2.tar.gz",repos=NULL,type="source")
```
Download sample code [Rclient.R](https://github.com/ornldaac/modis/blob/master/MODIS-SOAP-Web-Service/Rclient.R) demonstrating usage of various available functions. 

### Matlab

The matlab code was created for a modelling course conducted by Dr. Tristan Quaife, University of Reading, UK. 


