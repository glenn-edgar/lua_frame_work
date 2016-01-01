/*
**
** File: alarm.js
**
**
**
**
**
**
*/


/*
**
** Top level control
**
**
**
**
**
**
*/

var currentIndex;
var masterObject = {}
var routingData
var tempScriptName;
var tempScriptParameters;
var tempPermissions;

	

function getData()
{
  
  
  masterObject.inputs            = new Array();

  masterObject.inputs[0]         = loadAlarmObject();
  masterObject.backup       = toJson( masterObject.inputs );
 

}

function saveData()
{
    parent.masterSave = 0;
    saveAlarmObject(masterObject.inputs[0]);
    $("#save").attr("disabled", true);
}

function showFunction( event, tab)
{
   var temp;
   masterObject.tab_index = tab.index;
   drawLines(); 
 
}

function ready()
{

  masterObject = {}
  masterObject.maxNumber = 999
  masterObject.init  =  [0];
  masterObject.initFunctions     = [ initAlarms ]
  masterObject.loadControl    = [ loadAlarmData ];
  masterObject.loadCreate     =  [ loadCreate ];
  masterObject.saveData       = [ saveAlarmdata ];

  masterObject.drawLines = [ drawAlarms ] 
  getData();
  $("#reset").bind("click",resetData);
  $("#save").bind("click",saveData);
  
   currentIndex = 0;
   if( masterObject.init[ 0] == 0 )
   {
     masterObject.init[0] = 1;
    
   }
   initLocalControls( 0  );
   registerControlButtons( 0 );
   temp = "#edit-"+currentIndex;
   $(temp).hide();
   
   drawLines(); 
   add_alarm_tooltips();
}





$(document).ready( ready);
$(function(){

// Tabs
var tabOpts = 
{
   show: showFunction
};
$('#tabs').tabs( tabOpts );

});


function getCurrentTab()
{
 
  return 0;
}

function getGurrentName( index)
{
  var temp;
  temp = ["ALARM"]

  return temp[index];
}




/*
**
**  Control for alarm tables
**
**
**
**
**
**
**
**
*/

function initAlarms()
{
  
  
   routingData = getRouteData()
  audio_msg = getJson("/waveArray.json");

   $("#ALARM_NUMBER").bind("keypress",numericInput);
}




function saveAlarmObject(dataObject)
{
    pushJason( "/storeTxdFile.json?name=alarms", dataObject ); 
}



function loadAlarmObject()
{
var temp;

  temp = {};
  temp = getJsonFiltered("/getTxdFile.json?name=alarms")   

  return temp;           
}









function editSaveReturn()
{

  workingObject[currentNumber].name = $("#ALARM_NAME").attr("value");
  workingObject[currentNumber].alphaSet = $("#ALPHA_SET").attr("value")
  workingObject[currentNumber].audioSet = $("#AUDIO_SET").attr("value")
  workingObject[currentNumber].alphaClear = $("#ALPHA_CLEAR").attr("value")
  workingObject[currentNumber].audioClear = $("#AUDIO_CLEAR").attr("value")
  workingObject[currentNumber].repageInterval= $("#REPAGE_INTERVAL").attr("value")
  workingObject[currentNumber].alarmTimeOut = $("#ALARM_TIMEOUT").attr("value")
  workingObject[currentNumber].route  = $("#ROUTE").attr("value")
  if( $("#PAGE_TIL_CLEARED").attr("checked") == true )
  {
         workingObject[currentNumber].pageTilClear = 1;
  }
  else
  {
        workingObject[currentNumber].pageTilClear = 0;
  }

  $("#NAME"+ workingObject[currentNumber].number).html(workingObject[currentNumber].name)
  $("#INTERVAL"+ workingObject[currentNumber].number).html(workingObject[currentNumber].repageInterval)
  $("#TIMEOUT"+ workingObject[currentNumber].number).html(workingObject[currentNumber].alarmTimeOut)
  $("#ROUTE"+ workingObject[currentNumber].number).html(workingObject[currentNumber].route)
  $("#displayDiv").show()
  $("#editDiv").hide() 
  stripTable();

}




 
function drawAlarms(index, data )
{
 
  temp =     '<td>'+data.number+'</td><td id= "NAME'+data.number +'" >'+data.name+'</td> '
  temp = temp +    '<td id= "INTERVAL'+data.number +'" >'+data.repageInterval+'</td> '
  temp = temp +    '<td id= "TIMEOUT'+data.number +'" >'+data.alarmTimeout+'</td> '
  temp = temp +    '<td id= "ROUTE'+data.number +'" >'+data.route+'</td><td></td> '

  return temp;
}

