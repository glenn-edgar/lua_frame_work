/*
**
** File tod_alarms.js
**
**
**
**
*/


var currentIndex;
var masterObject = {}
var alarmData

	

function getData()
{
  
  
  masterObject.inputs    = new Array();
  masterObject.inputs[0] = getTod();
  masterObject.backup       = toJson( masterObject.inputs );
  alarmData = getAlarmData();

}

function saveData()
{
    
    saveTodData(masterObject.inputs[0] );
    masterObject.backup       = toJson( masterObject.inputs );
    $("#save").attr("disabled", true);
}

function showFunctionInitial()
{
   var temp;
   currentIndex = 0;
   if( masterObject.init[ 0] == 0 )
   {
     masterObject.init[0] = 1;
    
   }
   initLocalControls( 0  );
   registerControlButtons( 0 );
   temp = "#edit-"+currentIndex;
   $(temp).hide();
   masterObject.tab_index = 0;
   drawLines(); 

}

function showFunction( event, tab)
{
   var temp;
   masterObject.tab_index = 0;
   drawLines(); 
 
}

function ready()
{
  var temp;
  temp = "#edit-"+currentIndex;
  $(temp).hide();

  masterObject = {}
  masterObject.maxNumber = 100
  masterObject.init  =  [0,0,0];
  masterObject.initFunctions     = [initTod ]
  masterObject.loadControl    = [ loadTod ];
  masterObject.loadCreate     =  [ todCreate ];
  masterObject.saveData       = [saveTod ];

  masterObject.drawLines = [  drawTod ] 
  getData();
  $("#reset").bind("click",resetData);
  $("#save").bind("click",saveData);
  showFunctionInitial()

}





$(document).ready( ready);


function getCurrentTab()
{
 
  return 0;
}


function getGurrentName( index)
{
  var temp;
  temp = ["TOD"]

  return temp[0];
}

function saveTodData( dataObject)
{
 
  parent.masterSave = 0;  
  pushJason( "/storeTxdFile.json?name=todalarm", dataObject ); 
  


}

/*
**
** Note: Need to normalize this data
**
**
**
**
*/
function getTod()
{ 
  var temp;

  temp = {};
  temp = getJsonFiltered("/getTxdFile.json?name=todalarm")   
  return temp;                       
}
function initTod()
{
  todSec = [  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,
             20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,
             40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59 ];
  todYear = [ 2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,
              2026,2027,2028,2029,2030,2031,2032 ];
  $("#edit-0-yearCheck").bind("click",yearFunction);
  $("#edit-0-dowCheck").bind("click",dowFunction);
  $("#edit-0-number").bind("keypress",numericInput);
}

function drawTod(index, dataElement)
{
     var temp;
   temp =  "<td>"+dataElement.number+"</td> <td>"+dataElement.name+"</td><td>"+dataElement.alarmNumber+"</td><td></td>"
   
   return temp;

}


