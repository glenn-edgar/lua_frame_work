/*
**  File: promos.js
**
**
**
**
**
*/


var currentIndex;
var waveFile;
var routingData

var masterObject;
var tempObject;




function getData()
{
  
  
  masterObject.inputs            = new Array();
  masterObject.inputs[0]    = getPromos();
  masterObject.defaultPromoTime = getPromoTime();
  masterObject.backup       = toJson( masterObject.inputs );
  masterObject.promoTimeBack = masterObject.promoTimeBackup
  waveFile = getJson("/waveArray.json");
  routingData = getRouteData()

}

function saveData()
{
   var temp;
   temp = {}
   temp.interval = parseInt( $("#DEFAULT_PROMO_TIME").attr("value"))
   masterObject.defaultPromoTime = parseInt( $("#DEFAULT_PROMO_TIME").attr("value"));
   parent.masterSave = 0;
   pushJason_noAcknowledge( "/storeTxdFile.json?name=promos", masterObject.inputs[0] ); 
   pushJason( "/storeTxdFile.json?name=promosCtl", temp ); 
   masterObject.backup       = toJson( masterObject.inputs );
   masterObject.promoTimeBack = masterObject.promoTimeBackup
   $("#save").attr("disabled", true);
}

 function drawPromos( index, data )
{
  var temp1;
  var temp2;

  if( data.startingDate.everyYear === 0 )
  {
    temp1 = data.startingDate.month+"/"+data.startingDate.day+"/"+data.startingDate.year
    
  }
  else
  {
    temp1 = data.startingDate.month+"/"+data.startingDate.day+"/"+" every year "
    

  }
  if( data.endingDate.everyYear === 0 )
  {
    temp2 = data.endingDate.month+"/"+data.endingDate.day+"/"+data.endingDate.year
    
  }
  else
  {
    temp2 = data.endingDate.month+"/"+data.endingDate.day+"/"+" every year "
    

  }
  return "<td>"+ data.number+ "</td> <td>"+data.name + "</td><td>"+temp1 +"</td><td>"+temp2+"</td><td></td>";  
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
  masterObject.maxNumber = 200
  masterObject.init  =  [0];
  masterObject.initFunctions     = [ initPromos ]
  masterObject.loadCreate     =  [ loadCreate ];
  masterObject.loadControl    =  [ loadPromoData ];
  masterObject.saveData        =  [ savePromoData ];

  masterObject.drawLines = [  drawPromos ] 
  getData();
  $("#reset").bind("click",resetData);
  $("#save").bind("click",saveData);
  showFunctionInitial()

}




$(function(){$('#tabs-work').tabs();});

$(document).ready( ready);


$(function(){

// Tabs
var tabOpts = {} 
tabOpts.show = showFunction

$('#tabs').tabs( tabOpts );

});

function getCurrentTab()
{
 
  return 0;
}


function getCurrentTab()
{
 
  return 0;
}

function getCurrentTab()
{
 
  return 0;
}


function getCurrentTab()
{
 
  return 0;
}


function getGurrentName( index)
{
  var temp;
  temp = ["PROMOS"];

  return temp[index];
}


function initPromos()
{
  load_select( "available1", waveFile, null);
  $("#DEFAULT_PROMO_TIME").attr("value",masterObject.defaultPromoTime);
  $("#START_EVERY_YEAR").bind("click",SartEveryYearClick);
  $("#END_EVERY_YEAR").bind("click",EndEveryYearClick);
  $("#PROMO_TYPE").bind("click",PromoTypeClick);

  $("#wave_select").bind("click", 
		function() 
			{ tempObject.waveFiles = selectFunction(tempObject.waveFiles, "available1", "select1") });
  
  $("#wave_remove").bind("click", 
		function() 
			{ tempObject.waveFiles = removeFunction(tempObject.waveFiles, "available1", "select1") });
  
  $("#wave_move_up").bind("click", 
		function() 
			{ tempObject.waveFiles = upFunction(tempObject.waveFiles, "available1", "select1") });
  
  $("#wave_move_down" ).bind("click", 
		function() 
			{ tempObject.waveFiles = downFunction(tempObject.waveFiles, "available1", "select1") });

  $("#wave_play2").bind("click",
		function()
			{   var file;
                            file = get_singleSelect("select1")
                            if( file != null )
                            {
                               window.open("/audio/"+file) 
                            }
                            else
                            {
                              alert("no file selected");
                            }
                         } );
 
 $("#wave_play1").bind("click",
		function()
			{   var file;
                            file = get_singleSelect("available1")
                            if( file != null )
                            {
                               window.open("/audio/"+file) 
                            }
                            else
                            {
                              alert("no file selected");
                            }
                         } );

  load_select( "available1", waveFile, null );
  $("#PROMO_NUMBER").bind("keypress",numericInput ); 
  $("#DEFAULT_PROMO_TIME").bind("keypress",numericInput ); 


}

