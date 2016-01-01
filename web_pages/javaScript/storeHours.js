/*
**  File: storeHours.js
**
**
**
**
**
*/


/*
**
** File: output_page.js
** Java script support for output_page.html
**
**
**
**
**
**
*/

/*

  File system_setup.js
  This is the script file for system_setup.html

*/


var currentIndex;
var masterObject = {}
var currentData;
var availArray1

	

function getData()
{
  
  
  masterObject.inputs            = new Array();
  masterObject.inputs[0]    = getStoreHours();
  masterObject.backup       = toJson( masterObject.inputs );
 

}

function saveData()
{
   parent.masterSave = 0;
   pushJason( "/storeTxdFile.json?name=storehr", masterObject.inputs[0] );
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

  masterObject = {}
  masterObject.maxNumber = 100
  masterObject.init  =  [0];
  masterObject.initFunctions     = [ initStoreHours ]
  masterObject.loadCreate     =  [ loadCreate ];
  masterObject.loadControl    =  [ loadStoreHourData ];
  masterObject.saveData        =  [ saveStoreHourData ];

  masterObject.drawLines = [  drawStoreHrs ] 
  getData();
  $("#reset").bind("click",resetData);
  $("#save").bind("click",saveData);
  showFunctionInitial()

}








$(function(){$('#work-tabs').tabs();});
$(document).ready( ready);



function getCurrentTab()
{
 
  return 0;
}


function getGurrentName( index)
{
  var temp;
  temp = ["STORE HR"];

  return temp[index];
}







function getStoreHours()
{
   temp = {};
  temp = getJsonFiltered("/getTxdFile.json?name=storehr")   

  return temp;           


}

function initStoreHours()
{
   
   $("#SUNDAY_CHK").bind("click",SundayClick );
   $("#MONDAY_CHK").bind("click",MondayClick );
   $("#TUESDAY_CHK").bind("click",TuesdayClick );
   $("#WEDNESDAY_CHK").bind("click",WednesdayClick );
   $("#THURSDAY_CHK").bind("click",ThursdayClick );
   $("#FRIDAY_CHK").bind("click",FridayClick );
   $("#SATURDAY_CHK").bind("click",SaturdayClick );
   $("#EVERY_YEAR").bind("click",EveryYearClick); 
   $("#STORE_NUMBER").bind("keypress",numericInput ); 
}

 
function loadCreate ()
{
  var temp;
  temp =   {
              number: 1000,
              name: "FILL ME IN",
              startingDate:  { everyYear: 0, day: 1, month: 1, year: 2009 },
              startingDow:  1,
              weekNumber:   -1,
              Sunday:  { closed: 0, open: [8,0], close: [22,0] },     
              Monday:    { closed: 0, open: [8,0], close: [22,0] },
              Tuesday:    { closed: 0, open: [8,0], close: [22,0] },
              Wednesday:   { closed: 0, open: [8,0], close: [22,0] },
              Thursday:    { closed: 0, open: [8,0], close: [22,0] },
              Friday:     { closed: 0, open: [8,0], close: [22,0] },
              Saturday:     { closed: 0, open: [8,0], close: [22,0] } };
  temp.number = findHoleElement()
  if( temp.number == -1 )
  {
    alert("exceeded the maximium table elements")
  }
  else
  {
    loadStoreHourData(temp);
  }
  return temp.number;
}

