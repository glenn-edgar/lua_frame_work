/*
**  File: answerSets.js
**
**
**
**
**
*/


var currentIndex;

var masterObject;

var tempObject;


function getData()
{
  
  
  masterObject.inputs            = new Array();
  masterObject.inputs[0]    = getAnswerSets();
  masterObject.backup       = toJson( masterObject.inputs );
 

}

function saveData()
{
   parent.masterSave = 0;
   pushJason( "/storeTxdFile.json?name=answer", masterObject.inputs[0] );
   masterObject.backup       = toJson( masterObject.inputs ); 
   $("#save").attr("disabled", true);
}

function drawAnswerSets( index, data )
{
  if( data.startingDate.everyYear === 0 )
  {
    temp = data.startingDate.month+"/"+data.startingDate.day+"/"+data.startingDate.year
    return "<td>"+ data.number+ "</td> <td>"+data.name + "</td><td>"+temp +"</td><td></td>";
  }
  else
  {
    temp = data.startingDate.month+"/"+data.startingDate.day+"/"+" every year "
    return "<td>"+ data.number+ "</td> <td>"+data.name + "</td><td>"+temp +"</td><td></td>";

  }
     masterObject.maxNumber = 100
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
   masterObject.tab_index = 0;
   drawLines(); 
 
}






function ready()
{

  masterObject = {}
  masterObject.maxNumber = 30
  masterObject.tab_index = 0;
  masterObject.init  =  [0];
  masterObject.initFunctions     = [ initAnswerSet ]
  masterObject.loadCreate     =  [ createAnswerSets ];
  masterObject.loadControl    =  [ loadAnswerSets ];
  masterObject.saveData        =  [ saveAnswerSets ];

  masterObject.drawLines = [  drawAnswerSets ] 
  getData();
  $("#reset").bind("click",resetData);
  $("#save").bind("click",saveData);
  showFunctionInitial()

}



$(function(){$('#tabs-work').tabs();});
$(document).ready( ready);



function getAnswerSets()
{
 
   temp = {};
  temp = getJsonFiltered("/getTxdFile.json?name=answer")   

  return temp;           


}


function getCurrentTab()
{
 
  return 0;
}

function getGurrentName( index)
{
  var temp;
  temp = ["ANSWER SET"];

  return temp[index];
}



function initAnswerSet()
{
  // init button functions

$("#OPEN_SELECT").bind("click", 
       function() 
       {tempObject.storeOpen=  selectFunction(tempObject.storeOpen,"available1", "storeOpenSelect") } ) 

$("#OPEN_REMOVE").bind("click", 
        function() 
        {tempObject.storeOpen=  removeFunction(tempObject.storeOpen,"available1", "storeOpenSelect") } )
  
$("#OPEN_UP").bind("click", 
        function() 
        {tempObject.storeOpen=  upFunction(tempObject.storeOpen,"available1", "storeOpenSelect") } )
  
$("#OPEN_DOWN" ).bind("click", 
       function() 
       {tempObject.storeOpen=  downFunction(tempObject.storeOpen,"available1", "storeOpenSelect")} ) 

$("#CLOSE_SELECT" ).bind("click", 
       function() 
       {tempObject.storeClose =  selectFunction(tempObject.storeClose,"available3", "storeCloseSelect") } )
 
$("#CLOSE_REMOVE" ).bind("click", 
      function() 
       {tempObject.storeClose =  removeFunction(tempObject.storeClose,"available3", "storeCloseSelect") } ) 

$("#CLOSE_UP" ).bind("click", 
      function() 
      { tempObject.storeClose =  upFunction(tempObject.storeClose,"available3", "storeCloseSelect") } )
 
$("#CLOSE_DOWN" ).bind("click", 
      function() 
      { tempObject.storeClose =  downFunction(tempObject.storeClose,"available3", "storeCloseSelect") } ) 
 
 
$("#DAY_SELECT" ).bind("click", 
      function() 
      { tempObject.storeDay =  selectFunction(tempObject.storeDay,"available2", "storeDaySelect") } )
 
$("#DAY_REMOVE").bind("click", 
      function() 
      { tempObject.storeDay =  removeFunction(tempObject.storeDay, "available2", "storeDaySelect")} )
  
$("#DAY_UP" ).bind("click", 
     function() 
      {  tempObject.storeDay =  upFunction(tempObject.storeDay,"available2", "storeDaySelect") } ) 

$("#DAY_DOWN" ).bind("click", 
     function() 
      {tempObject.storeDay =   downFunction(tempObject.storeDay,"available2", "storeDaySelect") } )  


$("#EVERY_YEAR").bind("click",EveryYearClick);

$("#ANSWER_NUMBER").bind("keypress",numericInput ); 



}




 
function createAnswerSets()
{
  var temp;

  temp = {}
  temp.number= 1000;
  temp.name= "Fill Me in";
  temp.startingDate = {}
  temp.startingDate.everyYear= 0;
  temp.startingDate.day= 1;
  temp.startingDate.month = 1;
  temp.startingDate.year= 2009;

   temp.startingDow=  -1;
   temp.weekNumber=   -1;
   temp.storeOpen=      []; 
   temp.storeDay=      [];
   temp.storeClose=     [];
   temp.dayMsgRef = {}
   temp.dayMsgRef.reference = 0;
   temp.dayMsgRef.hour= 0; 
   temp.dayMsgRef.minute= 0; 
   
   temp.number = findHoleElement()
   if( temp.number == -1 )
   {
    alert("exceeded the maximium table elements")
   }
   else
   {
    loadAnswerSets( temp );
   }
   return temp.number;
}
 

