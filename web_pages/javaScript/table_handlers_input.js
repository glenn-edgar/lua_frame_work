/*
**
** File: table_handlers_input.js
** The purpose of this file is to over load copy move duplicate functions for input handler
**
**
**
**
**
**
*/





function dupSave()
{
   var i;
   var tabIndex;
   var maxNumber;
   var tempData;
   var returnValue;
   var temp;
   var tempValue;
   var tempString;
   var start;
   var number;
   var alertFlag;
 
   tabIndex = getCurrentTab();
   tempData = masterObject.inputs[tabIndex];
   maxNumber = tempData.length;

   start = $("#duplicateInput").attr("value");
   start = parseInt(start);
   alertFlag = 0;
   number = 0;
   for( i = 0; i < maxNumber; i++ )
   {
        
     if( $('#CH'+tabIndex+"_"+i).attr("checked") == true )
     {
       if( start > masterObject.maxNumber )
       {
                 alert("maximum number of "+masterObject.maxNumber+" \n aborting");
                 break;
       } 
        number = number+1
        $('#CH'+tabIndex+"_"+i).attr("checked",false);
        tempString = toJson( tempData[i]);
        if( tempData[start] != null )
        {
          if( alertFlag == 0 )
          {
             if( confirm("Write over existing data") )
             {
                 alertFlag = 1
             }
             else
             {
               break;
             }
           }
        }         
        tempData[start] =parseJson( tempString );
        tempValue = tempData[start]
        tempKey = tempValue.key;
        tempValue.name = getGurrentName( tabIndex) + " "+start;
        tempValue.number = start
        tempValue.alarmNumber = start;
        tempValue.key = "name"
        tempData[start] = tempValue;
        start = start +1;

     }
   }
   if( number == 0 )
   {
      alert("no operations performed")
   }

   masterObject.inputs[tabIndex] = tempData;
   drawLines( 0); 

  $("#form").show();
   $("#duplicateDialog").dialog("close");
   $("#duplicateDialog").dialog("destroy");
  $("#TOP_CH-"+tabIndex).attr("checked",false);
}

function moveSave()
{
  var i;
  var tabIndex;
  var maxNumber;
  var tempData;
  var returnValue;
  var temp;
  var tempValue;
  var tempString;
  var start;
  var end;
  var base;
  var number;  
  var alertFlag;

  tabIndex = getCurrentTab();
  tempData = masterObject.inputs[tabIndex];
  maxNumber = tempData.length;

   start = $("#groupMoveInput1").attr("value");
   start = parseInt(start);
   end = $("#groupMoveInput2").attr("value");
   end = parseInt(end);
   base = $("#groupMoveInput3").attr("value");
   base = parseInt(base);
   base = base+(end-start)
  number = 0
  alertFlag = 0
  for( i =end; i >= start; i-- )
  {
     if( tempData[i] != null )
     {
             if( base > masterObject.maxNumber )
             {  
                 alert("maximum number of "+masterObject.maxNumber+" \n aborting");
                 break;
             }
             number = number+1;
             tempString = toJson( tempData[i]);
             if( tempData[base] != null )
             {
                if( alertFlag == 0 )
                {
                  if( confirm("Write over existing data") )
                  {
                     alertFlag = 1
                  }
                  else
                  {
                      break;
                  }
                }
             }         
             tempData[base] =parseJson( tempString );
             tempData[i] = null;
             tempValue = tempData[base]
             tempKey = tempValue.key;
             
             tempValue.number = base
             tempValue.alarmNumber = base
             tempValue.name = getGurrentName( tabIndex) + " "+base;
             tempValue.key ="number"
             tempData[base] = tempValue;
             base = base -1;
    }
           
  }
   if( number == 0 )
   {
      alert("no operations performed")
   }

  masterObject.inputs[tabIndex] = tempData;
  drawLines(0 ); 


  $("#form").show();
  $("#groupMove").dialog("close");
  $("#groupMove").dialog("destroy");
  $("#TOP_CH-"+tabIndex).attr("checked",false);
}



function copySave()
{
  var i;
  var tabIndex;
  var maxNumber;
  var tempData;
  var temp;
  var tempValue;
  var tempString;
  var start;
  var end;
  var copyIndex;
  var number;
  var alertFlag;
        
  tabIndex = getCurrentTab();
  tempData = masterObject.inputs[tabIndex];
  maxNumber = tempData.length;

  copyIndex = $("#copyInput1").attr("value");
  copyIndex = parseInt(copyIndex);
  start = $("#copyInput2").attr("value");
  start = parseInt(start);
  end = $("#copyInput3").attr("value");
  end = parseInt(end);
  number = 0;
  alertFlag = 0;
  tempString = toJson( tempData[copyIndex]);   
  
  if( (tempString != null) && (tempString != undefined) )
  {
     for( i = start; i <= end; i++ )
     {
       
       if( i > masterObject.maxNumber )
       {
                 alert("maximum number of "+masterObject.maxNumber+" \n aborting");
                 break;
       } 
       number = number+1;
       if( tempData[i] != null )
        {
          if( alertFlag == 0 )
          {
             if( confirm("Write over existing data") )
             {
                 alertFlag = 1
             }
             else
             {
               break;
             }
           }
        }  
       tempData[i] =parseJson( tempString );
       tempValue = tempData[i]
       tempKey = tempValue.key;
       tempValue.number = i;
       tempValue.name = getGurrentName( tabIndex) + " "+i;
       tempValue.alarmNumber = i;
       tempValue.key = "number"

      }
   }
   if( number == 0 )
   {
      alert("no operations performed")
   }
   masterObject.inputs[tabIndex] = tempData;
   drawLines(0 ); 
   $("#form").show();
   $("#copyDialog").dialog("close");
   $("#copyDialog").dialog("destroy");
   $("#TOP_CH-"+tabIndex).attr("checked",false);
}


