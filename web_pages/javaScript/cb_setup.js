/*
**
**  File: cb_setup.js
**  Java Script Setup
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
  masterObject.inputs[0] = get_CB_Data();
  masterObject.backup       = toJson( masterObject.inputs );
  alarmData =  getAlarmData();

}

function saveData()
{
    
    save_CB_Data(masterObject.inputs[0] );
    masterObject.backup       = toJson( masterObject.inputs );
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

   drawLines(); 

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
  masterObject.init  =  [0,0,0];
  masterObject.initFunctions     = [initInputs ]
  masterObject.loadControl    = [ loadInput ];
  masterObject.loadCreate     =  [ inputCreate ];
  masterObject.saveData       = [saveInput ];

  masterObject.drawLines = [  drawInputs ] 
  getData();
  $("#reset").bind("click",resetData);
  $("#save").bind("click",saveData);
  showFunctionInitial()

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

  return temp[0];
}

function save_CB_Data( dataObject)
{
 
  parent.masterSave = 0;
  pushJason( "/storeTxdFile.json?name=inputs", dataObject ); 
  $("#save").attr("disabled", true);

}




function get_CB_Data()
{
 var temp;

  temp = {};
  temp = getJsonFiltered("/getTxdFile.json?name=inputs")   

  return temp;                       
}




function drawInputs( index , dataElement)
{
   var temp;
   temp =  "<td>"+dataElement.number+"</td><td>"+dataElement.name+"</td><td>"+dataElement.alarmNumber+"</td><td></td>"
   
   return temp;
}

function initInputs()
{  
   $("#editNumber-0").bind("keypress",numericInput);
}

function inputCreate()
{
  var data;
  data = {}
  
  data.name = "FILL ME IN";
  data.number = findHoleElement()
  data.alarmNumber = 0
  data.wired = 0
  data.setDelay = 0
  data.clearDelay = 0
  data.debounce = 0
  data.activeLow = 0
  data.lowBattery = 0
  data.notUsed = 0
  data.setCnt = 0
  data.clearCnt = 0
  data.enableTime =0
  data.disableTime = 0
  if( data.number == -1 )
  {
    alert("exceeded the maximium table elements")
  }
  else
  {
   loadInput(data)
  }
  return data.number;
}



function loadInput(data)
{ 
   var temp
   $("#editTitle").html("Edit Input #"+data.number)
  
   load_select_composite_values( "editAlarmNumber-0" , alarmData, data.alarmNumber);
   $("#editNumber-0").attr("value",data.number);
   $("#editName-0").attr("value",data.name);
   if( data.lowBattery == 0 )
  {
      $("#lowBattery").attr("checked",false);
  }
  else
  {
    $("#lowBattery").attr("checked",true);
  }
}



function saveInput( dataArray)
{
   var index;
   var data;
   var returnNumber;

   index = $("#editNumber-0").attr("value");
   data = {}
   // temp values
  data.name = "FILL ME IN";
  data.number = findHoleElement()
  data.alarmNumber = 0
  data.wired = 0
  data.setDelay = 0
  data.clearDelay = 0
  data.debounce = 0
  data.activeLow = 0
  data.lowBattery = 0
  data.notUsed = 0
  data.setCnt = 0
  data.clearCnt = 0
  data.enableTime =0
  data.disableTime = 0

   // real values
   data.number = index;
   data.name = $("#editName-0").attr("value");
   data.alarmNumber = get_singleSelect( "editAlarmNumber-0" );
   if( $("#lowBattery").attr("checked") == false )
   {
      data.lowBattery=  0;
   }
   else
   {
    data.lowBattery=  1;
   }
   returnNumber = 0;
   if( data.number > masterObject.maxNumber )
  { 
    alert("Number field is to large ")
    returnNumber = -1;  
    return returnNumber;
  }
  if( dataArray[ index ] != null )
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
   dataArray[index] = data;
   return returnNumber;
}

