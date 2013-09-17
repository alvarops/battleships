var BS = {
    replay : {
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
                url: 'call.json?gameId=' + gameId,
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
        }
    },

    arrange : {
        drawBoard : function(sizeX, sizeY) {
            $board = $('<ul/>');
            $board.css({width: (sizeX * 11) + 'px', height: (sizeY * 11) + 'px'});
            for (var y = 0; y < sizeY; y++) {
                for (var x = 0; x < sizeX; x++) {
                    $('<li/>', {x: x, y: y}).addClass(x.toString() + '-' + y.toString()).appendTo($board);
                }
            }
            $('.board').append($board);
        }
    },
	
	displayGame : function (gameId) {
		this.getData(gameId);
		//this.drawBoards();
		
	},

    showPage : function (nameOfPage) {
        $('.body').load('/ui/pages/' + nameOfPage + '.html', function(response, status) {
            if (status === 'error') {
                console.log('Page ' + nameOfPage + ' does not exist');
            } else {
                if ($.isFunction(BS._pageInitializers[nameOfPage])) {
                    BS._pageInitializers[nameOfPage].call(BS);
                }
            }
        });
    },

    _pageInitializers : {
        userZone : function() {
            var $shipTemplate = $('<ul/>').addClass('ship');
            for (var y = 0; y < 8; y++) {
                for (var x = 0; x < 8; x++) {
                    $('<li/>', {x: x, y: y}).addClass(x.toString() + '-' + y.toString()).appendTo($shipTemplate);
                }
            }
            this.arrange.drawBoard(30, 30);
            $.ajax({
                url: '/ship/list',
                cache: false,
                success : function(data) {
                    $.each(data, function (index, value) {
                       $.each(value, function(index, value) {
                           var $ship = $shipTemplate.clone();
                           $.each(value, function (index, value) {
                               $ship.find('.' + value.x + '-' + value.y).addClass('shape');
                           });
                           var size = 
                           $('.available-ships').append($ship);
                       });
                    });
                    $('.available-ships .ship').dragdrop({
                        dragClass: 'dragging',
                        canDrop : function(dst, src) {
                            $('.board .decision, .board .impossible').removeClass('decision impossible');
                            var dstx, dsty, impossible = false;
                            if (dst.is('.board li')) {
                                dstx = parseInt(dst.attr('x'));
                                dsty = parseInt(dst.attr('y'));
                                src.find('li.shape').each(function () {
                                    var $field = $('.board .' + (parseInt($(this).attr('x')) + dstx) + '-' + (parseInt($(this).attr('y')) + dsty));
                                    if ($field.length > 0) {
                                        $field.addClass('decision'); 
                                    } else {
                                        impossible = true;
                                    }
                                });
                                if (impossible) {
                                    $('.board .decision').addClass('impossible');
                                } else {
                                    return true;
                                }
                            } 
                            return false;
                        },
                        didDrop : function(src, dst) {
                            $('.board .decision').addClass('position');
                            $('.board .decision, .board .impossible').removeClass('decision impossible');
                        }
                    });
                },
                error : function (a,b,c) {
                    console.log(a);
                    console.log(b);
                    console.log(c);
                }
            });
        }
    }
};


$(function(){
	//BS.displayGame(1);
	//$('.body').append(BS.drawBoard(1));

    $('.menu li a').click(function () {
        var menuCommand = $(this).attr('rel');
        BS.showPage(menuCommand);
    });

    BS.showPage("userZone");

	
});
