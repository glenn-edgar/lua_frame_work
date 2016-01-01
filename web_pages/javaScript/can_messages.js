/*
**
** File: can_messages.js
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

	

function getData()
{
  
  
  masterObject.inputs            = new Array();

  masterObject.inputs[0]         = getCanMessage();
  masterObject.backup       = toJson( masterObject.inputs );

}

function saveData()
{
    parent.masterSave = 0;
    pushJason( "/storeTxdFile.json?name=canmess", masterObject.inputs[0] );
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
   masterObject.tab_index = tab.index;
   drawLines(); 
 
}


function ready()
{

  masterObject = {}
  masterObject.maxNumber = 300
  masterObject.init  =  [0];
  masterObject.initFunctions     = [ initCanMessage ]
  masterObject.loadControl    = [ loadCanMessage ];
  masterObject.loadCreate     =  [ loadCreate ];
  masterObject.saveData       = [ saveCanMessage ];

  masterObject.drawLines = [ drawMessages ] 
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
  temp = ["CAN MSG"];

  return temp[index];
}





function getCanMessage()
{
 var temp;

  temp = {};
  temp = getJsonFiltered("/getTxdFile.json?name=canmess")   

  return temp; 
}






function editEntity( data )
{
    currentNumber = data.number
    $("#editTitle").html("Edit Can Message #"+data.number)
    $("#CAN_MESSAGE").attr("value", data.message)
    saveCurrentObject( data)
   
    
}




function editSaveReturn()
{
  workingObject[currentNumber].message =  $("#CAN_MESSAGE").attr("value")
  $("#MESSAGE"+ workingObject[currentNumber].number).html(workingObject[currentNumber].message)
  $("#displayDiv").show()
  $("#editDiv").hide() 
 

}




function drawMessages(index, data )
{
  
   temp =  '<td>'+data.number+'</td><td id= "MESSAGE'+data.number +'" >'+data.message+'</td><td></td> '
   return temp;

}


function initCanMessage()
{
  $("#CAN_NUMBER").bind("keypress",numericInput ); 

}



function loadCreate()
{
  var data;
  data = {};
  data.key = "number";
  data.message = "FILL ME IN";
  data.number = findHoleElement()
  if( data.number == -1 )
  {
    alert("exceeded the maximium table elements")
  }
  else
  {
    loadCanMessage(data);
  }
  return data.number;

} 

function loadCanMessage(data)
{
    $("#editTitle").html("Edit Canned Message #"+data.number)
    $("#CAN_NUMBER").attr("value", data.number)
    $("#CAN_MESSAGE").attr("value", data.message)

}
  
function saveCanMessage(dataArray)
{
  var data;
  var returnValue;

  data = {};
  data.key = "number";
  data.number = $("#CAN_NUMBER").attr("value");
  data.message = $("#CAN_MESSAGE").attr("value");
  
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

 
  dataArray[ data.number] = data;
  return returnNumber;
}