function loadStoreHourData( data )
{
  $("#work-tabs").tabs("select",0)
  $("#editTitle").html("Edit Store Hours #"+data.number)

  $("#STORE_NUMBER").attr("value",data.number);
  $("#STORE_NAME").attr("value",data.name);

  $("#EVERY_YEAR").attr("checked",convertBoolean(data.startingDate.everyYear));
  $("#START_DAY").attr("value",data.startingDate.day );
  $("#START_MONTH").attr("value",data.startingDate.month);
  $("#START_YEAR").attr("value",data.startingDate.year);
 
  $("#SUNDAY_CHK").attr("checked",convertBoolean(data.Sunday.closed));
  $("#SUNDAY_OPEN").attr("value", findValue(data.Sunday.open));
  $("#SUNDAY_CLOSE").attr("value",findValue(data.Sunday.close));

  $("#MONDAY_CHK").attr("checked",convertBoolean(data.Monday.closed));
  $("#MONDAY_OPEN").attr("value",findValue(data.Monday.open));
  $("#MONDAY_CLOSE").attr("value",findValue(data.Monday.close));

  $("#TUESDAY_CHK").attr("checked",convertBoolean(data.Tuesday.closed));
  $("#TUESDAY_OPEN").attr("value",findValue(data.Tuesday.open));
  $("#TUESDAY_CLOSE").attr("value",findValue(data.Tuesday.close));

  $("#WEDNESDAY_CHK").attr("checked",convertBoolean(data.Wednesday.closed));
  $("#WEDNESDAY_OPEN").attr("value",findValue(data.Wednesday.open));
  $("#WEDNESDAY_CLOSE").attr("value",findValue(data.Wednesday.close));


  $("#THURSDAY_CHK").attr("checked",convertBoolean(data.Thursday.closed));
  $("#THURSDAY_OPEN").attr("value", findValue(data.Thursday.open));
  $("#THURSDAY_CLOSE").attr("value",findValue(data.Thursday.close));


  $("#FRIDAY_CHK").attr("checked",convertBoolean(data.Friday.closed));
  $("#FRIDAY_OPEN").attr("value",findValue(data.Friday.open));
  $("#FRIDAY_CLOSE").attr("value",findValue(data.Friday.close));

  $("#SATURDAY_CHK").attr("checked",convertBoolean(data.Saturday.closed));
  $("#SATURDAY_OPEN").attr("value",findValue(data.Saturday.open));
  $("#SATURDAY_CLOSE").attr("value",findValue(data.Saturday.close));
 
  SundayClick();
  MondayClick();
  TuesdayClick();
  WednesdayClick();
  ThursdayClick();
  FridayClick();
  SaturdayClick();
  EveryYearClick();
 
}
 
function saveStoreHourData( dataElement)
{
  var data;
  var index;
  var returnNumber;

  index = $("#STORE_NUMBER").attr("value");
  index = parseInt(index);
  data = {};
  data.number = index; 
  data.name = $("#STORE_NAME").attr("value");

  data.startingDate = {}
  data.startingDate.everyYear = booleanReturn($("#EVERY_YEAR").attr("checked"));
  data.startingDate.day = $("#START_DAY").attr("value" );
  data.startingDate.month = $("#START_MONTH").attr("value");
  data.startingDate.year = $("#START_YEAR").attr("value");
 
  data.Sunday = {}
  data.Sunday.closed =    booleanReturn($("#SUNDAY_CHK").attr("checked"));
  data.Sunday.open =      packData($("#SUNDAY_OPEN").attr("value"));
  data.Sunday.close =     packData($("#SUNDAY_CLOSE").attr("value"));

  data.Monday = {}
  data.Monday.closed =    booleanReturn($("#MONDAY_CHK").attr("checked"));
  data.Monday.open =      packData($("#MONDAY_OPEN").attr("value"));
  data.Monday.close =     packData($("#MONDAY_CLOSE").attr("value"));

  data.Tuesday = {}
  data.Tuesday.closed =  booleanReturn($("#TUESDAY_CHK").attr("checked"));
  data.Tuesday.open =    packData($("#TUESDAY_OPEN").attr("value"));
  data.Tuesday.close =   packData($("#TUESDAY_CLOSE").attr("value"));

  data.Wednesday = {}
  data.Wednesday.closed = booleanReturn($("#WEDNESDAY_CHK").attr("checked"));
  data.Wednesday.open =  packData($("#WEDNESDAY_OPEN").attr("value"));
  data.Wednesday.close = packData($("#WEDNESDAY_CLOSE").attr("value"));


  data.Thursday = {}
  data.Thursday.closed = booleanReturn($("#THURSDAY_CHK").attr("checked"));
  data.Thursday.open   = packData($("#THURSDAY_OPEN").attr("value"));
  data.Thursday.close  = packData($("#THURSDAY_CLOSE").attr("value"));


  data.Friday = {}
  data.Friday.closed =   booleanReturn($("#FRIDAY_CHK").attr("checked"));
  data.Friday.open =     packData($("#FRIDAY_OPEN").attr("value"));
  data.Friday.close =    packData($("#FRIDAY_CLOSE").attr("value"));

  data.Saturday = {}
  data.Saturday.closed = booleanReturn($("#SATURDAY_CHK").attr("checked"));
  data.Saturday.open =   packData($("#SATURDAY_OPEN").attr("value"));
  data.Saturday.close =  packData($("#SATURDAY_CLOSE").attr("value"));

 
  returnNumber = 0;
  if( data.number > masterObject.maxNumber )
  { 
    alert("Number field is to large ")
    returnNumber = -1;  
    return returnNumber;
  }
  if( dataElement[ index ] != null )
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

 
  dataElement[ index] = data;
  return returnNumber;
  
}
  
