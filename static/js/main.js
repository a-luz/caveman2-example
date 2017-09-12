function multiplyNum(){
  var num = JSON.stringify({number: $('#num').val()});
  $.ajax({
    method: "POST",
    dataType: "json",
    contentType: "application/json",
    url: "/mult",
    data: num,
    success: function(data){
      $('#result').text($('#num').val()+" * 2 = "+data+"! It worked!!");
    }
  }) 
}

function insertUser(){
  var info = JSON.stringify({usrName: $('#usrName').val(), usrEmail: $('#usrEmail').val(), usrPwd: $('#usrPwd').val()});
  
    $.ajax({
    method: "POST",
    dataType: "json",
    contentType: "application/json",
    url: "/insert",
    data: info,
    success: function(data){
      $('#insert_result').text("User added to database!");
    }
  }) 
}
