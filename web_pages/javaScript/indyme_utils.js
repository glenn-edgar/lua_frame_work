/*
**
**
** File: indyme_utils.js
** This file contains routines specific to Indyme Functions that
** are used multiple times
**
**
**
**
**
**
*/


function getAlarmData()
{
  var temp;

  temp = {};
  temp = getJson("/getTxdNamePair.json?name=alarms")   

  return temp;
}

function getRouteData()
{
  var temp;

  temp = {};
  temp = getJson("/getTxdNamePair.json?name=routing");   

  return temp;
}

function getPagers()
{
  var temp;

  temp = {};
  temp = getJson("/getTxdNamePair.json?name=pagedev");   

  return temp;
}

function getInputsData()
{
  var temp;

  temp = {};
  temp = getJson("/getTxdNamePair.json?name=inputs");   

  return temp;
}