function loadAnswerSets( data )
{
  $("#tabs-work").tabs("select",0)
  tempObject = data;
  $("#editTitle").html("Edit Answer Set #"+data.number)
  $("#ANSWER_NUMBER").attr("value",data.number);
  $("#ANSWER_NAME").attr("value",data.name); 
 
  $("#EVERY_YEAR").attr("checked",convertBoolean(data.startingDate.everyYear));
  $("#START_DAY").attr("value",data.startingDate.day );
  $("#START_MONTH").attr("value",data.startingDate.month);
  $("#START_YEAR").attr("value",data.startingDate.year);

  load_select( "storeOpenSelect", data.storeOpen, null )
  load_select( "storeCloseSelect", data.storeClose, null)
  load_select( "storeDaySelect", data.storeDay, null)

  $("#DAY_HOUR").attr("value",data.dayMsgRef.hour)
  $("#DAY_MINUTE").attr("value",data.dayMsgRef.minute)
  $("#DAY_REFERENCED_FROM").attr("value",data.dayMsgRef.reference);
  $("#REFER").attr("value",data.dayMsgRef.reference );
  $("#FROM").attr("value",data.dayMsgRef.from );
  EveryYearClick();

}



function saveAnswerSets( dataElement )
{
  var index;
  var data;
  var returnNumber;

  index = $("#ANSWER_NUMBER").attr("value");
  data = {}
  data.number = index;
  data.name = $("#ANSWER_NAME").attr("value")
  data.startingDate = {}
  data.startingDate.everyYear = 
      booleanReturn( $("#EVERY_YEAR").attr("checked"));
  data.startingDate.day = parseInt($("#START_DAY").attr("value"));
  data.startingDate.month = parseInt($("#START_MONTH").attr("value"));
  data.startingDate.year = parseInt($("#START_YEAR").attr("value"));
  data.storeOpen  = tempObject.storeOpen;
  data.storeClose = tempObject.storeClose;
  data.storeDay  = tempObject.storeDay;
  
  data.dayMsgRef = {}
  data.dayMsgRef.hour = $("#DAY_HOUR").attr("value");
  data.dayMsgRef.minute = $("#DAY_MINUTE").attr("value");
  data.dayMsgRef.reference = $("#REFER").attr("value");
  data.dayMsgRef.from  = $("#FROM").attr("value");

  returnNumber = 0;
  if( data.number > masterObject.maxNumber )
  { 
    alert("Number field is to large ")
    returnNumber = -1;  
    return returnNumber;
  }
  if( dataElement[ data.number ] != null )
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

 
  dataElement[ data.number] = data;
  return returnNumber;

} 



function EveryYearClick()
{
  if( $("#EVERY_YEAR").attr("checked") == true )
  {
      $("#START_YEAR").attr("disabled", true);
  }
  else
  {
     $("#START_YEAR").attr("disabled", false);
  }
  
}



function convertBoolean( data)
{
  var returnValue;

  if( data != 0 )
  {
    returnValue = true;
   }
   else
   {
     returnValue = false;
   } 
   return returnValue;
}



function booleanReturn( x)
{
  var returnValue;
  if( x == true )
  {
    returnValue =  1;
  }
  else
  {
    returnValue = 0;
  }
  return returnValue;
}


function selectFunction(arrayObject, availableId, selectId)
{
  var temp;
  var temp1;

  temp = get_select( availableId);
  
  if( temp.length != 0 )
  {
    
     temp1 = arrayObject.concat(temp);
     if( chooseLength( temp1 ) <= 209 )
     {
         arrayObject = temp1;
         arrayObject = removeArrayHoles( arrayObject )
         load_select( selectId, arrayObject, null);
     }
  }
   removeSelection(selectId);
   removeSelection(availableId);
   return arrayObject;

}
 
function removeFunction(arrayObject, availableId, selectId)
{
   var temp;
   var index;

   temp = get_selectIndexes( selectId )
   for( index = 0; index < temp.length; index++ )
   {
    
      arrayObject[ temp[index] ] = null;
   }
   arrayObject  = removeArrayHoles( arrayObject )
   load_select( selectId, arrayObject,null);
   removeSelection(selectId);
   removeSelection(availableId);
   return arrayObject;
}

 
function upFunction(arrayObject, availableId, selectId) 
{
   var temp;
   var index;
   var tempSwap;

   temp = get_selectIndexes( selectId )
   for( index = 0; index < temp.length; index++ )
   {
      if( temp[index] != 0 )
      {
         tempSwap = arrayObject[ temp[index]-1 ];
         arrayObject[ temp[index]-1] = arrayObject[ temp[index] ];
         arrayObject[ temp[index] ] = tempSwap;
      }
   }
   arrayObject  = removeArrayHoles( arrayObject )
   load_select( selectId, arrayObject,null);
   removeSelection(selectId);
   removeSelection(availableId);
   return arrayObject;
}
 
function downFunction(arrayObject, availableId, selectId) 
{
   var temp;
   var index;
   var tempSwap;

   temp = get_selectIndexes( selectId )
   for( index = 0; index < temp.length; index++ )
   {  
      if( temp[index] < arrayObject.length -1 )
      {
         tempSwap = arrayObject[ temp[index]+1 ];
         arrayObject[ temp[index]+1] = arrayObject[ temp[index] ];
         arrayObject[ temp[index] ] = tempSwap;
      }
   }
   arrayObject  = removeArrayHoles( arrayObject )
   load_select( selectId, arrayObject,null);
   removeSelection(selectId);
   removeSelection(availableId);
   return arrayObject;
} 

function removeArrayHoles( arrayObject )
{
  var returnValue;
  var index;

  returnValue = new Array()
 

  for( index = 0; index < arrayObject.length; index++ )
  {
     if( arrayObject[index] != null )
     {
     
       returnValue.push(arrayObject[index])
     }
  }
  return returnValue;
} 


