/*
**
** File: table_handlers.js
**
**
**
**
**
**
**
*/

var ajaxDeleteStatus;
var dialogReturn;
var Jsondata;
/*
  Registering Error Handlers

*/

function ajaxDeleteError( data )
{
  ajaxDeleteStatus = 0;
}
function ajaxSuccess_a( data, textStatus)
{
  alert("web server received data ");
}
function ajaxSuccess( data, textStatus )
{
 
  Jsondata = data;
}

function ajaxError( XMLHttpRequest, textStatus, errorThrown )
{
  //alert("web server transfer error " );
  
   
}

function getText( url )
{
  var temp;
  temp = {}
  temp.url = url,
  temp.type= 'GET',
  temp.dataType= 'html',
  temp.success= ajaxSuccess,
  temp.async= false,
  temp.error= ajaxError,
  $.ajax( temp ); // making text call
  
  return Jsondata;

}

function deleteObject( url )
{
  var temp;
  ajaxDeleteStatus =1
  
  temp = {}
  tempurl =  url,
  temp.type =  'DELETE',
  temp.dataType =  'script',
  temp.async = false,
  temp.error = ajaxDeleteError,
    
  $.ajax( temp ); // making delete call
  
  
  return ajaxDeleteStatus;



}


function getScript( url )
{
  var temp;

  temp = {}
  temp.url = url,
  temp.type = 'GET',
  temp.dataType = 'script',
  temp.success = ajaxSuccess,
  temp.async = false,
  temp.error = ajaxError,
    
  
  $.ajax( temp );
  // making Json call
  
  return Jsondata;

}



function getJson( url )
{
  var temp;
  temp = {}
  temp.url = url,
  temp.type = 'GET',
  temp.dataType = 'json',
  temp.success = ajaxSuccess,
  temp.async = false,
  temp.error = ajaxError, 
  $.ajax( temp );
  // making Json call
  return Jsondata;

}


function filterJsonPush(data)
{
  var i,j
  var returnData;
 
   returnData = []
  if( data == null ){ return returnData;}
  for( i=0; i< data.length;i++ )
  {
     temp = data[i];
     
     if( temp != null)
     {
     
       index = temp[ temp.key ]
       
       returnData[index] = temp;
     }
  }
  return returnData;
}
  

function getJsonFiltered( url )
{
  var temp;
  temp = {}
  temp.url = url,
  temp.type =  'GET',
  temp.dataType = 'json',
  temp.success = ajaxSuccess,
  temp.async = false,
  temp.error = ajaxError,

  $.ajax( temp );  // making Json call
  
  temp =  filterJsonPush(Jsondata)
  return temp;

}

function pushJason( url, data )
{

 var jsonString;
 var temp;

 jsonString = toJson(data);

 temp = {}
 temp.url = url,
 temp.type = 'POST',
 temp.data = jsonString,
 temp.dataType = 'text',
 temp.success = ajaxSuccess_a,
 temp.async = false
 temp.error = ajaxError
 
  $.ajax( temp );
   // making Json call
  
  return Jsondata;
}

function pushJason_noAcknowledge( url, data )
{

 var jsonString;
 var temp;
 
 jsonString = toJson(data);

  temp = {}
  temp.url = url,
  temp.type = 'POST',
  temp.data = jsonString,
  temp.dataType =  'text',
  temp.success =  null,
  temp.async = false,
  temp.error = ajaxError,
 
  $.ajax( temp );   // making Json call
  
  return Jsondata;
}
 

function pushJason_a( url, data )
{

 var jsonString;
 var temp; 
 jsonString = toJson(data);

  temp = {}
  temp.url = url,
  temp.type = 'POST',
  temp.data = jsonString,
  temp.dataType = 'text',
  temp.async = false,
  temp.error = ajaxError,
    
 
 
  $.ajax( temp ); // making Jason call
  
  return Jsondata;
}





