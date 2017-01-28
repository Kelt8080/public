//版面初始化

  //自動用螢幕解析度設定iframe高度
  var db = document.body;
  var dde = document.documentElement;
  var content_height = Math.max(db.scrollHeight, dde.scrollHeight, db.offsetHeight, dde.offsetHeight, db.clientHeight, dde.clientHeight)-105;
  document.getElementById('ifrm_main').style.height=content_height+"px";


   //重新導引icon的url
	function setSrc(value) {
    document.getElementById('ifrm_main').src = value;
	}
	
	function newSrc() {
      var e = document.getElementById("MySelectMenu");
      var newSrc = e.options[e.selectedIndex].value;
      document.getElementById("MyFrame").src=newSrc;
     }
	