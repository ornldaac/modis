# MODIS Subsetting Tools and Services at ORNL DAAC

*Date: March 20th 2018*  
*Contact: Contact for ORNL DAAC: uso@daac.ornl.gov*

### Keywords: MODIS, Python, R, Perl, Matlab

## Overview:  

Documents in this repository pertain to usage of the MODIS Subsetting Tools and Services maintained by the ORNL DAAC. MODIS data hosted at the ORNL DAAC can be accessed in three ways:

1. **[Global Subsetting and Visualization Tool](https://modis.ornl.gov/cgi-bin/MODIS/global/subset.pl)**  
Request a subset for any location on earth, provided as GeoTiff and text format, including interactive time-series plots and more. Users specify a site by entering the site's geographic coordinates and the area surrounding that site, from one pixel up to 201 x 201 km.

ORNL DAAC. 2017. MODIS Collection 6 Land Products Fixed Sites Subsetting and Visualization Tool. ORNL DAAC, Oak Ridge, Tennessee, USA. https://doi.org/10.3334/ORNLDAAC/1567

2. **[Fixed Sites Tool](https://modis.ornl.gov/sites/)**  
Download pre-processed MODIS subsets for 1100+ field sites for validation of models and remote sensing products. The goal of the MODIS Subsets for Selected Field Sites is to prepare summaries of selected MODIS Land Products for the community to characterize field sites.

ORNL DAAC. 2017. MODIS Collection 6 Land Products Global Subsetting and Visualization Tool. ORNL DAAC, Oak Ridge, Tennessee, USA. https://doi.org/10.3334/ORNLDAAC/1379

3. **[Web Service](https://modis.ornl.gov/data/modis_webservice.html)**  
Retrieve subset data (in real-time) for any location(s), time period and area programmatically using a SOAP Web Service (from 1 pixel up to 201 x 201 km). Web Service client and libraries are available in multiple programming languages, allowing integration of subsets into users' workflow.

ORNL DAAC. 2017. MODIS Collection 6 Land Product Subsets Web Service. ORNL DAAC, Oak Ridge, Tennessee, USA. https://doi.org/10.3334/ORNLDAAC/1557

## Tutorials : 

[Want to programmatically access MODIS subsets? Learn to access MODIS Webservice in R, Py, Perl etc.](MODIS-SOAP-Web-Service/README.md)  
[Plot Statistics Output from the MODIS Global and Fixed Site Tools](modis-global-fixed-statistics.ipynb)  
[Access the MODIS web service and perform quality filtering using R](https://github.com/ornldaac/modis_webservice_qc_filter_R)  

## Resources:

Web Service:  
[R MODISTools package](MODIS-SOAP-Web-Service/MODISTools2.tar.gz)  
[Example Perl client](MODIS-SOAP-Web-Service/DAAC-LPS.pl)  
[Example Python client](MODIS-SOAP-Web-Service/MODIS-python-client.py)  

## Additional Information

More information about MODIS tools and services provided by the ORNL DAAC can be found at the MODIS microsite:  
https://modis.ornl.gov
