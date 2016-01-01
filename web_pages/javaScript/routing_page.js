/*

  File system_setup.js
  This is the script file for system_setup.html

*/

var refPager        = new Array()
var currentIndex;
var masterObject = {}
var currentData;


	

function getData()
{
  
  
 
  masterObject.inputs[0]    = loadRoutingObject();
  masterObject.backup       = toJson( masterObject.inputs );
 

}

function saveData()
{
    parent.masterSave = 0;
    pushJason( "/storeTxdFile.json?name=routing", masterObject.inputs[0] );
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
  masterObject.maxNumber = 200
  masterObject.init  =  [0];
  masterObject.inputs          = new Array();
  masterObject.inputs[0]       = new Array();
  masterObject.initFunctions   = [ initRouting ]
  masterObject.loadCreate      =  [ loadCreate ];
  masterObject.loadControl     =  [ loadRoutingData ];
  masterObject.saveData        =  [ saveRoutingdata ];

  masterObject.drawLines = [ drawRoutes ] 
  getData();
  $("#reset").bind("click",resetData);
  $("#save").bind("click",saveData);

  showFunctionInitial()

}



$(function(){$('#tab-display').tabs();});

$(document).ready( ready);
// Tabs
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
  temp = ["ROUTE"];

  return temp[index];
}











/*
   Temp Hack until AJAX calls are made
*/

function loadRoutingObject()
{

  var temp;

  temp = {};
  temp = getJsonFiltered("/getTxdFile.json?name=routing")   

  return temp;
}







function ButtonSelect1()
{
  var temp
  var temp1;

  temp = get_select("available1")
  
  if( temp.length == 0 ){ return; }
     

  temp1 = currentData.route1.concat(temp);
 
  if( chooseLength( temp1 ) <= 60 )
  {
    currentData.route1 = temp1;
    availArray1 = sel_intersection_composite(refPager, currentData.route1);
    load_select( "select1", currentData.route1 ); 
    load_select_composite_values( "available1", availArray1 );
  } 
 
}

function ButtonRemove1()
{
  var temp
  temp = get_select("select1")
  if( temp.length == 0 ){ return; }
  
   currentData.route1 =
   sel_intersection(currentData.route1, temp );
   availArray1 = sel_intersection_composite(refPager, currentData.route1);
   load_select( "select1", currentData.route1 ); 
   load_select_composite_values( "available1", availArray1 ); 
  
}

function ButtonSelect2()
{
  var temp
  var temp1;

  temp = get_select("available2")
  if( temp.length == 0 ){ return; }

  temp1 = currentData.route2.concat(temp);
 
  if( chooseLength( temp1 ) <= 60 )
  {
    currentData.route2 = temp1;

   availArray2 = sel_intersection_composite(refPager, currentData.route2);
   load_select( "select2", currentData.route2 ); 
   load_select_composite_values( "available2", availArray2 ); 
  }
}

function ButtonRemove2()
{
   var temp
  temp = get_select("select2")
  if( temp.length == 0 ){ return; }
  

   currentData.route2 =
   sel_intersection(currentData.route2, temp );
   availArray2 = sel_intersection_composite(refPager, currentData.route2);
   load_select( "select2", currentData.route2 ); 
   load_select_composite_values( "available2", availArray2 ); 

}

function ButtonSelect3()
{
  var temp
  var temp1;

  temp = get_select("available3")
  if( temp.length == 0 ){ return; }
  temp1 = currentData.route3.concat(temp);
 
  if( chooseLength( temp1 ) <= 60 )
  {
    currentData.route3 = temp1;

 
   availArray3 = sel_intersection_composite(refPager, currentData.route3);
   load_select( "select3", currentData.route3 ); 
   load_select_composite_values( "available3", availArray3 ); 
  }
}

function ButtonRemove3()
{
  var temp
  temp = get_select("select3")
  if( temp.length == 0 ){ return; }
  

   currentData.route3 =
   sel_intersection_composite(currentData.route3, temp );
   availArray3 = sel_intersection(refPager, currentData.route3);
   load_select( "select3", currentData.route3 ); 
   load_select_composite_values( "available3", availArray3 ); 

}

