function multiplyNum(){
  var num = JSON.stringify({number: $('#num').val()});
  $.ajax({
    method: "POST",
    dataType: "json",
    contentType: "application/json",
    url: "/mult",
    data: num,
    success: function(data){
      $('#result').text($('#num').val()+" * 2 = "+data+"! It worked!!")
    }
  }) 
}
