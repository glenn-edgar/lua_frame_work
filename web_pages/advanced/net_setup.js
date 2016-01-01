/*

  File net_setup.js
  This is the script file for system_setup.html

*/

var dataObject;



function generateDefaultData()
{

  var returnValue;
  returnValue = {}
  returnValue.DynamicIp  = true;
  returnValue.NetworkIp  = " ";
  returnValue.NetworkMask = " ";
  returnValue.NetworkGateway = " ";
  returnValue.DNS =" ";
  returnValue.NTP_ENABLE = false;
  returnValue.NTP = new Array();
  returnValue.NTP[0] = " ";
  returnValue.NTP[1] = " ";  
  return returnValue;
}



function getData()
{
   // make ajax call
   /* 
      temporary Hack
   */
   dataObject = {};
   dataObject = getJson("/getTxdFile.json?name=netdata")
   if( dataObject == null )
   {
     dataObject = generateDefaultData()
     return;
   }   
   if( dataObject.NetworkIp == "" ) 
   {
     dataObject.DynamicIp = true;
   }
   else
   {
     dataObject.DynamicIp = false;
   }
   if( dataObject.NTP_ENABLE == 0 )
   {
     dataObject.NTP_ENABLE = false
   }
   else
   {
    dataObject.NTP_ENABLE = true
   }  


 }

 

function visableControls()
{
  if( $("#DYNAMIC").attr("checked") == false )
  {
   $("#IP").attr("disabled", false);
   $("#MASK").attr("disabled", false);
   $("#GATEWAY").attr("disabled", false);
   $("#DNS").attr("disabled", false);
   $("#IP_LABEL").show();
   $("#MASK_LABEL").show();
   $("#GATEWAY_LABEL").show();
   $("#DNS_LABEL").show();

  }
  else
  {
   $("#IP").attr("disabled", true);
   $("#MASK").attr("disabled", true);
   $("#GATEWAY").attr("disabled", true);
   $("#DNS").attr("disabled", true);
   $("#IP_LABEL").show();
   $("#MASK_LABEL").show();
   $("#GATEWAY_LABEL").show();
   $("#DNS_LABEL").show();

  }
  NTP_ENABLE()
  
 }

function NTP_ENABLE()
{
  if( $("#NTP_ENABLE").attr("checked") == false )
  {
   
   $("#NTP_1").attr("disabled", true);
   $("#NTP_2").attr("disabled", true); 
 
  }
  else
  {
    
   $("#NTP_1").attr("disabled", false);
   $("#NTP_2").attr("disabled", false); 

  }
  
 }

function loadControls()
{
   $("#DYNAMIC").attr("checked", dataObject.DynamicIp );
   $("#IP").attr("value", dataObject.NetworkIp );
   $("#MASK").attr("value", dataObject.NetworkMask );
   $("#GATEWAY").attr("value", dataObject.NetworkGateway );
   $("#DNS").attr("value", dataObject.DNS );
   $("#NTP_ENABLE").attr("checked",dataObject.NTP_ENABLE);
   $("#NTP_1").attr("value", dataObject.NTP[0] );
   $("#NTP_2").attr("value", dataObject.NTP[1] );
   visableControls();
}


function ready()
{
   getData()
   referenceObjectToJson( dataObject )
   loadControls();

   // data if from misc.txd
   $('#save').bind('click',saveButton );
   $('#reset').bind('click',clearButton );
   $("#DYNAMIC").bind("click",visableControls);
   $("#NTP_ENABLE").bind("click",NTP_ENABLE);
   $("#IP").bind("keypress",networkInput);
   $("#MASK").bind("keypress",networkInput);
   $("#GATEWAY").bind("keypress",networkInput);
   $("#DNS").bind("keypress",networkInput);

}




function saveButton()
{
  masterSaveFlag = 0;
  dataObject = {}
  dataObject.NTP   = []
  dataObject.DynamicIp      = $("#DYNAMIC").attr("checked");
  dataObject.NetworkIp      = $("#IP").attr("value" );
  dataObject.NetworkMask    = $("#MASK").attr("value" );
  dataObject.NetworkGateway = $("#GATEWAY").attr("value" );
  dataObject.DNS            = $("#DNS").attr("value" );
  dataObject.NTP_ENABLE     = $("#NTP_ENABLE").attr("checked");
  dataObject.NTP[0]         = $("#NTP_1").attr("value" );
  dataObject.NTP[1]         = $("#NTP_2").attr("value" );     
  if( dataObject.DynamicIp == true )
  {
    dataObject.NetworkIp = ""
  }
  
 if( dataObject.NTP_ENABLE == true )
 {
   dataObject.NTP_ENABLE = 1;
 }
 else
 {
  dataObject.NTP_ENABLE = 0;
 }
  pushJason( "/storeTxdFile.json?name=netdata", dataObject ); 
  
  referenceObjectToJson( dataObject);

}

function clearButton()
{
   masterSaveFlag = 0;
   dataObject = reloadObject();
   loadControls();
}





function referenceObjectToJson( temp)
{
  referenceJsonString = JSON.stringify( temp );

}


function reloadObject()
{
   return JSON.parse( referenceJsonString );
   
}

$(document).ready( ready);



