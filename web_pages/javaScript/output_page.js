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

var refPager        = new Array()
var currentIndex;
var masterObject = {}
var currentData;
var availArray1

	

function getData()
{
  
  
  masterObject.inputs            = new Array();
  masterObject.inputs[0]    = loadPagerObject();
  masterObject.backup       = toJson( masterObject.inputs );
 

}

function saveData()
{
   parent.masterSave = 0;
    pushJason( "/storeTxdFile.json?name=pagedev",  masterObject.inputs[0] ); 
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
  masterObject.init  =  [0];
  masterObject.initFunctions     = [ initPager ]
  masterObject.loadCreate     =  [ loadCreate ];
  masterObject.loadControl    =  [ loadPagerData ];
  masterObject.saveData        =  [ savePagerData ];

  masterObject.drawLines = [ drawRoutes ] 
  getData();
  $("#reset").bind("click",resetData);
  $("#save").bind("click",saveData);
  showFunctionInitial()

}





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
  temp = ["PAGER"];

  return temp[index];
}











/*
   Temp Hack until AJAX calls are made
*/

function loadPagerObject()
{
var temp;

  temp = {};
  temp = getJsonFiltered("/getTxdFile.json?name=pagedev")   

  return temp;           


}







function ButtonSelect1()
{
   var temp
  temp = get_select("available1")
  
  if( temp.length == 0 ){ return; }
   
  currentData.group = currentData.group.concat(temp);
  availArray1 = sel_intersection_composite(refPager, currentData.group);
  load_select( "select1",currentData.group ); 
  load_select_composite_values( "available1", availArray1 ); 
 
}

function ButtonRemove1()
{
  var temp
  temp = get_select("select1")
  if( temp.length == 0 ){ return; }
  

   currentData.group =
   sel_intersection(currentData.group, temp );
   availArray1 = sel_intersection_composite(refPager, currentData.group);
   load_select( "select1", currentData.group ); 
   load_select_composite_values( "available1", availArray1 ); 
  
}





function drawRoutes( index, data )
{
  
  var temp;
  var tempType
  var tempArray;

  tempArray = ["SITE PAGER","WIDE AREA PAGER","AUDIO PAGER","FAX OUTPUT", "WIRELESS PHONE",
                  "EMAIL OUTPUT","GROUP PAGER","ISP EMAIL OUTPUT"];
  
  tempType = tempArray[ data.deviceType ];
  if( tempType == null )
  {
    tempType = "UNKNOWN";
  }
   
  temp =     '<td>'+data.number+'</td><td>'+data.name+'</td><td>'+tempType+'</td><td></td>';
  return temp;

}


function initPager()
{
  // load pager array
   
   $('#GROUP_PAGER_SELECT').bind('click',ButtonSelect1 );
   $('#GROUP_PAGER_REMOVE').bind('click',ButtonRemove1 );
   $("#PAGER_TYPE").bind("click",determineVisibleControls);
   $("#PAGER_NUMBER").bind("keypress",numericInput );
   $("#CAP_CODE").bind("keypress",numericInput);
   $("#PAGER_RACK_LOCATION").bind("keypress",numericInput);
   $("#BAUD_RATE").bind("keypress",numericInput);
}


function loadCreate()
{
   var data;
   
   data = { key: "number", number: 999, name: "FILL ME IN",
                       deviceType:        0,
                       sitePagerType:     0,
                       BaudRate:          0,
                       capCode:           "",
                       DialString:        "",
                       index:             0,
                       pagerRackLocation: "",
                       emailDestionation: "",
                       emailSubject: "",
                       group:   [] };   
  data.number = findHoleElement()
  if( data.number == -1 )
  {
    alert("exceeded the maximium table elements")
  }
  else
  {
   loadPagerData( data);
  }
  return data.number;
}


function loadPagerData(data )
{
  currentData = data;
  currentIndex =  data.number;
  refPager = determinePagers();
  $("#editTitle").html("Edit Output Device #"+data.number)
  $("#PAGER_NUMBER").attr("value",data.number ); 
  $("#PAGER_NAME").attr("value",data.name );
  $("#PAGER_TYPE").attr("value",data.deviceType );
 
  $("#BAUD_RATE").attr("value",data.BaudRate);
  $("#CAP_CODE").attr("value",data.capCode);
  $("#DIAL_STRING").attr("value",data.DialString) ;
  $("#SPECTRAL_LINK_QUEUE").attr("value",data.index);
  $("#PAGER_RACK_LOCATION").attr("value",data.pagerRackLocation);
  $("#EMAIL_DESTINATION").attr("value",data.emailDestination);
  $("#EMAIL_SUBJECT").attr("value",data.emailSubject );

  load_select( "select1", data.group )
  availArray1 = sel_intersection_composite(refPager, data.group);
  load_select_composite_values( "available1", availArray1 ) 
  determineVisibleControls();
}
 

