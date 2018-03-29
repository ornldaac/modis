#!/usr/bin/perl 

################################################################
# ORNL DAAC MODIS Web service - Perl client (V1.1)
# Written by Koen Hufkens at Boston University
# contact: khufkens@bu.edu
#
# and adapted by Stef Lhermitte (stef.lhermitte@knmi.nl)
# - to include geographic header in function 4 and 5
# - to allow a date gap > 10 observations in function 5
# 
# updated the function to make the inclusion of the
# georeferencing header optional to not break
# legacy code. KH
#
#
# This perl script has five functions:
#
# 1. query the available products with 'list'
# ./DAAC-LPS.pl list
#
# 2. query the available bands of a product
# ./DAAC-LPS.pl MCD12Q1
#
# 3. query the available dates of a product at a location
# ./DAAC-LPS.pl MCD12Q1 40 -110
#
# first parameter is the product name (see 1.)
# second and third parameter are latitude and longitude
#
# 4. extract subsets of a product and band for a list of locations
# and this for all available dates.
# ./DAAC-LPS.pl MCD12Q1 Land_Cover_Type_1 1 1 T input.csv
#
# first parameter is the product name (see 1.)
# second parameter is the band name (see 2.)
# third parameter are the # km north south of the location
# fourth parameter are the # km east west of the location
# fifth parameter is a header flag 
# (T: print data with georeferencing header)
# (F: print no georeferencing header)
# sixth parameter is a csv file containing locations
# 
# The file format of the csv file is
# location name, latitude, longitude
# with no header and with !!! UNIX UTF-8 line endings !!!
#
# 5. extract subsets of a product and band for a certain location
# and interval of dates
#
# ./DAAC-LPS.pl Site MCD12Q1 Land_Cover_Type_1 40 -110 1 1 T A2001001 A2002001 
#
# first parameter is the site name
# second parameter is the product name (see 1.)
# third parameter is the band name (see 2.)
# fourth and fifth parameter are the latitude longitude
# sixth parameter are the # km north south of the location
# seventh parameter are the # km east west of the location
# eight parameter is a header flag 
# (T: print data with georeferencing header)
# (F: print no georeferencing header)
# nineth and tenth parameter are the start and enddate of the query
# (see 4.)
#
# requirements:
# SOAP lite for perl should be installed
# http://www.soaplite.com/
#
################################################################

##Using SOAP LITE module
use SOAP::Lite ;
use CGI qw(:standard) ;
use Scalar::Util qw(looks_like_number);
use POSIX qw(ceil floor);


# get the number of input arguments...
$numArgs = $#ARGV + 1;