function loadTod( data)
{
  $("#editTitle").html("Edit TOD #"+data.number)
  $("#edit-0-number").attr("value",data.number);
  $("#edit-0-name").attr("value",data.name);
 
  load_select_composite_values( "edit-0-alarmNumber" ,alarmData, data.alarmNumber);
  load_select( "edit-0-minutes", todSec, data.AlarmMinutes);
  load_select( "edit-0-seconds", todSec, data.AlarmSeconds);
  load_select( "edit-0-yearEntry",todYear, data.year);
  if( data.yearFlag == 0 )
  {
      $("#edit-0-yearCheck").attr("checked",false);
  }
  else
  {
    $("#edit-0-yearCheck").attr("checked",true);
  }
   if( data.DowFlag == 0 )
  {
      $("#edit-0-dowCheck").attr("checked",false);
  }
  else
  {
    $("#edit-0-dowCheck").attr("checked",true);
  }
  markBoxes( [ "#JANUARY", "#FEBRUARY", "#MARCH", "#APRIL", "#MAY", "#JUNE" , "#JULY" ,
               "#AUGUST" , "#SEPTEMBER" , "#OCTOBER" , "#NOVEMBER" , "#DECEMBER" ], data.alarmMonth);

  markBoxes(  [ "#dow-1" ,"#dow-2", "#dow-3", "#dow-4" ,"#dow-5", "#dow-6", "#dow-7",  // 0 -- 6
                null ,null, null, null ,null, null, null, // 7 - 13 spacers
                null,null, // 14-15 spacers
                "#dow-8","#dow-9","#dow-10","#dow-11", "#dow-12", "#last_week" ], data.todDay );

  markBoxes(  [ "#day-1", "#day-2", "#day-3", "#day-4", "#day-5", "#day-6", "#day-7", "#day-8", "#day-9",
                "#day-10", "#day-11", "#day-12", "#day-13", "#day-14", "#day-15", "#day-16",
                "#day-17", "#day-18", "#day-19", "#day-20", "#day-21", "#day-22", "#day-23", "#day-24", 
                "#day-25", "#day-26", "#day-27", "#day-28", "#day-29", "#day-30", "#day-31", "#edit-0-lastDay" ], data.todDay );


  markBoxes( [  "#hr-0", "#hr-1", "#hr-2", "#hr-3", "#hr-4", "#hr-5", "#hr-6", "#hr-7", "#hr-8", "#hr-9", 
                "#hr-10", "#hr-11", "#hr-12", "#hr-13", "#hr-14", "#hr-15", "#hr-16", "#hr-17", "#hr-18", 
                "#hr-19" , "#hr-20", "#hr-21", "#hr-22", "#hr-23" ], data.AlarmHours);
  yearFunction();
  dowFunctionInitial();

 
}


function todCreate()
{
 var data;
 data = {};
 data.number = findHoleElement()
 data.name   = "FILL ME IN";
 data.yearFlag=  1;
 data.year    = 2010;
 data.alarmMonth =  0;
 data.DowFlag  =     0;
 data.todDay   =     0;
 data.alarmNumber = 0;
 data.AlarmHours  =  0;
 data.AlarmMinutes =  0;
 data.AlarmSeconds = 0; 
 if( data.number == -1 )
 {
   alert("Exceeded Maximium Table Element")
 }
 else
 { 
   loadTod( data)
 }
 return data.number;
}

function saveTod( dataArray )
{
  var index;
  var data;
  var returnNumber;

  data = {};

  index = $("#edit-0-number").attr("value");
  data.number = index;
  data.name = $("#edit-0-name").attr("value");

  data.alarmNumber =  get_singleSelect( "edit-0-alarmNumber");
  data.AlarmMinutes = get_singleSelect( "edit-0-minutes");
  data.AlarmSeconds = get_singleSelect( "edit-0-seconds");
  data.year =         get_singleSelect( "edit-0-yearEntry");
  if( $("#edit-0-yearCheck").attr("checked") == false )
  {
      data.yearFlag=  0;
  }
  else
  {
    data.yearFlag=  1;
  }
   if(  $("#edit-0-dowCheck").attr("checked") == false )
  {
      data.DowFlag = 0;
  }
  else
  {
    data.DowFlag = 1;
   
  }
  data.alarmMonth = 
  recordBoxes( [ "#JANUARY", "#FEBRUARY", "#MARCH", "#APRIL", "#MAY", "#JUNE" , "#JULY" ,
               "#AUGUST" , "#SEPTEMBER" , "#OCTOBER" , "#NOVEMBER" , "#DECEMBER" ]);

  if( data.DowFlag == 1)
  {
    data.todDay = 
    recordBoxes(  [ "#dow-1" ,"#dow-2", "#dow-3", "#dow-4" ,"#dow-5", "#dow-6", "#dow-7",
                null ,null, null, null ,null, null, null, // 7 - 13 spacers
                null,null, // 14-15 spacers

                "#dow-8","#dow-9","#dow-10","#dow-11", "#dow-12", "#last_week" ] );
  }
  else
  {

  data.todDay = 
  recordBoxes(  [ "#day-1", "#day-2", "#day-3", "#day-4", "#day-5", "#day-6", "#day-7", "#day-8", "#day-9",
                "#day-10", "#day-11", "#day-12", "#day-13", "#day-14", "#day-15", "#day-16",
                "#day-17", "#day-18", "#day-19", "#day-20", "#day-21", "#day-22", "#day-23", "#day-24", 
                "#day-25", "#day-26", "#day-27", "#day-28", "#day-29", "#day-30", "#day-31", "#edit-0-lastDay" ]);
  }

  data.AlarmHours =
  recordBoxes( [  "#hr-0", "#hr-1", "#hr-2", "#hr-3", "#hr-4", "#hr-5", "#hr-6", "#hr-7", "#hr-8", "#hr-9", 
                "#hr-10", "#hr-11", "#hr-12", "#hr-13", "#hr-14", "#hr-15", "#hr-16", "#hr-17", "#hr-18", 
                "#hr-19" , "#hr-20", "#hr-21", "#hr-22", "#hr-23" ]);
  returnNumber = 0;
  if( data.number > masterObject.maxNumber )
  { 
    alert("Number field is to large ")
    returnNumber = -1;  
    return returnNumber;
  }
  if( dataArray[ data.number ] != null )
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

  dataArray[ index] = data;
  return returnNumber;
}