function ButtonSelect4()
{
  var temp
  var temp1;
  temp = get_select("available4")
  if( temp.length == 0 ){ return; }
  temp1 = currentData.route4.concat(temp);
 
  if( chooseLength( temp1 ) <= 60 )
  {
    currentData.route4 = temp1;

   
  availArray4 = sel_intersection_composite(refPager, currentData.route4);
  load_select( "select4", currentData.route4 ); 
  load_select_composite_values( "available4", availArray4 ); 
 } 
}

function ButtonRemove4()
{
  var temp
  temp = get_select("select4")
  if( temp.length == 0 ){ return; }
  

   currentData.route4 =
   sel_intersection(currentData.route4, temp );
   availArray4 = sel_intersection_composite(refPager, currentData.route4);
   load_select( "select4", currentData.route4 ); 
   load_select_composite_values( "available4", availArray4 ); 

}





function drawRoutes( index, data )
{
  
  var temp;
  temp =     '<td>'+data.number+'</td><td id= "NAME'+data.number+'" >'+data.name+'</td><td></td>';
  return temp;

}


function initRouting()
{
 
  // load pager array
   refPager = getPagers()
   $('#BT_SELECT1').bind('click',ButtonSelect1 );
   $('#BT_REMOVE1').bind('click',ButtonRemove1 );
   $('#BT_SELECT2').bind('click',ButtonSelect2 );
   $('#BT_REMOVE2').bind('click',ButtonRemove2 );
   $('#BT_SELECT3').bind('click',ButtonSelect3 );
   $('#BT_REMOVE3').bind('click',ButtonRemove3 );
   $('#BT_SELECT4').bind('click',ButtonSelect4 );
   $('#BT_REMOVE4').bind('click',ButtonRemove4 );
   $("#ROUTE_NUMBER").bind("keypress",numericInput);

}


function loadCreate()
{
  var data;
  data = {};
  data.key = "number";
  
  data.name = "FILL ME IN";
  data.route1 = new Array();
  data.route2 = new Array();
  data.route3 = new Array();
  data.route4 = new Array();
  data.number = findHoleElement()
  if( data.number == -1 )
  {
    alert("exceeded the maximium table elements")
  }
  else
  {
 
    loadRoutingData( data);
  }
  return data.number;
}


function loadRoutingData(data )
{
   currentData = data;
 
   $("#tab-display").tabs("select",0)
   $("#editTitle").html("Edit Route #"+data.number)
   $("#ROUTE_NUMBER").attr("value",data.number);
   $("#ROUTE_NAME").attr("value", data.name)
   if( data.route1 != null )
   {
     load_select( "select1", data.route1 )
   }
   else
   {
     data.route1 = new Array();
   }
   if( data.route2 != null )
   {
      load_select( "select2", data.route2 )
   }
   else
   {
      data.route2 = new Array();
   }
   if( data.route3 != null )
   {
      load_select( "select3", data.route3 )
   }
   else
   {
     data.route3 = new Array();
   }
   if( data.route4 !=null )
   {
     load_select( "select4", data.route4 )
   }
   else
   {
     data.route4 = new Array();
   }
   availArray1 = sel_intersection_composite(refPager, data.route1)
   availArray2 = sel_intersection_composite(refPager, data.route2)
   availArray3 = sel_intersection_composite(refPager, data.route3)
   availArray4 = sel_intersection_composite(refPager, data.route4)
   load_select_composite_values( "available1", availArray1 ) 
   load_select_composite_values( "available2", availArray2 )
   load_select_composite_values( "available3", availArray3 )
   load_select_composite_values( "available4", availArray4 ) 
 
}

function saveRoutingdata( routingArray )
{
  var number;
  var returnNumber;
  

  returnNumber = 0;
  number = $("#ROUTE_NUMBER").attr("value");
  
  currentData.key = "number";
  currentData.number = number;
  currentData.name = $("#ROUTE_NAME").attr("value");
 
  returnNumber = 0;

  if( currentData.number > masterObject.maxNumber )
  { 
    alert("Number field is to large ")
    returnNumber = -1;  
    return returnNumber;
  }
  if( routingArray[ number ] != null )
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
  

  routingArray[number] = currentData;


  return returnNumber;
}



