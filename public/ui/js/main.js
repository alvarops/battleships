$(function(){
    var BS = {
        _fn : {
            ajaxError : function(xhr, status) {
                console.log('Something went wrong: ' + status);
            },

            clearScreen : function (completeCallback) {
                $('.body').fadeOut(function () {
                    $(this).html('');
                    completeCallback();
                    $(this).fadeIn();
                });
            },

            showLoginBox : function () {
                $('.body').load('/ui/dialogs/login.html', function () {
                    $('#show_all_games').click(function () {
                        BS._fn.clearScreen(function () {
                            BS._fn.showAllGames();
                        });
                    });
                });
            },

            renderGameList : function(data) {
                var $gameList = $('<table/>', {class: 'table table-striped table-hover game-list'});
                $gameList.html('<thead><th>Game Id</th><th>Player 1</th><th>Player 2</th><th>Width</th><th>Height</th><th>Options</th></thead>');
                $gameList.append('<tbody>');
                $.each(data, function () {
                    var $game = $('<tr/>', {id: this.id, status: this.status});
                    $game.html('<td>' + this.id + '</td>');
                    $game.append('<td>' + this.players[0].name + '</td>');
                    if (this.players[1]) {
                        $game.append('<td>' + this.players[1].name + '</td>');
                    } else {
                        $game.append('<td> - </td>');
                    }
                    $game.append('<td>' + this.width + '</td>');
                    $game.append('<td>' + this.height + '</td>');
                    $game.append('<td><button type="button" class="show-game-progress btn btn-info btn-xs">Show Game Progress</button></td>');
                    $gameList.append($game);
                });
                $gameList.append('</tbody');
                $('.body').append('<h1>List of all games</h1>');
                $('.body').append($gameList);

                $('.show-game-progress').click(function () {
                    var gameId = $(this).parent().parent().attr("id");
                    BS._fn.clearScreen(function () {
                        BS._fn.showGameProgress(gameId);
                    });
                });
            },

            showAllGames : function () {
                that = this;
                $.ajax('/game/list', {
                    cache: false,
                    success: that.renderGameList,
                    error: that.ajaxError
                });

            },

            showGameProgress : function (gameId) {
                BS._fn.game.displayGame(gameId);
            },

            game : {
                gameId : 0,
                interval : 100,
                currentUser : 0,
                currentShot : 0,
                data :{},	
                getData : function(gameId) {
                    console.log('Getting data');
                    this.gameId = gameId;
                    var that = this;
                    $.ajax({
                        url: '/game/' + gameId + '/stats',
                        cache: false,
                        //type : 'json', 
                        success : function(data) {
                            console.log('HERE');
                            that.data = data;
                            console.log(that.data);
                            that.sizeX = data.width;
                            that.sizeY = data.height;
                            that.numOfFields = that.sizeX * that.sizeY;
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
                    for(i = 0; i < this.data.boards.length; i++){
                        if(typeof(this.data.boards[i].shoots[this.currentShot]) !== 'undefined') {
                            this.shot(this.data.boards[i].id, this.data.boards[i].shoots[this.currentShot], this.currentShot + 1);
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
                    for(i = 0; i < this.data.boards.length; i++){
                        $('.body').append(this.drawBoard(this.data.boards[i].id, this.data.players[i].name));
                    }
                    $('.body').append('<div class="clear"></div>');
                },

                shot : function (id, data, num) {
                    var elem=$('#board' + id + ' tr').eq(data.y).find('td').eq(data.x);
                    var shotStatus = data.result;
                    if ($(elem).find('div.empty').length === 0){
                        shotStatus = 'samespot';
                    }
                    $(elem).html('<div class="ship_' + data.shipId + ' '  + shotStatus + '"></div>');
                    console.log(shotStatus);
                    if (shotStatus === 'sunk') {
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
                }
            }
        },
                
        init : function () {
            this._fn.showLoginBox();
        }
    };

    BS.init();
});

