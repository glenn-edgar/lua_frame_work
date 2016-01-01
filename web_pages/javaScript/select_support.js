/*
**
** File: select_support.js
** This file contains select support routines
**
**
**
**
**
**
**
*/

/*
**
** Loads select object
**
**
*/
// Fast javascript function to clear all the options in an HTML select element
// Provide the id of the select element
// References to the old <select> object will become invalidated!
// This function returns a reference to the new select object.
function ClearOptionsFast(id)
{
	var selectObj = document.getElementById(id);
	var selectParentNode = selectObj.parentNode;
	var newSelectObj = selectObj.cloneNode(false); // Make a shallow copy
	selectParentNode.replaceChild(newSelectObj, selectObj);
	return newSelectObj;
}

function load_select_composite_values( id, data_array, selectedItem)
{
 var selectObj
 var i
 
 
 selectObj = ClearOptionsFast(id);
 
 for( i = 0; i < data_array.length; i++)
 {
   if( ( data_array[i] != undefined ) && (data_array[i] != null ) )
   {
      if( selectedItem == data_array[i][0])
      {
         selectObj.options[i] = new Option("#"+data_array[i][0]+" -->  "
                +data_array[i][1],data_array[i][0],false,true);
      }
      else
      {
         selectObj.options[i] = new Option("#"+ data_array[i][0]+" -->  "
         +data_array[i][1],data_array[i][0],false,false);
      }
   }
 }

}




function load_select_values( id, data_array,value_array, selectedItem)
{
 var selectObj
 var i


 selectObj = ClearOptionsFast(id);
 
 for( i = 0; i < data_array.length; i++)
 {
   
   if( selectedItem == value_array[i])
   {
      selectObj.options[i] = new Option( data_array[i],value_array[i],false,true);
   }
   else
   {
      selectObj.options[i] = new Option( data_array[i],value_array[i],false,false);
   }
 }

}


function load_select( id, data_array, selectedItem)
{
 var selectObj
 var i

 selectObj = ClearOptionsFast(id);
 
 
 if( data_array == null ) { return; }
 if( data_array == undefined) { return;}
 data_array = repackArray(data_array);
 for( i = 0; i < data_array.length; i++)
 {
  
   if( selectedItem == data_array[i])
   {
        
         selectObj.options[i] = new Option( data_array[i],data_array[i],false,true);
 
   }
   else
   {
     
        
        selectObj.options[i] = new Option( data_array[i],data_array[i],false,false);
  
   }
   
 }

}

function load_select_a( id, data_array, selectedItem)
{
 var selectObj
 var i

 selectObj = ClearOptionsFast(id);
 
 
 if( data_array == null ) { return; }
 if( data_array == undefined) { return;}
 
 for( i = 0; i < data_array.length; i++)
 {
  
  
   if( selectedItem == data_array[i])
   {
        
         selectObj.options[i] = new Option( data_array[i],data_array[i],false,true);
 
   }
   else
   {
     
        
        selectObj.options[i] = new Option( data_array[i],data_array[i],false,false);
  
   }
   
 }

}


function removeSelection(id)
{
  var selectObj;
  var i;
  var returnValue = new Array();

  selectObj = document.getElementById(id);
  
  for( i = 0; i< selectObj.options.length; i++)
  {
    if( selectObj.options[i].selected == true)
    {
       selectObj.options[i].selected = false;
    }
  }

}


function get_select( id )
{
  var selectObj;
  var i;
  var returnValue = new Array();

  selectObj = document.getElementById(id);
  
  for( i = 0; i< selectObj.options.length; i++)
  {

    if( selectObj.options[i].selected == true)
    {
       
       returnValue.push(selectObj.options[i].value)
    }
  }

  return returnValue;
}

function get_selectIndexes( id )
{
  var selectObj;
  var i;
  var returnValue = new Array();

  selectObj = document.getElementById(id);
  
  for( i = 0; i< selectObj.options.length; i++)
  {
    if( selectObj.options[i].selected == true)
    {
       returnValue.push(i)
    }
  }

  return returnValue;
}


function get_singleSelect( id )
{
  var temp;
  var selectObj;
  var i;
  var returnValue = new Array();

  selectObj = document.getElementById(id);
  
  for( i = 0; i< selectObj.options.length; i++)
  {
    if( selectObj.options[i].selected == true)
    {
       returnValue.push(selectObj.options[i].value)
    }
  }
  if( returnValue.length == 0 )
  {
    temp = null;
  }
  else
  {
    temp = returnValue[0];
  }
  return temp;
}


/*
**
** Finds intersection and returns sorted array
**
**
*/
function sel_intersection( array1, array2)
{
   var i;
   var j;
   
   var returnValue = new Array()

   for( i = 0; i < array1.length;i++)
   {
       if( sel_contains( array2, array1[i] ) == false)
       {
             returnValue.push(array1[i])
       }
   }
   returnValue = repackArray(returnValue);
   return returnValue;
}

function sel_intersection_composite( array1, array2)
{
   var i;
   var j;
   var temp;
   
   var returnValue = new Array()

   for( i = 0; i < array1.length;i++)
   {
       temp = array1[i]
       if( sel_contains( array2, temp[0]) == false)
       {
             returnValue.push(array1[i])
       }
   }
   
   return returnValue;
}

function sel_contains( array1, data1)
{
   var i;
  
   if( array1 == undefined){ return false };
   for( i= 0; i < array1.length ; i++)
   {
     if( array1[i] == data1)
     {
       return true;
     }
   }
   return false;
}


function repackArray(data_array)
{
  var returnValue;
  var i;

  returnValue = new Array();

  for( i = 0 ; i < data_array.length; i++)
  { 
    data_array[i] = data_array[i] +"" ; // converting data to string
    data_array[i] = trim( data_array[i])
    if( ( data_array[i] != null ) && ( data_array[i] != ""))
    {
      
      returnValue.push( data_array[i] )
    }
  }
  return returnValue;
}

function trim(stringToTrim) {
	return stringToTrim.replace(/^\s+|\s+$/g,"");
}
function ltrim(stringToTrim) {
	return stringToTrim.replace(/^\s+/,"");
}
function rtrim(stringToTrim) {
	return stringToTrim.replace(/\s+$/,"");
}


