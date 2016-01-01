/*

  File system_setup.js
  This is the script file for system_setup.html

*/

var dataObject;
var alarmNumber;
var timeZones;
var timeZoneStrings; 
var timeZoneValues;  
var timeZoneIndex;
var referenceJsonString;
var lowBatteryThresholdArray;
// Tabs

$(function() {
		$("#tabs").tabs();
	});


function generateDefaultData()
{
  var returnValue;

  returnValue = {}
  returnValue.chainName = ""
  returnValue.storeName = ""
  returnValue.lowBatteryAlarm = 1;
  returnValue.inactiveCallBox = 1;
  returnValue.timeZone = ""
  returnValue.lowBatteryThreshold = 5;
  return returnValue
}

function getData()
{
   var tempObject;
   // make ajax call
   /* 
      temporary Hack
   */
  
   alarmNumber = getAlarmData();
   alarmNumber[0] = [ "none","null"]
  
   dataObject = getJson("/getTxdFile.json?name=misc")   
   if( dataObject == null )
   {
     dataObject = generateDefaultData()
   }
   
   timeZones = getJson("/javaScript/timeZone.json");
   lowBatteryThresholdArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];
}


function splitTimeZoneStrings()
{
   var i;
   var temp;

   timeZoneStrings = new Array();
   timeZoneValues  = new Array();

   for( i= 0; i < timeZones.length; i++)
   {
       temp = timeZones[i]
       timeZoneStrings[i] = temp[0];
       timeZoneValues[i] = temp[1];
  } 
}

function findataObjectdTimeZoneIndex()
{
   timeZoneIndex = 0;
   
   for( i=0; i< timeZoneValues.length; i++)
   {
     if( dataObject.timeZone == timeZoneValues[i] )
     {
        timeZoneIndex = i;
        break;
     }
  }


}



function loadControls()
{

   $("#chainName").attr("value",dataObject.chainName);
   $("#storeName").attr("value",dataObject.storeName);
   load_select_composite_values( "LowBattery" , alarmNumber, dataObject.lowBatteryAlarm);
   load_select_composite_values( "InactiveCallBox" ,alarmNumber,dataObject.inactiveCallBox);
   
   load_select_values("timeZone", timeZoneStrings, timeZoneValues, dataObject.timeZone );
  
   load_select_a("LowBatteryThreshold",lowBatteryThresholdArray,dataObject.lowBatteryThreshold);
  
}


function ready()
{
  

   $("#storeName").bind("keypress",numericInput);
   getData()
   splitTimeZoneStrings();
   findataObjectdTimeZoneIndex();
   
   referenceObjectToJson( dataObject )
   loadControls();
   timeZoneClick()
   // data if from misc.txd
   $('#save').bind('click',saveButton );
   $('#reset').bind('click',clearButton );
   $("#timeZone").bind("click",timeZoneClick);
  
}




function saveButton()
{
   var tempObject;
   
   dataObject.chainName = $("#chainName").attr("value");
   dataObject.storeName = $("#storeName").attr("value");
   dataObject.lowBatteryAlarm = $("#LowBattery").attr("value");
   dataObject.inactiveCallBox = $("#InactiveCallBox").attr("value");
   dataObject.timeZone = $("#timeZone").attr("value");
   dataObject.lowBatteryThreshold = $("#LowBatteryThreshold").attr("value");
   pushJason( "/storeTxdFile.json?name=misc", dataObject );
   referenceObjectToJson( dataObject )
}

function clearButton()
{
 
   dataObject = reloadObject();
   loadControls();
}

function timeZoneClick()
{
  var value;
  
  value = get_singleSelect( "timeZone" );
  $("#timeZoneString").html(value)
}





function referenceObjectToJson( temp)
{
  referenceJsonString = JSON.stringify( temp );

}


function reloadObject()
{
   return JSON.parse( referenceJsonString );
   
}

$(document).ready( ready);



