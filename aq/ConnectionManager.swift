//
//  ConnectionManager.swift
//  aq
//
//  Created by Ye on 14-7-6.
//  Copyright (c) 2014 Joseph Williamson. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import UIKit

class ConnectionManager: NSObject, NSURLConnectionDelegate {
    
    
    // json data
    @lazy var allSitesData = NSMutableData()
    
    // GET LIST OF AQ SITES IN LONDON
    var getAllSites = "http://api.erg.kcl.ac.uk/AirQuality/Hourly/MonitoringIndex/GroupName=London/Json"
    var allSitesConnection : NSURLConnection?
    var allSitesJson : NSDictionary?
    var mySiteData : MySite[] = []
    
    var closeSiteData : MySite[] = []
    var siteCount = 0
    var filterCount = 0
    var isSiteDone = false
    var isFilterDone = false
    
    // GET TODAY'S DATA
    var todayDate : MyDate?
    var tmrDate : MyDate?
    
    var dateArray : String[] = []
    var stringArray : String[] = []
    var dateArrayTmr : String[] = []
    var stringArrayTmr : String[] = []
    
    // date filter
    var dateFilterCode = "TH2"
    var dateFilterNum = 18
    var dateFilter : MySite[] = []
    var dateCount = 0
    var isDateDone = false
    
    // home
    var homeCount = 0
    var isHomeDone = false
    var homeFilter : MySite[] = []
    var myArray: NSArray?
    
    var isCurrentLocation = false
    var currentLocation = CLLocation(latitude: 51.5269386728267, longitude: -0.130113839901585)
    var currentData = Filter(data: -1, label: "", loc1: "", loc2: "London", time1: "NO2 µg/m3", time2: "", code: "")
    
    var isDone : Bool = false
    
    var filterSites = [ MySite(code: "TH5", name: "Victoria", location: CLLocation(latitude: 51.5405194915241, longitude: -0.03330738887), distance: -1, url: "", connection : nil, data: -1, returnData : NSMutableData() ),
        MySite(code: "MY7", name: "Marylebone", location: CLLocation(latitude: 51.52254, longitude: -0.15459), distance: -1, url: "", connection : nil, data: -1, returnData : NSMutableData() ),
        MySite(code: "TH2", name: "Mile End", location: CLLocation(latitude: 51.5225294860844, longitude: -0.0421550991900347), distance: -1, url: "", connection : nil, data: -1, returnData : NSMutableData() ),
        MySite(code: "BL0", name: "Bloomsbury", location: CLLocation(latitude: 51.522287, longitude: -0.125848), distance: -1, url: "", connection : nil, data: -1, returnData : NSMutableData() ),
        MySite(code: "GB6", name: "Greenwich", location: CLLocation(latitude: 51.482577, longitude: -0.007659), distance: -1, url: "", connection : nil, data: -1, returnData : NSMutableData() ),
        MySite(code: "EN4", name: "Enfield", location: CLLocation(latitude: 51.614693, longitude: -0.051184), distance: -1, url: "", connection : nil, data: -1, returnData : NSMutableData() ),
        MySite(code: "HK6", name: "Old Street", location: CLLocation(latitude: 51.526454, longitude: -0.08491), distance: -1, url: "", connection : nil, data: -1, returnData : NSMutableData() ),
        MySite(code: "IM1", name: "Holborn", location: CLLocation(latitude: 51.5173675146177, longitude: -0.1201947113171), distance: -1, url: "", connection : nil, data: -1, returnData : NSMutableData() ),
        MySite(code: "SK6", name: "ElephantCastle", location: CLLocation(latitude: 51.482577, longitude: -0.007659), distance: -1, url: "", connection : nil, data: -1, returnData : NSMutableData() )]
    
    
    
    
    
    //var currentData = Filter(data: 80, label: "", loc1: "Euston", loc2: "London", time1: "NO2 µg/m3", time2: "")
    class var sharedInstance : ConnectionManager {
        
