"use strict";
function button1(){
  var x = document.getElementById("number").innerHTML;
  window.alert(x);
}

function button2(){

  var x = document.getElementById("number").innerHTML;
  x = Number(x) + 1;
  document.getElementById("number").innerHTML = x;
}

function button3(){
  var x = document.getElementById("number").innerHTML;
  var par = document.createElement("p");
  var value = document.createTextNode(x);
  par.appendChild(value);
  var element = document.getElementById("div1");
  element.appendChild(par);
}
