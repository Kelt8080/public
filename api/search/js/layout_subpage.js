//版面初始化
var db = document.body;
var dde = document.documentElement;
var content_height =  Math.max(db.scrollHeight, dde.scrollHeight, db.offsetHeight, dde.offsetHeight, db.clientHeight, dde.clientHeight)-60;
document.getElementById('ifrm_left_01').style.height=content_height+"px";
document.getElementById('ifrm_right_01').style.height=content_height+"px";
 



                                      
//版面變動時自動變更高度                                   
  window.addEventListener("resize", resizeFunction);
	  function resizeFunction() {
	    //自動用螢幕解析度設定iframe高度
	   var db_i = document.body;
        var dde_i = document.documentElement;
	   var content_height_i = Math.max(db_i.scrollHeight, dde_i.scrollHeight, db_i.offsetHeight, dde_i.offsetHeight, db_i.clientHeight, dde_i.clientHeight)-60;
        
        if (!window.screenTop && !window.screenY) {
             document.getElementById('ifrm_left_01').style.height=content_height_i+"px";
            document.getElementById('ifrm_right_01').style.height=content_height_i+"px";
        } else {
            document.getElementById('ifrm_left_01').style.height=content_height_i+100+"px";
            document.getElementById('ifrm_right_01').style.height=content_height_i+100+"px";
        }
        
    }


 //重新導引icon的url
 function left_setSrc(value) {
    document.getElementById('ifrm_left_01').src = value;
    document.getElementById('ifrm_left_expand').href = value;
    document.getElementById('ifrm_left_blank').href = value;
	}
	
	function right_setSrc(value) {
    document.getElementById('ifrm_right_01').src = value;
    document.getElementById('ifrm_right_expand').href = value;
    document.getElementById('ifrm_right_blank').href = value;
	}
	