function loadCreate()
{
  var data;
  data = {};
  data.key = "number"
  data.number = 1000;
  data.name = "Fill Me In";
  data.scriptName = "";
  data.scriptParameters = "";
  data.alphaSet  = "Fill Me In";
  data.alphaClear = "Fill Me In"
  data.repageInterval = 45;
  data.alarmTimeout   = 5;
  data.pageTilClear   = 1;
  data.route = null;
  data.audioSet = null
  data.audioClear = null;
  data.scriptName = "";
  data.scriptParameters = "";
  data.permissions      = 0;


  data.number = findHoleElement()
  if( data.number == -1 )
  {
    alert("exceeded the maximium table elements")
  }
  else
  {
    loadAlarmData( data);
  }
  return data.number;
}

function loadAlarmData( data )
{
    
    $("#editTitle").html("Edit Alarm #"+data.number)
    if( data.scriptName != "" )
    {
      $("#SCRIPT_NAME").html("Script Name: "+data.scriptName)
      $("#SCRIPT_PARMETERS").html("Script Parameter: "+data.scriptParameters)
    }
    else
    {
      $("#SCRIPT_NAME").html("")
      $("#SCRIPT_PARMETERS").html("")
    }
    $("#ALARM_NUMBER").attr("value",data.number);
    $("#ALARM_NAME").attr("value", data.name  )
    $("#ALPHA_SET").attr("value", data.alphaSet )
    $("#ALPHA_CLEAR").attr("value", data.alphaClear)
    $("#REPAGE_INTERVAL").attr("value", data.repageInterval)
    $("#ALARM_TIMEOUT").attr("value", data.alarmTimeout)
    if( data.pageTilClear != 0 )
    {

           $("#PAGE_TIL_CLEARED").attr("checked",true);
    }
    else
    {
          $("#PAGE_TIL_CLEARED").attr("checked",false);
    }
    
    load_select( "AUDIO_SET", audio_msg, data.audioSet)
    load_select( "AUDIO_CLEAR",audio_msg, data.audioClear)
    load_select_composite_values( "ROUTE", routingData, data.route)
    tempScriptName = data.scriptName
    tempScriptParameters = data.scriptParameters
    tempPermissions = data.permissions

}

function saveAlarmdata( alarmArray )
{
  var index;
  var returnNumber;
  var data
 
  index = $("#ALARM_NUMBER").attr("value");
  index = parseInt(index);
  
  data = {};
  data.number = index;
  data.name = $("#ALARM_NAME").attr("value");
  data.alphaSet = $("#ALPHA_SET").attr("value")
  data.audioSet = $("#AUDIO_SET").attr("value")
  data.alphaClear = $("#ALPHA_CLEAR").attr("value")
  data.audioClear = $("#AUDIO_CLEAR").attr("value")
  data.repageInterval= $("#REPAGE_INTERVAL").attr("value")
  data.alarmTimeout = $("#ALARM_TIMEOUT").attr("value")
  data.route  = $("#ROUTE").attr("value")
  data.scriptName = tempScriptName;
  data.scriptParameters = tempScriptParameters;
  data.permissions      = tempPermissions;
  if( $("#PAGE_TIL_CLEARED").attr("checked") == true )
  {
        data.pageTilClear = 1;
  }
  else
  {
        data.pageTilClear = 0;
  }
  returnNumber = 0;
  if( data.number > masterObject.maxNumber )
  { 
    alert("Number field is to large ")
    returnNumber = -1;  
    return returnNumber;
  }
  if( alarmArray[index] != null )
  {
    if( confirm("Over write existing item") )
    {
       returnNumber = 0;
    }
    else
    {
      returnNumber = -1;
      return returnNumber;
    }
  }
  alarmArray[index] = data;
  return returnNumber;


}