if ($numArgs == 0){ # if no command line arguments are given, display usage...
	print "\n";
	print "#############################################################################\n";
	print "####################  USAGE -- HELP FILE -- INFO  ###########################\n";
	print "\n";
	print " ORNL DAAC MODIS Web service - Perl client\n";
	print " This perl script has five functions:\n";
	print "\n";
	print " 1. query the available products with 'list'\n";
	print " ./DAAC-LPS.pl list\n";
	print "\n";
	print "-----------------------------------------------------------------------------\n";
	print " 2. query the available bands of a product\n";
	print " ./DAAC-LPS.pl MCD12Q1\n";
	print "\n";
	print "-----------------------------------------------------------------------------\n";
	print " 3. query the available dates of a product at a location\n";
	print " ./DAAC-LPS.pl MCD12Q1 40 -110\n";
	print "\n";
	print " 	first parameter is the product name (see 1.)\n";
	print " 	second and third parameter are latitude and longitude\n";
	print "\n";
	print "-----------------------------------------------------------------------------\n";
	print " 4. extract subsets of a product and band for a list of locations\n";
	print " and this for all available dates.\n";
	print " ./DAAC-LPS.pl MCD12Q1 Land_Cover_Type_1 1 1 T input.csv\n";
	print "\n";
	print " 	first parameter is the product name (see 1.)\n";
	print " 	second parameter is the band name (see 2.)\n";
	print " 	third parameter are the # km north south of the location\n";
	print " 	fourth parameter are the # km east west of the location\n";
	print "		fifth parameter is a header flag\n";
	print " 	(T: print data with georeferencing header)\n";
	print " 	(F: print no georeferencing header)\n";
	print " 	sixth parameter is a csv file containing locations\n";
	print " \n";
	print " 	The file format of the csv file is\n";
	print " 	location name, latitude, longitude\n";
	print " 	with no header and with !!! UNIX UTF-8 line endings !!!\n";
	print "\n";
	print "-----------------------------------------------------------------------------\n";
	print " 5. extract subsets of a product and band for a certain location\n";
	print " and interval of dates\n";
	print "\n";
	print " ./DAAC-LPS.pl Site MCD12Q1 Land_Cover_Type_1 40 -110 1 1 A2001001 A2002001 \n";
	print "\n";
	print " 	first parameter is the site name\n";
	print " 	second parameter is the product name (see 1.)\n";
	print " 	third parameter is the band name (see 2.)\n";
	print " 	fourth and fifth parameter are the latitude longitude\n";
	print " 	sixth parameter are the # km north south of the location\n";
	print " 	seventh parameter are the # km east west of the location\n";
	print "		eight parameter is a header flag\n";
	print "		(T: print data with georeferencing header)\n";
	print "		(F: print no georeferencing header)\n";
	print "		nineth and tenth parameter are the start and enddate of the query\n";
	print "\n";
	print "-----------------------------------------------------------------------------\n";
	print " requirements:\n";
	print " SOAP lite for perl should be installed\n";
	print " http://www.soaplite.com/\n";
	print "\n";
	print "#############################################################################\n";
	print "\n";
	exit;
	
}

# check number of arguments if 1 continue for list or product info requests

if ($numArgs == 1){ 
	
	if ($ARGV[0] eq 'list' ){ # if argument is 'list' list the available products

		$params= SOAP::Lite
	    	-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
	    	-> xmlschema('http://www.w3.org/2001/XMLSchema')
	    	-> getproducts();
	
		# count the number of elements in list and loop through them printing each
		print "\n";
		print "### The ORNL MODIS DAAC provides the following products: ###########\n";
		print "\n";
		for (my $i = 0; $i < @{$params}; $i++) { 
			print "@{$params}[$i]\n";
		}
		print "\n";
		print "####################################################################\n";
		print "\n";
		
	}else{  # else check for the available bands of a specific product

		$products= SOAP::Lite
	    	-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
	    	-> xmlschema('http://www.w3.org/2001/XMLSchema')
	    	-> getproducts();
	
			if (grep $_ eq $ARGV[0], @$products) {	# check if command line argument is an available product 
				print "\n";
				print "### The MODIS product $ARGV[0] contains the following bands: #######\n";
				print "\n";	
	
				$bands= SOAP::Lite
	    			-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
	    			-> xmlschema('http://www.w3.org/2001/XMLSchema')
	    			-> getbands("$ARGV[0]");
	
				foreach (@{$bands}) {
					print "$_\n";
					}
		
				print "\n";
				print "####################################################################\n";
				print "\n";
				exit;
				
			}else{  # report an error if the product is not available
				print "\n";
				print "####################################################################\n";
				print "\n";
				print "ERROR:\n";
				print "There is no band information for your specified product!\n";
				print "Check the product name!\n";
				print "Or use the 'list' argument to list available products.\n";
				print "\n";
				print "####################################################################\n";
				print "\n";
				exit;
			}
			
	}

}


# check number of arguments if 3 continue for dates requests