function toJson( temp)
{
  return JSON.stringify( temp );

}


function parseJson( temp )
{
  return JSON.parse( temp );
 
}





function initLocalControls( index )
{
   if( masterObject.initFunctions  [index] != null )
   {
      masterObject.initFunctions  [index]();
   }
}

function registerControlButtons( index )
{
   var temp1;
   var temp2;
   var temp3;
   var temp4;
   var temp5;
   var temp6;
   var temp7;
   var temp8;

 
   $("#duplicateDialog").hide();
   $("#groupMove").hide();
   $("#groupDelete").hide();
   $("#copyDialog").hide();
   $("#dupSave").bind("click",dupSave);
   $("#dupReset").bind("click",dupReset); 
   $("#moveSave").bind("click",moveSave);
   $("#moveReset").bind("click",moveReset); 
   $("#deleteSave").bind("click",delSave);
   $("#deleteReset").bind("click",delReset); 
   $("#copySave").bind("click",copySave);
   $("#copyReset").bind("click",copyReset);
   
	



   temp1 = "#editSave-"+index;
   temp2 = "#editReset-"+index;
   temp3 = "#create-"+index;
   temp4 = "#duplicate-"+index;
   temp5 = "#delete-"+index;
   temp6 = "#groupDelete-"+index;
   temp7 = "#groupMove-"+index;
   temp8 = "#copy-"+index;
   temp9 = "#TOP_CH-"+index;

    $("#save").attr("disabled", true);
   $(temp1).bind("click",
   function()
   {
    // save button
     var tempRow;
     var tempEdit;
     if(  masterObject.saveData[ masterObject.currentIndex ](masterObject.inputs[masterObject.currentIndex]) == 0 )
     {
        $("#save").attr("disabled", false);
        parent.masterSave = 1;
        tempRow = "#row-"+index;
        $(tempRow).show();
        tempEdit = "#edit-"+index;
        $(tempEdit).hide();
        drawLines( 0 );
      }

     }
   );
   $(temp2).bind("click",
   function()
   {
     // reset button
     var tempRow;
     var tempEdit;
     var index;
     var number;
     index =  masterObject.currentIndex;
     number = masterObject.currentNumber;
     /*
        donot need to save because data is not saved
     */
      if( masterObject.elementSave != null)
      {
       masterObject.inputs[index][number] = parseJson( masterObject.elementSave);
      }
     tempRow = "#row-"+index;
     $(tempRow).show();
     tempEdit = "#edit-"+index;
     $(tempEdit).hide();

     drawLines( 0 );
   
   

    }
   );
   $(temp3).bind("click",
    function()
    { 
       // create button
       var tempRow;
       var tempEdit;
       var status;
       tempRow = "#row-"+index;
       $(tempRow).hide();
       tempEdit = "#edit-"+index;
       masterObject.currentIndex = getCurrentTab();
       masterObject.currentNumber = null;
       masterObject.elementSave = null;
       status = masterObject.loadCreate[getCurrentTab()]();
       if( status < 0 )
       {
         $(tempRow).show()
         $(tempEdit).hide()
       }
       else
       {
         $(tempEdit).show();
       }

    });
    $(temp5).bind("click",
    function()
    {
        var i;
        var tabIndex;
        var maxNumber;
        var tempData;
        var count;
        var temp;
        count = 0;

        tabIndex = getCurrentTab();
        tempData = masterObject.inputs[tabIndex];
        maxNumber = tempData.length;
        for( i = 0; i < maxNumber; i++ )
        {
          
           if( $('#CH'+tabIndex+"_"+i).attr("checked") == true )
           {   
              
              count = count +1;
              tempData[i] = null;
              // remove row from table
              $("#tr" + i ).remove();
           }
       }
       masterObject.inputs[tabIndex] = tempData;

       if( count != 0  )
       {
         $("#save").attr("disabled", false);
         parent.masterSave = 1;
       }
       else
       {
         getGroupDeleteData()
       }
       $("#TOP_CH-"+tabIndex).attr("checked",false);
    });

   $(temp4).bind("click",
    function()
    {
        getDuplicateData();
    });

/*
    $(temp6).bind("click",
    function()
    {
       getGroupDeleteData();
 
    });
*/
    $(temp7).bind("click",
    function()
    {
       getGroupMoveData();


    });
   $(temp8).bind("click",
    function()
    {
        getCopyData();

    });
  $(temp9).bind("click",
   function()
   {
     
     MasterCheck();
   });

  $("#duplicateInput").bind("keypress",numericInput);
  $("#copyInput1").bind("keypress",numericInput);
  $("#copyInput2").bind("keypress",numericInput);
  $("#copyInput3").bind("keypress",numericInput);
  $("#groupDeleteInput1").bind("keypress",numericInput);
  $("#groupDeleteInput2").bind("keypress",numericInput);
  $("#groupMoveInput1").bind("keypress",numericInput);
  $("#groupMoveInput2").bind("keypress",numericInput);
  $("#groupMoveInput3").bind("keypress",numericInput);

}