function loadCreate()
{
 var temp;
  
   temp= {}
   temp.enable = 0;
   temp.number= 1000;
   temp.name= "FILL ME IN";
   temp.startingDate = {}
   temp.startingDate.everyYear =0;
   temp.startingDate.day=  1; month:
   temp.startingDate.month=  1;
   temp.startingDate.year = 2009 ;

   temp.endingDate = {}
   temp.endingDate.everyYear =0;
   temp.endingDate.day = 1;
   temp.endingDate.month= 1;
   temp.endingDate.year = 2009;
   

   temp.dow = {}
   temp.dow.Sunday = 0;
   temp.dow.Monday=0;
   temp.dow.Tuesday=0;
   temp.dow.Wednesday=0;
   temp.dow.Thursday = 0;
   temp.dow.Friday = 0;
   temp.dow.Saturday = 0;
 

  temp.promoCtl = {}
  temp.promoCtl.promo_type=0;
  temp.promoCtl.promo_hr= 0;
  temp.promoCtl.promo_minute= 0;
  temp.promoCtl.promo_ref= 0;
  temp.promoCtl.promo_from = 0;

  temp.waveFiles = []
 
  temp.number = findHoleElement()
  if( temp.number == -1 )
  {
    alert("exceeded the maximium table elements")
  }
  else
  {
     loadPromoData( temp );
  }
  return temp.number;
}

function loadPromoData(data )
{ 
  $("#tabs-work").tabs("select",0)
  tempObject = data;
  $("#editTitle").html("Edit Promo #"+data.number)
  $("#PROMO_NUMBER").attr("value",data.number);
  $("#PROMO_NAME").attr("value",data.name);
  if( data.enable == 0 )
  {
     $("#PROMO_ENABLE").attr("checked",false);
  }
  else
  {
   $("#PROMO_ENABLE").attr("checked",true);
  } 
  
  load_select_composite_values( "ROUTE", routingData, data.route)
  $("#START_EVERY_YEAR").attr("checked",convertBoolean(data.startingDate.everyYear));
  $("#START_DAY").attr("value",data.startingDate.day );
  $("#START_MONTH").attr("value",data.startingDate.month);
  $("#START_YEAR").attr("value",data.startingDate.year);

  $("#END_EVERY_YEAR").attr("checked",convertBoolean(data.endingDate.everyYear));
  $("#END_DAY").attr("value",data.endingDate.day );
  $("#END_MONTH").attr("value",data.endingDate.month);
  $("#END_YEAR").attr("value",data.endingDate.year);

  $("#SUN").attr("checked",convertBoolean(data.dow.Sunday));
  $("#MON").attr("checked",convertBoolean(data.dow.Monday));
  $("#TUE").attr("checked",convertBoolean(data.dow.Tuesday));
  $("#WED").attr("checked",convertBoolean(data.dow.Wednesday));
  $("#THR").attr("checked",convertBoolean(data.dow.Thursday));
  $("#FRI").attr("checked",convertBoolean(data.dow.Friday));
  $("#SAT").attr("checked",convertBoolean(data.dow.Saturday));

  $("#PROMO_TYPE").attr("value",data.promoCtl.promo_type );
  $("#PROMO_HR").attr("value",data.promoCtl.promo_hr );
  $("#PROMO_MIN").attr("value",data.promoCtl.promo_minute );
  $("#REFER").attr("value",data.promoCtl.promo_ref );
  $("#FROM").attr("value",data.promoCtl.promo_from );
  load_select( "select1", data.waveFiles, null );

  SartEveryYearClick();
  EndEveryYearClick();
  PromoTypeClick();

}