if ($numArgs == 3){ 

	$products= SOAP::Lite
    	-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
    	-> xmlschema('http://www.w3.org/2001/XMLSchema')
    	-> getproducts();
	
	if (grep (/^$ARGV[0]$/, @$products) && looks_like_number($ARGV[1]) > 0 && looks_like_number($ARGV[2]) > 0 ) {	# check if command line argument is an available product and coordinates are ok. 
		print "\n";
		print "### The MODIS product $ARGV[0] contains the following dates: #######\n";
		print "\n";	

		$dates= SOAP::Lite
   			-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
   			-> xmlschema('http://www.w3.org/2001/XMLSchema')
   			-> getdates($ARGV[1], $ARGV[2],"$ARGV[0]");

		foreach (@{$dates}) {
			print "$_\n";
			}

		print "\n";
		print "####################################################################\n";
		print "\n";
		exit;
		
	}else{  # report an error if the product is not available
		print "\n";
		print "####################################################################\n";
		print "\n";
		print "ERROR:\n";
		print "Check the product name and latitude longitude!\n";
		print "Use the 'list' argument to list available products.\n";
		print "\n";
		print "####################################################################\n";
		print "\n";
		exit;
	}

}

# if there are 6 input parameters continue using and input file with coordinates

if ($numArgs == 6){

		$products= SOAP::Lite
	    	-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
	    	-> xmlschema('http://www.w3.org/2001/XMLSchema')
	    	-> getproducts();
	
		$bands= SOAP::Lite
	   		-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
	   		-> xmlschema('http://www.w3.org/2001/XMLSchema')
	   		-> getbands("$ARGV[0]");
	
		# checking if the product exist, the band exists, the ROI settings are numbers...
		if (grep (/^$ARGV[0]$/, @$products)  && grep (/^$ARGV[1]$/, @$bands) && looks_like_number($ARGV[2]) > 0 && looks_like_number($ARGV[3]) > 0 && $ARGV[4] == F || $ARGV[4] == T){
			
			# reading in location data and dumping them in array @sites
			$file = $ARGV[5];
			open(INF,$file) or die "Damn. $ARGV[5] does not exist, check the location file!"; #open location file, error when location file does not exist...
			@sites = <INF>;
			close INF;

			print "####################################################################\n";
			print "########### CALCULATING MODIS DAAC SUBSETS #########################\n";	

			for (my $l = 0; $l < @sites; $l++){

				# for every site in the array extract the site name and coordinates
				$tmploc = $sites[$l];
				@location = split(/,/,$tmploc);
				$site = $location[0];
				$lat = $location[1];
				$long = $location[2];
				
				print "\n";
				print " Header flag is set to: $ARGV[4]\n";
				print " --> Evaluating: $site\n";
				print " --> Latitude / Longitude: $lat / $long\n";
				
				# Create output filename 
				$filename = $site."_".$ARGV[0]."_".$ARGV[1].".csv";
				
				# get dates for the specific coordinats
				$dates= SOAP::Lite
					-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
					-> xmlschema('http://www.w3.org/2001/XMLSchema')
					-> getdates($lat,$long,$ARGV[0]);				
				

				# get the number of dates for later evaluation
				# you could use the @{$dates} statement directly
				# but this would not increase the readability
				# of the code...
			    	$nrdates = @{$dates};
			    
				$|=1;

				# sets a dummy variable to write header once or not at all
				if ($ARGV[4] eq 'T'){
					$dummy=0;
				}else{
					$dummy=1; # if header flag is F, set dummy to 1, no header will be printed
					open (OUTF,">>$filename") or die "$!"; 	#open the output filename as this will be skipped otherwise			
				}

				for (my $d = 0; $d < @{$dates};){
					
					# set interval over which we will extract the data (max 10 tiles at a time)
					# next if statement is to differentiate between yearly and other data
					# otherwise the progress bar would go haywire and the loop would crash
					# because of out of range values
					
					if ($d+9 >= @{$dates}){
					$startdate = "@{$dates}[$d]";
					$enddate = "@{$dates}[$#dates]";
					$d = @{$dates};
					# print"$startdate $enddate \n";
					}else{
					$startdate = "@{$dates}[$d]";
					$enddate = "@{$dates}[$d+9]";
					$d += 10;
					# print"$startdate $enddate \n";
					}					
					
					if($dummy == 0){ # if header is not written, write
						# extracting DAAC data with SOAP api
						$headerdata= SOAP::Lite
		    				-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
		    				-> xmlschema('http://www.w3.org/2001/XMLSchema')
		    				#-> on_fault(sub { my($soap, $res) = @_; die ref $res ? $res->faultstring : $soap->transport->status, "\n";})
						-> getsubset($lat,$long,"$ARGV[0]","$ARGV[1]","$startdate","$enddate","$ARGV[2]","$ARGV[3]");
						
						# Get header data from extracted DAAC data
						while( my($key, $value) = each %$headerdata){
		 					if($key eq 'ncols'){
								$ncols=$value;
							}
							if($key eq 'nrows'){
								$nrows=$value;
							}
		 					if($key eq 'xllcorner'){
								$xllcorner=$value;
							}
							if($key eq 'yllcorner'){
								$yllcorner=$value;
							}
							if($key eq 'longitude'){
								$longitude=$value;
							}
							if($key eq 'latitude'){
								$latitude=$value;
							}
							if($key eq 'cellsize'){
								$cellsize=$value;
							}
							
						}
						#open file OUTF
						open (OUTF,">>$filename") or die "$!"; 
						# Write header to output file
						print OUTF "Site : $site\n";
						print OUTF "lat : $latitude\n";
						print OUTF "lon : $longitude";
						print OUTF "ncols : $ncols\n";
						print OUTF "nrows : $nrows\n";
						print OUTF "xllcorner : $xllcorner\n";
						print OUTF "yllcorner : $yllcorner\n";
						print OUTF "cellsize  : $cellsize\n";
						
						# Write also header file with grid coordinates (Row-Col)
						$hdr="Site,Product,Year,Doy";
						for (my $i = 0; $i < $ncols; $i++) {
							for (my $j = 0; $j < $nrows; $j++) {
								$hdr="$hdr,R$j-C$i";
							}
						}
						print OUTF "$hdr\n";
						close(OUTF); # close file
						$dummy=1; # Set dummy variable to write header only once						
					}
					
					# extracting DAAC data with SOAP api
					$subsetdata= SOAP::Lite
	    				-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
	    				-> xmlschema('http://www.w3.org/2001/XMLSchema')
	    				#-> on_fault(sub { my($soap, $res) = @_; die ref $res ? $res->faultstring : $soap->transport->status, "\n";})
					-> getsubset($lat,$long,"$ARGV[0]","$ARGV[1]","$startdate","$enddate","$ARGV[2]","$ARGV[3]");
					
					# progress bar, calculate percentage and print
					$done = floor(100 * $d / @{$dates});
					print " --> $done % Complete!";
			        	# Goto the start of the line
					print "\r";		
					
					# This is the main data extraction and formating routine...
	   				while( my($key, $value) = each %$subsetdata){
	 					if($key eq 'subset'){
		
							#open file OUTF, appends data on every cycle in the loop...
							open (OUTF,">>$filename") or die "$!";
 						
	   						@subset=$value;
	   													
							for (my $i = 0; $i < @subset; $i++) {
								for (my $j = 0; $j < @{$subset[$i]}; $j++) {
								
								# for every line extract the year and doy
								# by spliting the array and picking
								# the necessary substrings
								@tmp = split(/,/, $subset[$i][$j]);
								$year = substr $tmp[2], 1, 4;
								$doy = substr $tmp[2], 5, 8;
								
								# extract data from split array
								@data = @tmp[5..$#tmp];
								#join data with commas to make a csv file...
								$data = join(',',@data);
								
								# debug data
								# print "$data \n";
									
								# print all output in comma delimited format...
								print OUTF "$ARGV[0],$ARGV[1],$year,$doy,$data";
							
								} # close for loop
							} # close for loop
						
						close(OUTF); # close file
						} # close while loop							
						
					} # close loop through dates
				}
				
			}
			
		print "\n";		
		print "########### DONE !!!!!!!!!!!!!!!!!!!!!!!!! #########################\n";	
		print "####################################################################\n";			
		exit;
		
		}else{			
			print "\n";
			print "####################################################################\n";
			print "\n";
			print  "ERROR: Check all the input arguments! In particular the dates!\n";
			print "\n";
			print "####################################################################\n";
			print "\n";
			exit;
		}
}	

# if there are 9 input parameters continue using explicit command line specification of the location and site name

if ($numArgs == 10){
	
	$products= SOAP::Lite
	   	-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
	   	-> xmlschema('http://www.w3.org/2001/XMLSchema')
	   	-> getproducts();
	
	$bands= SOAP::Lite
		-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
	   	-> xmlschema('http://www.w3.org/2001/XMLSchema')
	   	-> getbands("$ARGV[1]");
	   	
	if (looks_like_number($ARGV[3]) > 0 && looks_like_number($ARGV[4]) > 0 ){   	
	   	
	 	$dates= SOAP::Lite
			-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
			-> xmlschema('http://www.w3.org/2001/XMLSchema')
			-> getdates($ARGV[3],$ARGV[4],$ARGV[1]);
		$nrdates = @{$dates};
	   	
	} else {
	   	
	 	print "\n";
		print "####################################################################\n";
		print "\n";
		print "ERROR: Something is wrong with your input arguments!\n";
		print "Check the latitude longitude or print header flag!\n";
		print "\n";
		print "####################################################################\n";
		print "\n";		
		exit;
		
   	}
	   	
	# checking if the product exist, the band exists, the ROI settings are numbers...
		
	if (grep (/^$ARGV[1]$/, @$products)  && grep (/^$ARGV[2]$/, @$bands) && grep (/^$ARGV[7]$/, @$dates) && grep (/^$ARGV[8]$/, @$dates) && looks_like_number($ARGV[5]) > 0 && looks_like_number($ARGV[6]) > 0 && $ARGV[7] == F || $ARGV[7] == T){

		print "####################################################################\n";
		print "########### CALCULATING MODIS DAAC SUBSETS #########################\n";	
		
		$site = $ARGV[0];
		
		print "\n";
		print " --> Evaluating: $site\n";
		print " --> Latitude / Longitude: $ARGV[3] / $ARGV[4]\n";
		
		# Create output file name
		$filename = $site."_".$ARGV[1]."_".$ARGV[2].".csv";
			
		# set interval over which we will extract the data 
		$startdate = $ARGV[8];
		$enddate = $ARGV[9];
		
		# check which is start date 
		for ($i = 0; $i < $nrdates; $i++)
		{ 
			if ($startdate eq @{$dates}[$i]) 
			{   
				$match_first = $i;
			 	last;     
			} 
		}
		
		# check which is end date 
		for ($i = 0; $i < $nrdates; $i++)
		{ 
			if ($enddate eq @{$dates}[$i]) 
			{   
				$match_last = $i;
			 	last;     
			} 
		}

		# sets a dummy variable to write header once or not at all
		if ($ARGV[4] eq 'T'){
			$dummy=0;
		}else{
			$dummy=1; # if header flag is F, set dummy to 1, no header will be printed
			open (OUTF,">>$filename") or die "$!"; 	#open the output filename as this will be skipped otherwise			
		}

		for (my $d = $match_first; $d < $match_last;){
			
			# set interval over which we will extract the data (max 10 tiles at a time)
			# next if statement is to differentiate between yearly and other data
			# otherwise the progress bar would go haywire and the loop would crash
			# because of out of range values
			
			if ($d+9 >= $match_last){
			$startdate = "@{$dates}[$d]";
			$enddate = 	"@{$dates}[$match_last]";
			$d = @{$dates};
			}else{
			$startdate = "@{$dates}[$d]";
			$enddate = "@{$dates}[$d+9]";
			$d += 10;
			}
			
			if($dummy == 0){ # if header is not written, write
			
				$headerdata= SOAP::Lite
					-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
					-> xmlschema('http://www.w3.org/2001/XMLSchema')
					-> getsubset($ARGV[3],$ARGV[4],"$ARGV[1]","$ARGV[2]","$startdate","$enddate","$ARGV[5]","$ARGV[6]");
		
				# Get header data from extracted DAAC data
				while( my($key, $value) = each %$headerdata){
					if($key eq 'ncols'){
						$ncols=$value;
					}
					if($key eq 'nrows'){
						$nrows=$value;
					}
					if($key eq 'xllcorner'){
						$xllcorner=$value;
					}
					if($key eq 'yllcorner'){
						$yllcorner=$value;
					}
					if($key eq 'longitude'){
						$longitude=$value;
					}
					if($key eq 'latitude'){
						$latitude=$value;
					}
					if($key eq 'cellsize'){
						$cellsize=$value;
					}

				}
				#open file OUTF
				open (OUTF,">>$filename") or die "$!"; 
				# Write header to output file
				print OUTF "Site : $site\n";
				print OUTF "lat : $latitude\n";
				print OUTF "lon : $longitude\n";
				print OUTF "ncols : $ncols\n";
				print OUTF "nrows : $nrows\n";
				print OUTF "xllcorner : $xllcorner\n";
				print OUTF "yllcorner : $yllcorner\n";
				print OUTF "cellsize  : $cellsize\n";
				
				# Write also header file with grid coordinates (Row-Col)
				$hdr="Site,Product,Year,Doy";
				for (my $i = 0; $i < $ncols; $i++) {
					for (my $j = 0; $j < $nrows; $j++) {
						$hdr="$hdr,R$j-C$i";
					}
				}
				print OUTF "$hdr\n";
				close(OUTF); # close file
				$dummy=1; # Set dummy variable to write header only once
			}
		
			# extracting DAAC data with SOAP api
			$subsetdata= SOAP::Lite
				-> service('https://modis.ornl.gov/cgi-bin/MODIS/soapservice/MODIS_soapservice.wsdl')
				-> xmlschema('http://www.w3.org/2001/XMLSchema')
				#-> on_fault(sub { my($soap, $res) = @_; die ref $res ? $res->faultstring : $soap->transport->status, "\n";})
				-> getsubset($ARGV[3],$ARGV[4],"$ARGV[1]","$ARGV[2]","$startdate","$enddate","$ARGV[5]","$ARGV[6]");
			
			# This is the main data extraction and formating routine...
		 	while( my($key, $value) = each %$subsetdata){
				if($key eq 'subset'){
				
				#open file OUTF, appends data on every cycle in the loop...
				open (OUTF,">>$filename") or die "$!";
				
				@subset=$value;
					
				for (my $i = 0; $i < @subset; $i++) {
					for (my $j = 0; $j < @{$subset[$i]}; $j++) {
					
						# for every line extract the year and doy
						# by spliting the array and picking
						# the necessary substrings
						@tmp = split(/,/, $subset[$i][$j]);
						$year = substr $tmp[2], 1, 4;
						$doy = substr $tmp[2], 5, 8;
							
						# extract data from split array
						@data = @tmp[5..$#tmp];
						#join data with commas to make a csv file...
						$data = join(',',@data);
					
						# print all output in comma delimited format...
						print OUTF "$ARGV[0],$ARGV[1],$year,$doy,$data";
						
						} #closing for loop
					} #closing for loop
							
				close(OUTF); # close file
			
			} # closing if statement
		} # closing while statement
	} # closing for statement
	print "\n";		
	print "########### DONE !!!!!!!!!!!!!!!!!!!!!!!!! #########################\n";	
	print "####################################################################\n";	
	exit;
	
	} else {

	print "\n";
	print "####################################################################\n";
	print "\n";
	print  "ERROR: Check all the input arguments! In particular the dates and\n";
	print  "the header flags\n";
	print "\n";
	print "####################################################################\n";
	print "\n";
	exit;

	}
}

# Final input arguments error trap... for # arguments 2, 4, 5, 7, 8, 9 and > 10

if ($numArgs > 10 or $numArgs == 4 or $numArgs == 8 or $numArgs == 2 or $numArgs == 5 or $numArgs == 7 or $numArgs == 9){

	print "\n";
	print "####################################################################\n";
	print "\n";
	print  "ERROR: Check all the input arguments! In particular the dates and\n";
	print  "the header flags\n";
	print "\n";
	print "####################################################################\n";
	print "\n";
	exit;
	
}