/*
**
** File: pointOfSale.js
**
**
**
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
  masterObject.inputs[0] = getPos();
  masterObject.backup       = toJson( masterObject.inputs );
  alarmData = getAlarmData();

}

function saveData()
{
    
    savePosData(masterObject.inputs[0] );
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
  masterObject.initFunctions     = [initPos ]
  masterObject.loadControl    = [ loadPos ];
  masterObject.loadCreate     =  [ posCreate ];
  masterObject.saveData       = [savePos ];

  masterObject.drawLines = [  drawPos ] 
  getData();
  $("#reset").bind("click",resetData);
  $("#save").bind("click",saveData);
  $("#edit-0-number").bind("keypress",numericInput );
  $("#edit-0-termId").bind("keypress",numericInput );
  $("#edit-0-keyId").bind("keypress",numericInput );
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
  if( audioPageArray.length > 0 )
  {
  var temp;
  temp = ["POS"]

  return temp[0];
  }
}



function savePosData( dataObject)
{
 
  parent.masterSave = 0;
  pushJason( "/storeTxdFile.json?name=pos", dataObject ); 
  $("#save").attr("disabled", true);


}

/*
**
** Note: Need to normalize this data
**
**
**
**
*/
function getPos()
{
  var temp;

  temp = {};
  temp = getJsonFiltered("/getTxdFile.json?name=pos")   

  return temp;                       
}

function initPos()
{
  $("#edit-0-number").bind("keypress",numericInput);
}  

function drawPos( index, dataElement )
{
   var temp;
    
   temp =  "<td>"+dataElement.number+"</td><td>"
                 +dataElement.termId+"</td> <td>"
                 +dataElement.keyId+"</td><td>"
                 +dataElement.alarmNumber+"</td>";
 
   if( dataElement.action == 0 )
   {
      tempString = "<td>CLEAR</td><td></td>";
   }
   else
   {
    
    tempString = "<td>SET</td><td></td>";
  
   }
  
   
   temp = temp+tempString;
   
   

   return temp;

}


function loadPos(data)
{
   var temp
   
   $("#editTitle").html("Edit QuickLink #"+data.number)

   
   load_select_composite_values( "edit-0-alarmNumber" ,alarmData, data.alarmNumber);
   $("#edit-0-alarmNumber").attr("value",data.alarmNumber);
   $("#edit-0-number").attr("value",data.number);
   $("#edit-0-termId").attr("value",data.termId);
   $("#edit-0-keyId").attr("value",data.keyId);
   $("#edit-0-action").attr("value",data.action);
  
}

function posCreate()
{
  var data;
  data = {}
  data.key        = "number";
  data.termId     =    ""; 
  data.keyId      =    "";
  data.alarmNumber =    1;
  data.action      =    1;
  data.number = findHoleElement()
  if( data.number == -1 )
  {
    alert("exceeded the maximium table elements")
  }
  else
  {
    loadPos(data)
  }
  return data.number;
}


function savePos(  dataArray )
{
   var index;
   var temp;
   var data;
   var returnNumber;

   index = $("#edit-0-number").attr("value");
   data = {}
   data.number = index;
   data.key = "name";
   data.termId =  $("#edit-0-termId").attr("value");
   data.keyId = $("#edit-0-keyId").attr("value");
   temp = get_select("edit-0-alarmNumber");
   data.alarmNumber = temp[0];
   data.action      = $("#edit-0-action").attr("value");

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
  dataArray[ data.number ] = data;
  return returnNumber
}