function  drawLines(  )
{ 
   var i
   var tempData;
   var tempTable;
   var tempString;
   var start;
   var end;
   var tab_index;

   var index = 0

   $("#TOP_CH-0").attr("checked",false);
   tab_index =  masterObject.tab_index;

   tempTable = "#table-"+index;

   $(tempTable).find("tr:gt(0)").remove()
 
   tempData = masterObject.inputs[index];
   if( tempData === undefined) { return;}

   start = tab_index *100 +1;
   end = start +99;
   
   // set tab index


   if( end > tempData.length )
   {
     end = tempData.length
   }

  
   disableEmptyTabs()
   for( i = start; i <= end ;i++)
   { 
    
      if( tempData[i] != null )
      {
         
         tempString = drawButtons( index, i);
         if( masterObject.drawLines[index] != null )
         {
            tempString = tempString + masterObject.drawLines[index]( index, tempData[i]);
         }
         tempString = tempString +   ' </tr> '
         $(tempTable).append(tempString)
         addFunctions(index, i);
      }
   }
   stripTable(tempTable);
}


function disableEmptyTabs()
{
  var i;
  var j;
  var tempData;
  
  for( i = 0; i < 10 ; i++ )
  {
    $('#tabs').tabs('disable',i);
  }
  tempData = masterObject.inputs[0];
  if( tempData === undefined) { return;}
 
  for( j = 0; j < 10 ; j++ )
  {
    if( j*100 +1 > masterObject.maxNumber ) { break;}
   
    for( i = j*100 +1; i < (j*100+101) ; i ++ )
    {
      
      if( tempData[i] != null )
      {
     
       $('#tabs').tabs('enable',j);
       break;
      }
    }
  }
}


function stripTable(table)
{
  $(table+' tr:eq(0)').addClass('header')
  $(table+' tbody tr:odd').addClass('odd')
  $(table+' tbody tr:even').addClass('even')
}


function drawButtons( index, number )
{
  var temp;

  temp = '<tr align= center id ="tr'+ number+'" >';
  temp = temp + ' <td> ';
  temp = temp + ' <input type="checkbox"   id="CH'+index+"_"+number+'" >';
  temp = temp +  ' </td>  ';
  temp = temp +   ' <td align=right>  ';
  temp = temp +   ' <button id= "DEL'+index+"_"+number+'"  type = "button">Delete</button>'
  temp = temp +    '</td> '
  temp = temp +    '<td align=left> '
  temp = temp +    '<button id = "EDIT'+index+"_"+number+'"  type = "button">Edit</button>'
  temp = temp +    '</td>' 
  return temp
}


