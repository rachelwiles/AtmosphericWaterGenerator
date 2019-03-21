%ENSURE THIS FILE IS IN THE SAME LOCATION AS "concept.m" AND "interpolation_data.xlsx" 
%Script is run each time "Calculate" in GUI is pushed
 
humid = get(handles.edit1, 'String');	%Reads user value for humidity
humid = str2double(humid);				%Converts string to numerical value
 

temp = get(handles.edit2, 'String');	%Reads user value for temperature
temp = str2double(temp);				%Converts string to numerical value
 

sunlight = get(handles.edit3, 'String');	%Reads user value for sunlight exposure per hour
sunlight = str2double(sunlight);			%Converts string to numerical value
 

dbt_samp = [25:45];			%Insert research data sample for temp
humid_samp = [35:5:100];	%Insert research data sample for humidity
waterout_samp = xlsread('interpolation_data.xlsx', 1, 'D35:Q55');	%Reads research data from excel spreadsheet (data derived from references a and b see bottom of code)
watgen = interp2(humid_samp, dbt_samp, waterout_samp, temp, humid, 'scalar');	%Performs 2D interpolation/extrapolation using bilinear method
 

power = sunlight*0.260*2;			%260W per hour per one convert energy PV panel (taken from reference c see bottom of code)
excesspower = power - (0.125*24);	%125W per hour usage (take from reference b see bottom of code)
if excesspower < 0					%If excess power is less than 0, then system is running for less than 24hrs amd therefore only a fraction of the water output is achieved
    excesspower = 0;				%Set excess power to 0 (since all power is consumed)
    F = power/(0.420*24);			%Creates factor fo find fraction of water output achieved (fraction due to system not running full 24hrs)
    watgen = F*watgen;				%Calculate water output with system run time considered
end
 

watgen = 0.99*watgen;	%Assume 99% water yield after filtration process
 

dailycost = 63.82/(365*5);	%Value taken from reference (see bottom of code)
							%63.82 cost of one ultrafilter and microfilter in GBP
							%Lifetime of five years
cost = dailycost/watgen;	%Calculates maintenance cost per litre of water generated
 

set(handles.edit4,'String',num2str(watgen));		%Prints value of water generated to GUI
set(handles.edit5,'String',num2str(cost));			%Prints value of projected cost to GUI
set(handles.edit10,'String',num2str(excesspower));	%Prints value of projected cost to GUI
 
 
%Reference a: Dash, Abhishek, and Anshuman Mohapatra. ATMOSPHERIC WATER GENERATOR: To meet the drinking water requirements of a household in coastal regions of India. Diss. 2015.
%Reference b: Suryaningsih, Sri, and Otong Nurhilal. "Optimal design of an atmospheric water generator (AWG) based on thermo-electric cooler (TEC)for drought in rural area." AIP Conference Proceedings. Vol. 1712. No. 1. AIP Publishing, 2016.
%Reference c: http://www.convertenergy.co.uk/pv-solar-panels (convert energy panel)
%Reference d: http://re.jrc.ec.europa.eu/pvg_tools/en/tools.html (PVGIS tool)
