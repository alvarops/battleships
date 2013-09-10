var BS = {
	gameId : 0,
	interval : 500,
	currentUser : 0,
	currentShot : 0,
	data :{},	
	getData : function(gameId) {
		console.log('Getting data');
		this.gameId = gameId;
		var that = this;
		$.ajax({
			url: 'call.php?gameId=' + gameId,
			cache: false,
			//type : 'json', 
			success : function(data) {
				console.log('HERE');
				that.data = data;
				console.log(that.data);
				that.sizeX = data.boardX;
				that.sizeY = data.boardY;
				that.numOfFields = (that.sizeX - 1) * (that.sizeY - 1);
				that.drawBoards();
				that.showNextShot();
			},
			error : function (a,b,c) {
				console.log(a);
				console.log(b);
				console.log(c);
			}
		});
	},
	
	showNextShot : function () {
		var i = 0;
		for(i = 0; i < this.data.players.length; i++){
			if(typeof(this.data.players[i].shots[this.currentShot]) !== 'undefined') {
				this.shot(this.data.players[i].id, this.data.players[i].shots[this.currentShot], this.currentShot + 1);
			}
		} 
		this.currentShot += 1;
		if (this.currentShot <= this.numOfFields) {
			var that=this;
			var t = setTimeout(function(){that.showNextShot();},that.interval);
		}
	},
	
	drawBoard : function (id, name) {
		var i = 0;
		var j = 0;
		var h = '<div class="playerContainer" id="container' + id + '"><h2>' + name + '</h2><table class="board" id="board' + id + '">';
		for(i = 0; i < this.sizeY; i++){
			h += '<tr>';
			for(j = 0; j < this.sizeX; j++){
				h += '<td><div class="empty"></div></td>';
			}
			h += '</tr>';
		}
		h += '</table><h3>Game log</h3><ul id="log' + id + '"></ul></div>';
		return h;
	},
	
	drawBoards : function () {
		var i = 0;
		for(i = 0; i < this.data.players.length; i++){
			$('.body').append(this.drawBoard(this.data.players[i].id, this.data.players[i].name));
		}
		$('.body').append('<div class="clear"></div>');
	},
	
	shot : function (id, data, num) {
	    var elem=$('#board' + id + ' tr').eq(data.y).find('td').eq(data.x);
	    var shotStatus = data.status;
	    if ($(elem).find('div.empty').length === 0){
	    	shotStatus = 'samespot';
	    }
	    $(elem).html('<div class="ship_' + data.shipId + ' '  + shotStatus + '"></div>');
	    console.log(shotStatus);
	    if (shotStatus === 'hitsunk') {
	    	console.log(shotStatus);
	    	$('#board' + id +' .ship_' + data.shipId).removeClass('hit').addClass('hitsunk');
	    }
	    
	    //Ad log
	    var html ='<li class="shotStatus ' + shotStatus + '">Shot ' + num + ' - x:' + data.x + ' y:' + data.y;
	    switch(shotStatus){
	    	case 'miss' :
	    		html += ' - miss';
	    	break;
	    	case 'hit' :
	    		html += ' - hit ' + data.shipType + '!';
	    	break;
	    	case 'hitsunk' :
	    		html += ' - hit and sunk ' + data.shipType + '!!!';
	    	break;
	    	case 'samespot' :
	    		html += ' - hit spot that was hit before - BUUUUU!';
	    	break;
	    } 
	    html += '</li>';
	    $('#log' + id).prepend(html);
	},
	
	displayGame : function (gameId) {
		this.getData(gameId);
		//this.drawBoards();
		
	}
};


$(function(){
	BS.displayGame(1);
	//$('.body').append(BS.drawBoard(1));
	
});