function savePagerData( pagerArray )
{
 
  var returnNumber;
  currentData.number = $("#PAGER_NUMBER").attr("value" ); 
  currentData.name = $("#PAGER_NAME").attr("value" );
  currentData.deviceType  = get_singleSelect("PAGER_TYPE");
  currentData.sitePagerType  = 0;
  currentData.BaudRate = $("#BAUD_RATE").attr("value");
  currentData.capCode = $("#CAP_CODE").attr("value");
  currentData.DialString = $("#DIAL_STRING").attr("value") ;
  currentData.index = $("#SPECTRAL_LINK_QUEUE").attr("value");
  currentData.pagerRackLocation = $("#PAGER_RACK_LOCATION").attr("value");
  currentData.emailDestination = $("#EMAIL_DESTINATION").attr("value");
  currentData.emailSubject =  $("#EMAIL_SUBJECT").attr("value");
  returnNumber = 0;
  if( currentData.number > masterObject.maxNumber )
  { 
    alert("Number field is to large ")
    returnNumber = -1;  
    return returnNumber;
  }
  if( pagerArray[ currentData.number ] != null )
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

 
  pagerArray[ currentData.number] = currentData;
  return returnNumber;
}


function makeMaskVisible( mask)
{
   if( (mask & 1) != 0)
   { 
    $("#SITE_PAGER_TYPE_DIV").show();
   }
   else
   {
    $("#SITE_PAGER_TYPE_DIV").hide();
   }

   if( (mask &2 ) != 0 )
   {
     $("#BAUD_RATE_DIV").show();
   }
   else
   {
       $("#BAUD_RATE_DIV").hide();
   }


   if( (mask &4 ) != 0 )
   {

   $("#CAP_CODE_DIV").show();
   }
   else
   {
    $("#CAP_CODE_DIV").hide();
   }


   if( (mask &8 ) != 0 )
   {
      $("#DAIL_STRING_DIV").show();
   }
   else
   {

   $("#DAIL_STRING_DIV").hide(); 
      }


   if( (mask &16 ) != 0 )
   {
       $("#SPECTRAL_LINK_QUEUE_DIV").show();
   }
   else
   {

   $("#SPECTRAL_LINK_QUEUE_DIV").hide();
   }

   if( (mask &32) != 0 )
   {
      $("#PAGER_RACK_LOCATION_DIV").show();
   }
   else
   {

   $("#PAGER_RACK_LOCATION_DIV").hide();
   }

   if( (mask &64 ) != 0 )
   {
       $("#EMAIL_DESTINATION_DIV").show();
   }
   else
   {

   $("#EMAIL_DESTINATION_DIV").hide();
   }

   if( (mask &128 ) != 0 )
   {
   $("#EMAIL_SUBJECT_DIV").show();
   }
   else
   {
   $("#EMAIL_SUBJECT_DIV").hide();
   }

   if( (mask &256 ) != 0 )
   {
     $("#groupPagerTable").show();
   }
   else
   {
   $("#groupPagerTable").hide();
   }

}

var PAGER_ARRAY = [ 1 + 4 + 32,             //Site Pager
                    2+4+8+32,               //Wide Area Pager
                    8,               //Audio Pager
                    8,               //Fax Output
                   16,               //Wireless Phone
                   64+128,                //Email Output
                   256,                //Group Pager
                   64+128                 //ISP Email Pager
                 ]

function determineVisibleControls()
{
  id = get_singleSelect( "PAGER_TYPE" )
  mask = PAGER_ARRAY[id];
  if( mask == null ) { mask = 0; }
  makeMaskVisible( mask);
}


function determinePagers()
{
  var index;
  var returnValue;
  returnValue = new Array();

  for( index = 0; index < masterObject.inputs[0].length; index++)
  {
    if( (masterObject.inputs[0][index] != null) && (masterObject.inputs[0][index] != undefined ) )
    {
       if( index != currentIndex )
       { // prevent recursive pager group
          returnValue.push( [masterObject.inputs[0][index].number, masterObject.inputs[0][index].name] );
       }
    }
  }
  return returnValue;
}

