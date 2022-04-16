#Name: Jeremy Chen
#Email: Jeremy.Chen69@myhunter.cuny.edu

#Data
#http://web.mta.info/developers/developer-data-terms.html#data	
#http://web.mta.info/developers/turnstile.html

# This code assumes turnstile data and subway station data was downloaded locally as .csv files.

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from datetime import datetime as dt
  
def combine_data(turnstile_data_file,station_data_file):
    # Renaming columns in station_data to match merge column and remove GTFS
    station_data.rename(columns = {'Stop Name':'STATION','GTFS Latitude': 'Latitude','GTFS Longitude': 'Longitude'}, inplace = True)
    output = turnstile_data.merge(station_data,on ='STATION')
    
    # Dropping any data that does not have coordinate data (some turnstile data is for PATH stations)
    output.dropna()
    return output

def filter_station_data(file_name):
    file = pd.read_csv(file_name)
    file.rename(columns=lambda x: x.strip(), inplace=True)

    # Dropping unused columns and duplicates
    file = file[['Stop Name','GTFS Latitude','GTFS Longitude']]
    file = file.drop_duplicates(subset=['Stop Name'])
    return file

def get_data(week_nums):
    fileFormat = "turnstile_{}.csv"
    dfs = []
    for week_num in week_nums:
        # Creating File Name and Reading File
        fileName = fileFormat.format(week_num)
        file = pd.read_csv(fileName)
        file.rename(columns=lambda x: x.strip(), inplace=True)
        # Filtering out non-regular data collections 
        file = file[file.DESC == 'REGULAR']
        
        # Combining date and time columns
        file['datetime'] = pd.to_datetime(file.DATE+' '+file.TIME)
        
        # Dropping unused columns
        file = file.drop(columns=['LINENAME', 'DIVISION','DESC','TIME'])
        dfs.append(file)
    output = pd.concat(dfs,ignore_index=True)
    #Sorting by Datetime
    output.sort_values(by=['datetime'], inplace=True)

    # Calculating Entries and Exits
    output['ENTRIES'] = output.groupby(['STATION', 'UNIT', 'C/A', 'SCP'])['ENTRIES'].diff().abs()
    output['EXITS'] = output.groupby(['STATION', 'UNIT', 'C/A', 'SCP'])['EXITS'].diff().abs()
    # Dropping columns not needed in the final result to slim dataset   
    output = output.drop(columns=['UNIT', 'C/A','SCP','datetime'])
    
    output['ENTRIES'] = output['ENTRIES'].fillna(0)
    output['EXITS'] = output['EXITS'].fillna(0)
    
    # Summing Entries and Exits
    output = output.groupby(['DATE','STATION'], as_index = False).sum()
    
    return output

# Main Code
week_nums = [141018,141025,141101,141108,141115,141122,141129,141206,141213,141220,\
             141227,150103,150110,150117,150124,150131,150207,150214,150221,150228,\
             150307,150314,150321,150328,150404,150411,150418,150425,150502,150509,\
             150516,150523,150530,150606,150613,150620,150627,150704,150711,150718,\
             150725,150801,150808,150815,150822,150829,150905,150912,150919,150926,\
             151003,151010,151017,151024,151031,151107,151114,151121,151128,151205,\
             151212,151219,151226,160102,160109,160116,160123,160130,160206,160213,\
             160220,160227,160305,160312,160319,160326,160402,160409,160416,160423,\
             160430,160507,160514,160521,160528,160604,160611,160625,160702,160709,\
             160716,160723,160730,160806,160813,160820,160827,160903,160910,160917,\
             160924,161001,161008,161015,161022,161029,161105,161112,161119,161126,\
             161203,161210,161217,161224,161231,170107,170114,170121,170128,170204,\
             170211,170218,170225,170304,170311,170318,170325,170401,170408,170415,\
             170422,170429,170506,170513,170520,170527,170603,170610,170617,170624,\
             170701,170708,170715,170722,170729,170805,170812,170819,170826,170902,\
             170909,170916,170923,170930,171007,171014,171021,171028,171104,171111,\
             171118,171125,171202,171209,171216,171223,171230,180106,180113,180120,\
             180127,180203,180210,180217,180224,180303,180310,180317,180324,180331,\
             180407,180414,180421,180428,180505,180512,180519,180526,180602,180609,\
             180616,180623,180630,180707,180714,180721,180728,180804,180811,180818,\
             180825,180901,180908,180915,180922,180929,181006,181013,181020,181027,\
             181103,181110,181117,181124,181201,181208,181215,181222,181229,190105,\
             190112,190119,190126,190202,190209,190216,190223,190302,190309,190316,\
             190323,190330,190406,190413,190420,190427,190504,190511,190518,190525,\
             190601,190608,190615,190622,190629,190706,190713,190720,190727,190803,\
             190810,190817,190824,190831,190907,190914,190921,190928,191005,191012,\
             191019,191026,191102,191109,191116,191123,191130,191207,191214,191221,\
             191228,200104,200111,200118,200125,200201,200208,200215,200222,200229,\
             200307,200314,200321,200328,200404,200411,200418,200425,200502,200509,\
             200516,200523,200530,200606,200613,200620,200627,200704,200711,200718,\
             200725,200801,200808,200815,200822,200829,200905,200912,200919,200926,\
             201003,201010,201017,201024,201031,201107,201114,201121,201128,201205,\
             201212,201219,201226,210102,210109,210116,210123,210130,210206,210213,\
             210220,210227,210306,210313,210320,210327,210403,210410,210417,210424,\
             210501,210508,210515,210522,210529,210605,210612,210619,210626,210703,\
             210710,210717,210724,210731,210807,210814,210821,210828,210904,210911,\
             210918,210925,211002,211009,211016,211023,211030,211106]
# Compiling the Turnstile Data and Calculating Entries and Exits
filtered_data = get_data(week_nums)
filtered_data.to_csv("filtered_data.csv",index = False)

# Filtering Station Data
filtered_station_data = filter_station_data("Stations.csv")
filtered_station_data.to_csv("filtered_stations.csv",index = False)

# Matching Turnstile Data with Station Coordinates
final_data = combine_data(filtered_data,filtered_station_data)
final_data.to_csv("final_data.csv",index = False)

# print("Data Filtering Done")

# The end result of this code is final_data.csv which has the columns DATE, STATION, ENTRIES, EXITS, Latitude, Longitude.