function addFunctions( index, number )
{
  
  $('#DEL'+index+"_"+number).bind( 'click',
   function( )
   {  
     $("#save").attr("disabled", false);
     parent.masterSave = 1;
     masterObject.inputs[index][number] = null;
     $("#tr" + number ).remove();
     //drawLines(  index );
   }
  );
  $('#EDIT'+index+"_"+number).bind( 'click', 

     function(  ) 
     { 
         var tempRow;
         var tempEdit;
       
         masterObject.currentIndex = index;
         masterObject.currentNumber = number;
         masterObject.elementSave = toJson(masterObject.inputs[index][number])
         masterObject.loadControl[index](masterObject.inputs[index][number]);
         masterObject.inputs[index][number] = null;
         tempRow = "#row-"+index;
         $(tempRow).hide();
         tempEdit = "#edit-"+index;
         $(tempEdit).show();
         
      }

      );
}


function resetData()
{ 
  parent.masterSave = 0;
  masterObject.inputs = parseJson( masterObject.backup );
  drawLines( 0 )

  $("#save").attr("disabled", true);
  parent.masterSave = 0;
}


function getDuplicateData()
{
  $("#duplicateInput").attr("value","");
  $("#duplicateDialog").dialog({modal:true});
  $("#duplicateDialog").dialog("open")
}


function getGroupMoveData()
{

  $("#groupMoveInput1").attr("value","");
  $("#groupMoveInput2").attr("value","");
  $("#groupMoveInput3").attr("value","");
  $("#groupMove").dialog({modal:true});
  $("#groupMove").dialog("open")
}

function getGroupDeleteData()
{
  $("#groupDeleteInput1").attr("value","");
  $("#groupDeleteInput2").attr("value","")
  $("#groupDelete").dialog({modal:true});
  $("#groupDelete").dialog("open")
}

function getCopyData()
{
 $("#copyInput1").attr("value","");
 $("#copyInput2").attr("value","")
 $("#copyInput3").attr("value","")
 $("#copyDialog").dialog({modal:true});
 $("#copyDialog").dialog("open")
 

}



function doOkDel()
{
   
   dialogReturn = {};
   dialogReturn.flag = true;
   $("#groupDelete").close();
}

function doCancelDel()
{
   dialogReturn = {};
   dialogReturn.flag = false;
   $("#groupDelete").close();
}

function doOkCopy()
{
   dialogReturn = {};
   dialogReturn.flag = true;
   $("#copyDialog").close();
}

function doCancelCopy()
{
   dialogReturn = {};
   dialogReturn.flag = false;
   $("#copyDialog").close();
}

function MasterCheck()
{
   var i;
   var tabIndex;
   var tempData;
   var maxNumber;
   var state;

   tabIndex = getCurrentTab();
   tempData = masterObject.inputs[tabIndex];
   maxNumber = tempData.length;
  
   state = $("#TOP_CH-"+tabIndex).attr("checked");

   for( i = 0; i < maxNumber; i++ )
   {
    
     if( state === true )
     {
  
        $('#CH'+tabIndex+"_"+i).attr("checked",true);
    
     }
     else
     {
        $('#CH'+tabIndex+"_"+i).attr("checked",false);
    
 
     }
   }
   
  


}

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
                 alert("maximum number of "+masterObject.maxNumber+" created ");
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
        //tempValue.name = getGurrentName( tabIndex) + " "+start;
        tempValue.number = start
        tempValue.key = "name"
        tempData[start] = tempValue;
        start = start +1;

     }
   }
   if( number == 0 )
   {
      alert("no operations performed")
   }
   else
   {
        $("#save").attr("disabled", false);
        parent.masterSave = 1;
   }
   masterObject.inputs[tabIndex] = tempData;
   drawLines( 0); 

  $("#form").show();
   $("#duplicateDialog").dialog("close");
   $("#duplicateDialog").dialog("destroy");
  $("#TOP_CH-"+tabIndex).attr("checked",false);
}