function yearFunction()
{
 if( $("#edit-0-yearCheck").attr("checked") == false)
 {
   /*$("#enterYear").show();*/
   $("#edit-0-yearEntry").attr("disabled", false);
 }
 else
 {
   /*$("#enterYear").hide();*/
   $("#edit-0-yearEntry").attr("disabled", true);
 }

}

function dowFunctionInitial()
{
  
  if(  $("#edit-0-dowCheck").attr("checked") == false)
  {
    $("#dayOfWeekTable").hide();
    $("#dayTable").show();
    $("#dayTable_a").show();
  }
  else
  {
     $("#dayOfWeekTable").show();
     $("#dayTable").hide();
     $("#dayTable_a").hide();
  }
}


function dowFunction()
{
  
  if(  $("#edit-0-dowCheck").attr("checked") == false)
  {
    $("#dayOfWeekTable").hide();
    $("#dayTable").show();
    $("#dayTable_a").show();
  }
  else
  {
     $("#dayOfWeekTable").show();
     $("#dayTable").hide();
     $("#dayTable_a").hide();
  }
 markBoxes(  [ "#dow-1" ,"#dow-2", "#dow-3", "#dow-4" ,"#dow-5", "#dow-6", "#dow-7",  // 0 -- 6
                null ,null, null, null ,null, null, null, // 7 - 13 spacers
                null,null, // 14-15 spacers
                "#dow-8","#dow-9","#dow-10","#dow-11", "#dow-12", "#last_week" ], 0 );

  markBoxes(  [ "#day-1", "#day-2", "#day-3", "#day-4", "#day-5", "#day-6", "#day-7", "#day-8", "#day-9",
                "#day-10", "#day-11", "#day-12", "#day-13", "#day-14", "#day-15", "#day-16",
                "#day-17", "#day-18", "#day-19", "#day-20", "#day-21", "#day-22", "#day-23", "#day-24", 
                "#day-25", "#day-26", "#day-27", "#day-28", "#day-29", "#day-30", "#day-31", "#edit-0-lastDay" ], 0);
}


function markBoxes( elementArray, binaryData)
{
  var index;
  var mask;
  var returnValue;

  mask = 1;
  for( index = 0 ; index < elementArray.length; index++)
  {
    if( $(elementArray[index]) != null )
    {

      if( (binaryData & mask) == 0 )
      {
         $(elementArray[index]).attr("checked",false);
      }
      else
      {
         $(elementArray[index]).attr("checked",true);
      }
      
    }
    mask = mask << 1;
  }
}  

function recordBoxes( elementArray)
{
  var index;
  var mask;
  var returnValue;

  mask = 1;
  returnValue = 0;
  for( index = 0 ; index < elementArray.length; index++)
  {
    if( $(elementArray[index]) != null )
    {
      if( $(elementArray[index]).attr("checked") == true)
      {
         returnValue = returnValue | mask;
      }
    }
    mask = mask << 1;
  }
  return returnValue;
}  