    struct Static {
        static let instance : ConnectionManager = ConnectionManager()
        }
        return Static.instance
    }
    
    
    
    func setCurrentLocation(lat: CLLocationDegrees, lng: CLLocationDegrees){
        currentLocation = CLLocation(latitude: lat, longitude: lng)
        //println(currentLocation.coordinate.latitude)
        // check the closest site
        
        
        isCurrentLocation = true
        if(isDone){
            isDone = false
            checkClosest(mySiteData)
        }
        
        checkFilterSites(filterSites)
        
    }
    
    func initData(){
        
        getDate()
        getHomeViewCode()
        // get all sites
        startConnection(getAllSites)
        initDateFilter()
    }
    
    func initDateFilter(){
        
        dateCount = 0
        isDateDone = false
        
        dateFilter = []
        
        for var index = 0; index < dateArray.count; ++index{

            var url = "http://api.erg.kcl.ac.uk/AirQuality/Data/Site/SiteCode=TH2/StartDate=" + dateArray[index] + "/EndDate=" + dateArrayTmr[index] + "/Json"
            
            // connection
            var myurl: NSURL = NSURL(string: url)
            var request: NSURLRequest = NSURLRequest(URL: myurl)
            var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
            
            dateFilter += MySite(code: dateFilterCode, name: currentData.loc1, location: currentLocation, distance: -1, url: url, connection : connection, data: -1, returnData : NSMutableData() )
        }
        println("finish")
        startConn(dateFilter)
    }
    
    func getHomeViewCode(){
        
        getMyArray()
        
        homeCount = 0
        isHomeDone = false
        
        let day1 = todayDate?.dateString
        let day2 = tmrDate?.dateString
        
        for var index = 0; index < myArray?.count; ++index{
            
            let code = (myArray?.objectAtIndex(index) as MyPhoto).code
            var url = "http://api.erg.kcl.ac.uk/AirQuality/Data/Site/SiteCode=" + code! + "/StartDate=" + day1! + "/EndDate=" + day2! + "/Json"
            println(code)
            println(url)
            // connection
            var myurl: NSURL = NSURL(string: url)
            var request: NSURLRequest = NSURLRequest(URL: myurl)
            var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
            
            homeFilter += MySite(code: code, name: "london", location: currentLocation, distance: -1, url: url, connection : connection, data: -1, returnData : NSMutableData() )
            
        }
        println(" \(homeFilter.count)")
        startConn(homeFilter)
        
        
    }
    
    func getMyArray(){
        
        // core data
        var appDelegate = UIApplication.sharedApplication().delegate
        var contextStore = (appDelegate as AppDelegate).managedObjectContext
        
        var fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "MyPhoto")
        var myEntityDescription = NSEntityDescription.entityForName("MyPhoto", inManagedObjectContext: contextStore)
        