function dupReset()
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
 
   tabIndex = getCurrentTab();
   tempData = masterObject.inputs[tabIndex];
   maxNumber = tempData.length;

   start = 10;
 
   for( i = 0; i < maxNumber; i++ )
   {
        
     if( $('#CH'+tabIndex+"_"+i).attr("checked") == true )
     {
        $('#CH'+tabIndex+"_"+i).attr("checked",false);
 
     }
   }
   $("#duplicateDialog").dialog("close");
   $("#duplicateDialog").dialog("destroy");
  $("#form").show();
  $("#duplicateDialog").hide();
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
                 alert("maximum number of "+masterObject.maxNumber+" created ");
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
             //tempValue.name = getGurrentName( tabIndex) + " "+base;
             tempValue.number = base
             //tempValue.name = getGurrentName( tabIndex) + " "+base;
             tempValue.key ="number"
             tempData[base] = tempValue;
             base = base -1;
    }
           
  }
   if( number == 0 )
   {
      alert("no operations performed")
   }
   else
   {
        $("#save").attr("disabled", false);
        parent.masterSave = 1;
  }
  masterObject.inputs[tabIndex] = tempData;
  drawLines(0 ); 


  $("#form").show();
  $("#groupMove").dialog("close");
  $("#groupMove").dialog("destroy");
  $("#TOP_CH-"+tabIndex).attr("checked",false);
}

function moveReset()
{
  $("#form").show();
  $("#groupMove").dialog("close");
  $("#groupMove").dialog("destroy");

}



function delSave()
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
   var number;
   
   number = 0;
   tabIndex = getCurrentTab();
   tempData = masterObject.inputs[tabIndex];
   maxNumber = tempData.length;
   start = $("#groupDeleteInput1").attr("value");
   start = parseInt(start);
   end = $("#groupDeleteInput2").attr("value");
   end = parseInt(end);
   for( i = start; i <= end; i++ )
   {
      if( tempData[i] != null )
      {
        number = number+1;
        $("#tr" + i ).remove();
        tempData[i] = null;
      }
           
  }
  masterObject.inputs[tabIndex] = tempData;
  //drawLines( tabIndex ); 
   if( number == 0 )
   {
      alert("no operations performed")
   }
   else
   {
        $("#save").attr("disabled", false);
        parent.masterSave = 1;
  }
  $("#form").show();
  $("#groupDelete").dialog("close");
  $("#groupDelete").dialog("destroy");
  $("#TOP_CH-"+tabIndex).attr("checked",false);
}

function delReset()
{
  $("#form").show();
  $("#groupDelete").dialog("close");
  $("#groupDelete").dialog("destroy");

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
                 alert("maximum number of "+masterObject.maxNumber+" created ");
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
       //tempValue.name = getGurrentName( tabIndex) + " "+i;
       tempValue.key = "number"

      }
   }
   if( number == 0 )
   {
      alert("no operations performed")
   }
   else
   {
        $("#save").attr("disabled", false);
        parent.masterSave = 1;
   }
   masterObject.inputs[tabIndex] = tempData;
   drawLines(0 ); 
   $("#form").show();
   $("#copyDialog").dialog("close");
   $("#copyDialog").dialog("destroy");
   $("#TOP_CH-"+tabIndex).attr("checked",false);
}

function copyReset()
{
  $("#form").show();
   $("#copyDialog").dialog("close");
   $("#copyDialog").dialog("destroy");
 

}



function findHoleElement()
{
  var returnValue;
  var dataElement;
  var i;

  dataElement = masterObject.inputs[0]
  returnValue = -1;

  for( i = 1; i <= masterObject.maxNumber; i++ )
  {
    if( dataElement[i] == null )
    {
      return i;
    }

  }
  return returnValue;
 
}

function chooseLength(array)
{
  var i;
  var j;
  var returnValue;
  returnValue = 0;

  for( i = 0; i < array.length; i++ )
  {
     returnValue = returnValue + array[i].length + 1;
  }
  returnValue = returnValue - 1;
  return returnValue
} 