function savePromoData( dataElement )
{
  var index;
  var data
  var dataElement;
  var returnNumber;
 
  index = parseInt($("#PROMO_NUMBER").attr("value"));
  data = {}
  data.number = index;
  data.name = $("#PROMO_NAME").attr("value");

  data.startingDate = {}
  data.startingDate.everyYear = 
      booleanReturn( $("#START_EVERY_YEAR").attr("checked"));
  data.startingDate.day = parseInt($("#START_DAY").attr("value"));
  data.startingDate.month = parseInt($("#START_MONTH").attr("value"));
  data.startingDate.year = parseInt($("#START_YEAR").attr("value"));

  data.endingDate ={}
  data.endingDate.everyYear = 
      booleanReturn( $("#END_EVERY_YEAR").attr("checked"));
  data.endingDate.day = parseInt($("#END_DAY").attr("value"));
  data.endingDate.month = parseInt($("#END_MONTH").attr("value"));
  data.endingDate.year = parseInt($("#END_YEAR").attr("value"));
  
  data.dow = {}
  data.dow.Sunday = 
    booleanReturn(  $("#SUN").attr("checked"));
  data.dow.Monday = 
     booleanReturn( $("#MON").attr("checked"));
  data.dow.Tuesday = 
      booleanReturn( $("#TUE").attr("checked"));
  data.dow.Wednesday = 
       booleanReturn( $("#WED").attr("checked"));
  data.dow.Thursday = 
       booleanReturn( $("#THR").attr("checked"));
  data.dow.Friday = 
       booleanReturn( $("#FRI").attr("checked"));
  data.dow.Saturday = 
        booleanReturn( $("#SAT").attr("checked"));
 
  data.promoCtl = {};

  data.promoCtl.promo_type = $("#PROMO_TYPE").attr("value");
  data.promoCtl.promo_hr = $("#PROMO_HR").attr("value");
  data.promoCtl.promo_minute =$("#PROMO_MIN").attr("value");
  data.promoCtl.promo_ref = $("#REFER").attr("value");
  data.promoCtl.promo_from = $("#FROM").attr("value");
  data.waveFiles = tempObject.waveFiles
  if( data.number > masterObject.maxNumber )
  { 
    alert("Number field is to large ")
    returnNumber = -1;  
    return returnNumber;
  }

  if( $("#PROMO_ENABLE").attr("checked") == true)
  {
     data.enable = 1;
  }
  else
  {
    data.enable = 0;
  }
  data.route = $("#ROUTE").attr("value");
  returnNumber = 0;

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


function getPromos()
{
  var temp;

  
  temp = getJsonFiltered("/getTxdFile.json?name=promos")   

  return temp;        

}

function getPromoTime()
{
  var temp;

  
  temp = getJson("/getTxdFile.json?name=promosCtl")   
  if( temp != null )
  {
     return temp.interval
  }
  else
  {
    return 45
  }     

}

function SartEveryYearClick()
{
  if( $("#START_EVERY_YEAR").attr("checked") == true )
  {
      $("#START_YEAR").attr("disabled", true);
  }
  else
  {
     $("#START_YEAR").attr("disabled", false);
  }
  
}

function EndEveryYearClick()
{
  if( $("#END_EVERY_YEAR").attr("checked") == true )
  {
      $("#END_YEAR").attr("disabled", true);
  }
  else
  {
     $("#END_YEAR").attr("disabled", false);
  }
  
}


function PromoTypeClick()
{
  if( $("#PROMO_TYPE").attr("value") == 0 )
  {
	$("#PROMO_INTVL_TABLE").show();
	$("#PROMO_DAYHR_TABLE").hide();
    $("#storeHourTitle").html("Interval Promos use the Default Promo Interval");
	$("#PROMO_INTVL").attr("value",masterObject.defaultPromoTime);
	
	/*
    $("#PROMO_HR_LABEL").hide();
    $("#PROMO_HR").hide();
    $("#PROMO_MIN_LABEL").hide();
    $("#PROMO_MIN").hide();
    $("#REFER_LABEL").hide();      
    $("#REFER").hide();
    $("#FROM_LABEL").hide();        
    $("#FROM").hide();
	*/

  }
  if( $("#PROMO_TYPE").attr("value") == 2 )
  {
	$("#PROMO_INTVL_TABLE").hide();
	$("#PROMO_DAYHR_TABLE").show();
    $("#storeHourTitle").html("Day Time Promos use an offset from midnight when the promo will play");
    $("#REFER_LABEL").hide();      
    $("#REFER").hide();
    $("#FROM_LABEL").hide();        
    $("#FROM").hide();
	
	/*
    $("#PROMO_HR_LABEL").show();
    $("#PROMO_HR").show();
    $("#PROMO_MIN_LABEL").show();
    $("#PROMO_MIN").show();
	*/

  }
  if( $("#PROMO_TYPE").attr("value") == 1 )
  {
	$("#PROMO_INTVL_TABLE").hide();
	$("#PROMO_DAYHR_TABLE").show();
    $("#storeHourTitle").html("Store Hours Promos use a reference from Open or Close time");
    $("#REFER_LABEL").show();      
    $("#REFER").show();
    $("#FROM_LABEL").show();        
    $("#FROM").show();
	
	/*
    $("#PROMO_HR_LABEL").show();
    $("#PROMO_HR").show();
    $("#PROMO_MIN_LABEL").show();
    $("#PROMO_MIN").show();
	*/

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
     if( chooseLength( temp1 ) <= 64 )
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