        var error: NSError? = nil
        myArray = contextStore.executeFetchRequest(fetchRequest, error: &error)
        
    }
    func getAddedHomeViewCode(){
        
        getMyArray()
        
        homeCount = 1
        isHomeDone = false
        
        let day1 = todayDate?.dateString
        let day2 = tmrDate?.dateString
        
        var num = myArray?.count
        let index = num! - 1
        
        let code = (myArray?.objectAtIndex(index) as MyPhoto).code
        var url = "http://api.erg.kcl.ac.uk/AirQuality/Data/Site/SiteCode=CD9/StartDate=2014-06-07/EndDate=2014-06-08/Json"
        
        // connection
        var myurl: NSURL = NSURL(string: url)
        var request: NSURLRequest = NSURLRequest(URL: myurl)
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        
        homeFilter += MySite(code: code, name: "london", location: currentLocation, distance: -1, url: url, connection : connection, data: -1, returnData : NSMutableData() )
        println("add \(homeFilter.count)")
        (homeFilter[index].connection as NSURLConnection).start()
        
    }
    
    func newDate(date: NSDate) -> MyDate {
        
        var dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // get 7 Jul ....
        //dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        //dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        var myString : String = dateFormatter.stringFromDate(date)
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        var todayString : String = dateFormatter.stringFromDate(date)
        
        var calendar = NSCalendar.currentCalendar()
        var components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear, fromDate: date)
        
        return MyDate(year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute, dateString: myString, todayString: todayString)
        
    }
    
    func initArray(date: NSDate, type: Int){
        
        var calendar = NSCalendar.currentCalendar()
        var components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitDay | .CalendarUnitYear, fromDate: date)
        
        var year = components.year
        var month = components.month
        var day = components.day
        
        for var index = 1; index < month; ++index{
            
            var string = String(year) + "-" + String(month-index) + "-" + String(day)
            var newDay = NSDate(dateString: string)
            
            var dateFormatter : NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if(type == 0){
                dateArray += dateFormatter.stringFromDate(newDay)
            }
            else if(type == 1){
                dateArrayTmr += dateFormatter.stringFromDate(newDay)
            }
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            if(type == 0){
                stringArray += dateFormatter.stringFromDate(newDay)
            }
            else if(type == 1){
                stringArrayTmr += dateFormatter.stringFromDate(newDay)
            }
        }
        
        for var index = 0; index < dateFilterNum; ++index {
            
            var string = String(year-index-1) + "-" + String(month) + "-" + String(day)
            var newDay = NSDate(dateString: string)
            
            var dateFormatter : NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if(type == 0){
                dateArray += dateFormatter.stringFromDate(newDay)
            }
            else if(type == 1){
                dateArrayTmr += dateFormatter.stringFromDate(newDay)
            }
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            if(type == 0){
                stringArray += dateFormatter.stringFromDate(newDay)
            }
            else if(type == 1){
                stringArrayTmr += dateFormatter.stringFromDate(newDay)
            }
            
        }
        
    }
    
    func checkFilterSites(array: MySite[]){
        
        filterCount = 0
        isFilterDone = false
        calculateData(array)
        startConn(array)
    }
    
    
    func checkClosest(array: MySite[]){
        
        siteCount = 0
        isSiteDone = false
        
        calculateData(array)
        sortByDistance(array)
        reverseArray(array)
        (array[0].connection as NSURLConnection).start()
        //startConn(array)
        // calculate distance for all sites
        
    }
    
    func calculateData(array: MySite[]){
        
        let day1 = todayDate?.dateString
        let day2 = tmrDate?.dateString
        
        // calculate distance for all sites
        for var index = 0; index < array.count; ++index{
            
            // distance
            array[index].distance = currentLocation.distanceFromLocation(array[index].location) * 0.000621371
            
            // url
            let siteCode = array[index].code
            var url = "http://api.erg.kcl.ac.uk/AirQuality/Data/Site/SiteCode=" + siteCode! + "/StartDate=" + day1! + "/EndDate=" + day2! + "/Json"
            array[index].url = url
            array[index].returnData.length = 0
            
            // connection
            var myurl: NSURL = NSURL(string: url)
            var request: NSURLRequest = NSURLRequest(URL: myurl)
            array[index].connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
        }
    }
    
    func sortByData(array: MySite[]){
    
        array.sort({
            (one, two) -> Bool in
            return one.data > two.data
        })
    }
    func sortByDistance(array: MySite[]){
    
        array.sort({
            (one, two) -> Bool in
            return one.distance > two.distance
        })
    }
    
    func reverseArray(array: MySite[]){
        
        // reverse the sorted array
        for var index = 0; index < array.count/2; ++index{
            var temp : MySite = array[index]
            array[index] = array[array.count - 1 - index]
            array[array.count - 1 - index] = temp
        }
    }
    
    
    func startConn(array: MySite[]){
        
        for var index = 0; index < array.count; ++index{
            (array[index].connection as NSURLConnection).start()
        }
    }
    
    func startConnection(myUrl: String){
        
        var url: NSURL = NSURL(string: myUrl)
        var request: NSURLRequest = NSURLRequest(URL: url)
        
        if myUrl == getAllSites {
            allSitesConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)
            (allSitesConnection as NSURLConnection).start()
        }
        
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        if connection == allSitesConnection {
            self.allSitesData.appendData(data)
        }
        else{
            
            for var index = 0; index < mySiteData.count; ++index{
                if connection == mySiteData[index].connection {
                    mySiteData[index].returnData.appendData(data)
                    break
                }
            }
            for var index = 0; index < filterSites.count; ++index{
                if connection == filterSites[index].connection {
                    filterSites[index].returnData.appendData(data)
                    break
                }
            }
            for var index = 0; index < dateFilter.count; ++index{
                if connection == dateFilter[index].connection {
                    dateFilter[index].returnData.appendData(data)
                    break
                }
            }
            for var index = 0; index < homeFilter.count; ++index{
                if connection == homeFilter[index].connection {
                    homeFilter[index].returnData.appendData(data)
                    break
                }
            }
        }
        /*
        else if(connection == todayConnection){
        self.todaysData.appendData(data)
        }
        
        */
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        //println("connectionDidFinishLoading")
        
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        if(connection == allSitesConnection){
            allSitesJson = NSJSONSerialization.JSONObjectWithData(allSitesData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
            
            var tempArray = allSitesJson?.objectForKey("HourlyAirQualityIndex").objectForKey("LocalAuthority") as NSArray
            
            for var index = 0; index < tempArray.count; ++index {
                
                if(tempArray[index].objectForKey("Site")){
                    
                    if( tempArray[index].objectForKey("Site").isKindOfClass(NSArray)){
                        
                        var tempSites = tempArray[index].objectForKey("Site") as NSArray
                        for var j = 0; j < tempSites.count; ++j {
                            
                            var temp = initMySite(tempSites[j] as NSDictionary) as MySite
                            mySiteData += temp
                        }
                    }
                    else{
                        var temp = initMySite(tempArray[index].objectForKey("Site") as NSDictionary) as MySite
                        mySiteData += temp
                    }
                }
            }
            isDone = true
            
            println(mySiteData.count)
            
            // paris
            checkClosest(mySiteData)
            //allSitesData = allSitesArray as Array
            
        }
        else{
            receiveData(connection, array: mySiteData, type: 0)
            receiveData(connection, array: filterSites, type: 1)
            receiveData(connection, array: dateFilter, type: 2)
            receiveData(connection, array: homeFilter, type: 3)
            
            //println("index: \(index) \(mySiteData.count)")
            
            if (siteCount == 1 && !isSiteDone) {
                
                isSiteDone = true
                /*
                sortByData(mySiteData)
                println("mySiteData \(index) \(mySiteData.count)")
                for var j = 0; j < mySiteData.count; ++j{
                    println("index: \(j) \(mySiteData[j].data) \(mySiteData[j].code) \(mySiteData[j].name)")
                }*/
                
            }
            if (filterCount == filterSites.count && !isFilterDone) {
                
                isFilterDone = true
                sortByDistance(filterSites)
                reverseArray(filterSites)
                println("filter")
                for var j = 0; j < filterSites.count; ++j{
                    println("index: \(j) \(filterSites[j].data) \(filterSites[j].code) \(filterSites[j].distance)")
                }
            }
            if (dateCount == dateFilter.count && !isDateDone){
                isDateDone = true
                println("date")
                for var j = 0; j < dateFilter.count; ++j{
                    println("index: \(j) \(dateFilter[j].data)")
                }
            }
            if (homeCount == homeFilter.count && !isHomeDone){
                isHomeDone = true
                println("home")
                for var j = 0; j < homeFilter.count; ++j{
                    println("index: \(j) \(dateFilter[j].data)")
                }
            }

        }
    }
    
    func receiveData(connection: NSURLConnection!, array: MySite[], type: Int){
        
        for var index = 0; index < array.count; ++index{
            if (connection == (array[index] as MySite).connection) {
                
                if type == 1 {
                    ++filterCount
                }
                else if type == 0{
                    ++siteCount
                }
                else if type == 2{
                    ++dateCount
                }
                else if type == 3{
                    ++homeCount
                }
                
                var json = NSJSONSerialization.JSONObjectWithData(array[index].returnData, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary
                var tempArray = json?.objectForKey("AirQualityData").objectForKey("Data") as NSArray
                
                for var j = tempArray.count - 1; j >= 0; --j {
                    
                    if(type == 2){
                        
                        var str = tempArray[j].objectForKey("@MeasurementDateGMT") as NSString
                        var arr = str.substringWithRange(NSRange(location: 11,length: 8))
                        //println(arr)
                        
                        if(tempArray[j].objectForKey("@SpeciesCode") as NSString == "NO2" && tempArray[j].objectForKey("@Value") as NSString != "" && arr == "18:00:00"){
                            
                            var temp = tempArray[j] as? NSDictionary
                            var data = NSDecimalNumber.decimalNumberWithString((temp as NSDictionary).objectForKey("@Value") as NSString)
                            array[index].data = Int(data)
                            break
                        }
                    }
                    else{
                        
                        if(tempArray[j].objectForKey("@SpeciesCode") as NSString == "NO2" && tempArray[j].objectForKey("@Value") as NSString != ""){
                            
                            var temp = tempArray[j] as? NSDictionary
                            var data = NSDecimalNumber.decimalNumberWithString((temp as NSDictionary).objectForKey("@Value") as NSString)
                            
                            if(index == 0 && type == 0){
                                currentData.data = Int(data)
                                //currentData.loc1 = mySiteData[index].name
                                currentData.code = mySiteData[index].code!
                            }
                            
                            array[index].data = Int(data)
                            //println(Int(data))
                            break
                        }
                    }
                    
                }
                break
            }
        }
    }
    
    func getDate(){
        
        // get today's data
        // today
        var today = NSDate()
        todayDate = newDate(today)
        currentData.time2 = todayDate?.todayString
        // yesterday
        var tomorrow = today.dateByAddingTimeInterval(24*60*60)
        tmrDate = newDate(tomorrow)
        
        initArray(today, type: 0)
        initArray(tomorrow, type: 1)
    }
    
    func initMySite(data: NSDictionary) -> MySite {
        
        var siteCode = data.objectForKey("@SiteCode") as String
        var siteName = data.objectForKey("@SiteName") as String
        var latitude = NSDecimalNumber.decimalNumberWithString(data.objectForKey("@Latitude") as NSString)
        var longitude = NSDecimalNumber.decimalNumberWithString(data.objectForKey("@Longitude") as NSString)
        var tempLocation = CLLocation(latitude: CDouble(latitude), longitude: CDouble(longitude))
        return MySite(code: siteCode, name: siteName, location: tempLocation, distance: -1, url: "", connection : nil, data: -1, returnData : NSMutableData() )
        
    }
    
    
}

struct MyDate {
    var year = 0
    var month = 0
    var day = 0
    var hour = 0
    var minute = 0
    var dateString = "2014-06-18"
    var todayString = "27 July"
    
}


extension NSDate
    {
    convenience
        init(dateString:String) {
            let dateStringFormatter = NSDateFormatter()
            dateStringFormatter.dateFormat = "yyyy-MM-dd"
            dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            let d = dateStringFormatter.dateFromString(dateString)
            self.init(timeInterval:0, sinceDate:d)
    }
}


struct MySite{
    var code : String?
    var name : String?
    var location : CLLocation?
    var distance : CLLocationDistance?
    var url : String?
    var connection : NSURLConnection?
    var data = -1
    @lazy var returnData = NSMutableData()
}