function drawStoreHrs( index, data )
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
    
}
 
function SundayClick()
{
     
      if( $("#SUNDAY_CHK").attr("checked") == true )
      {
         $("#SUNDAY_OPEN").attr("disabled", true);
         $("#SUNDAY_CLOSE").attr("disabled", true);
      }
      else
      {
        $("#SUNDAY_OPEN").attr("disabled", false);
        $("#SUNDAY_CLOSE").attr("disabled", false);
     }
}

function MondayClick()
{
      if( $("#MONDAY_CHK").attr("checked") == true )
      {
         $("#MONDAY_OPEN").attr("disabled", true);
         $("#MONDAY_CLOSE").attr("disabled", true);
      }
      else
      {
        $("#MONDAY_OPEN").attr("disabled", false);
        $("#MONDAY_CLOSE").attr("disabled", false);
     }
}


function TuesdayClick()
{
      if( $("#TUESDAY_CHK").attr("checked") == true )
      {
         $("#TUESDAY_OPEN").attr("disabled", true);
         $("#TUESDAY_CLOSE").attr("disabled", true);
      }
      else
      {
        $("#TUESDAY_OPEN").attr("disabled", false);
        $("#TUESDAY_CLOSE").attr("disabled", false);
     }
}



function WednesdayClick()
{
      if( $("#WEDNESDAY_CHK").attr("checked") == true )
      {
         $("#WEDNESDAY_OPEN").attr("disabled", true);
         $("#WEDNESDAY_CLOSE").attr("disabled", true);
      }
      else
      {
        $("#WEDNESDAY_OPEN").attr("disabled", false);
        $("#WEDNESDAY_CLOSE").attr("disabled", false);
     }
}

function ThursdayClick()
{packData
      if( $("#THURSDAY_CHK").attr("checked") == true )
      {
         $("#THURSDAY_OPEN").attr("disabled", true);
         $("#THURSDAY_CLOSE").attr("disabled", true);
      }
      else
      {
        $("#THURSDAY_OPEN").attr("disabled", false);
        $("#THURSDAY_CLOSE").attr("disabled", false);
     }
}

function FridayClick()
{
      if( $("#FRIDAY_CHK").attr("checked") == true )
      {
         $("#FRIDAY_OPEN").attr("disabled", true);
         $("#FRIDAY_CLOSE").attr("disabled", true);
      }
      else
      {
        $("#FRIDAY_OPEN").attr("disabled", false);
        $("#FRIDAY_CLOSE").attr("disabled", false);
     }
}

function SaturdayClick()
{
      if( $("#SATURDAY_CHK").attr("checked") == true )
      {
         $("#SATURDAY_OPEN").attr("disabled", true);
         $("#SATURDAY_CLOSE").attr("disabled", true);
      }
      else
      {
        $("#SATURDAY_OPEN").attr("disabled", false);
        $("#SATURDAY_CLOSE").attr("disabled", false);
     }
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


function findValue( dataElement)
{
  var returnValue;

  if( dataElement[1] != 0 )
  {
    returnValue = dataElement[0]*2 + 1;
  }
  else
  {
    returnValue = dataElement[0]*2;
  }
  return returnValue;
}



function packData( data )
{
  var returnValue = new Array();
  data = parseInt(data);
  if( (data & 1 ) != 0 )
  {
    returnValue[1] = 30;
  }
  else
  {
   returnValue[1] = 0;
  }
  returnValue[0] = data/2;
  return returnValue;
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





