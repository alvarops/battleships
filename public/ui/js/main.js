$(function(){
    var BS = {
        _vars: {
            testToken : 'EScmhnrLvKFZz4Lu0Gb5eA'}
        ,

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

            showInitBox : function () {
                $('.body').load('/ui/dialogs/login.html', function () {
                    $('#show_all_games').click(function () {
                        BS._fn.clearScreen(function () {
                            BS._fn.showAllGames();
                        });
                    });
                    $('#create_test_game').click(function () {
                        BS._fn.clearScreen(function () {
                            BS._fn.createTestGame();
                        });
                    });
                });
            },

            createTestGame : function () {
                $.ajax('/' + BS._vars.testToken + '/game/new', {
//                $.ajax('/' + BS._vars.testToken + '/game/39/stats', {
                    cache: false,
                    success: function (data) {
                        if (data.error) {
                            alert('Error: ' + data.error[0]);
                        } else {
                            BS._fn.arrangeTestGame(data);
                        }
                    },
                    error: BS._fn.ajaxError

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
                $.ajax('/game/listforpreview', {
                    cache: false,
                    success: that.renderGameList,
                    error: BS._fn.ajaxError
                });

            },

            showGameProgress : function (gameId) {
                BS._fn.game.displayGame(gameId);
            },

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

            arrangeTestGame : function(data) {
                var gameId = data.id;
                var $shipTemplate = $('<ul/>').addClass('ship');
                for (var y = 0; y < 8; y++) {
                    for (var x = 0; x < 8; x++) {
                        $('<li/>', {x: x, y: y}).addClass(x.toString() + '-' + y.toString()).appendTo($shipTemplate);
                    }
                }
                $.ajax({
                    url: '/ship/list',
                    cache: false,
                    async: false,
                    success : function(data) {
                        $('.body').append('<h1>Game Id: ' + gameId + '</h1>');
                        $('.body').append('<button id="show_shoots" type="button" class="btn btn-primary">Show opponent shoots</button>');
                        $('.body').append('<button id="randomize_ships" type="button" class="btn btn-primary">Randomize ships</button>');
                        $('.body').append('<button id="reset_game" type="button" class="btn btn-primary">Reset this game</button>');
                        $('.body').append($('<div/>', {class: 'available-ships'}));
                        $('#show_shoots').click(function () {
                            BS._fn.showOpponentShoots(gameId);   
                        });
                        $('#randomize_ships').click(function () {
                            console.log('Randomizing ships placement');
                            $.ajax({
                                url: '/' + BS._vars.testToken + '/game/' + gameId + '/randomize',
                                cache: false,
                                success: function (data) {
                                    $('.board li').removeClass('position');
                                    BS._fn.showShipPlacement(gameId);
                                },
                                error: BS._fn.ajaxError
                            });
                        });
                        $('#reset_game').click(function () {
                            $.ajax({
                                url: '/' + BS._vars.testToken + '/game/' + gameId + '/restart',
                                cache: false,
                                success: function (data) {
                                    BS._fn.showShipPlacement(gameId);
                                },
                                error: BS._fn.ajaxError
                            });
                        });
                        $.each(data, function (index, value) {
                           var type = index;
                           $.each(value, function(index, value) {
                               var variant = index; 
                               var $ship = $shipTemplate.clone();
                               $ship.attr('type', type);
                               $ship.attr('variant', variant);
                               $.each(value, function (index, value) {
                                   $ship.find('.' + value.x + '-' + value.y).addClass('shape');
                               });
                               $('.available-ships').append($ship);
                           });
                        });
                        $('.available-ships .ship').dragdrop({
                            clone: true,
                            dragClass: 'dragging',
                            canDrop : BS._fn.canDrop,
                            didDrop : function(src, dst) {
                                var dstx = parseInt(dst.attr('x')),
                                    dsty = parseInt(dst.attr('y')),
                                    type = src.attr('type'),
                                    variant = src.attr('variant');
                                console.log('Dropped ' + type + ' variant ' + variant + ', x=' + dstx + ', y=' + dsty);
                                console.log(this);
                                $.ajax({
                                    url: '/' + BS._vars.testToken + '/game/' + gameId  + '/set?ships[][type]=' + type + '&ships[][variant]=' + variant + '&ships[][xy][]=' + dstx + '&ships[][xy][]=' + dsty,
                                    cache: false,
                                    success : function(data) {
                                        if (data && data.status) {
                                            $('.board .decision').addClass('position').removeClass('decision');
                                            console.log('Succesfull placement');
                                            $('.available-ships .ship[type="' + type + '"]').hide();
                                        } else {
                                            $('.board .decision, .board .impossible').removeClass('decision impossible');
                                            console.log('Placement not possible');
                                        }

                                    }
                                });
                            }
                        });
                    },
                    error: BS._fn.ajaxError
                });

                BS._fn.game.sizeX = data.width;
                BS._fn.game.sizeY = data.height;
                $('.body').append(BS._fn.game.drawBoard(0, 'Test Player'));
                BS._fn.events.attachResizeEvents();

            },

            showShipPlacement : function(gameId) {
                console.log('Drawing ships placement');
                $('.board li').removeClass('position');
                $.ajax({
                    url: '/' + BS._vars.testToken + '/game/' + gameId + '/show.json',
                    cache: false,
                    //type : 'json', 
                    success : function(positionsData) {
                        $.each(positionsData, function () {
                            $('.board li.' + this.x + '-' + this.y).addClass('position'); 
                        });
                    }
                });

            },

            showOpponentShoots : function(gameId) {
                $.ajax({
                    url: '/' + BS._vars.testToken + '/game/' + gameId + '/stats',
                    cache: false,
                    success : function(shootsData) {
                        if (shootsData.players.length === 1) {
                            alert('There\'s no opponent in this game');
                        } else {
                            BS._fn.game.data = shootsData;
                            BS._fn.game.gameId = gameId;
                            BS._fn.game.interval = 100;
                            BS._fn.game.currentUser = 0;
                            BS._fn.game.currentShot = 0;
                            BS._fn.game.numOfFields = shootsData.width * shootsData.height;
                            BS._fn.game.data.boards.splice(1,1);
                            BS._fn.game.data.boards[0].id = 0;
                            BS._fn.game.showNextShot();
                            
                        }

                    },
                    error: BS._fn.ajaxError
                });
            },

            events : {
                attachResizeEvents : function () {
                    $(document).off('click', '.playerContainer .badge').on('click', '.playerContainer .badge', function () {
                        var $board = $('ul.board'),
                            boardWidth = parseInt($board.attr('width')),
                            currentLiWidth = parseInt($board.find('li').first().css('width').slice(0,-2));
                        if ($(this).hasClass('smaller')) {
                            if (currentLiWidth < 10) {
                                console.log('The board piece cannot be smaller');
                            } else {
                                $board.find('li').css({width: (currentLiWidth - 5) + 'px', height: (currentLiWidth - 5) + 'px'});
                                $board.css('width', ((currentLiWidth - 5) * boardWidth + 1) + 'px');
                            }
                        } else {
                            console.log('Bigger');
                            $board.find('li').css({width: (currentLiWidth + 5) + 'px', height: (currentLiWidth + 5) + 'px'});
                            $board.css('width', ((currentLiWidth + 5) * boardWidth + 1) + 'px');
                        }
                    });
                }
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
                        error: BS._fn.ajaxError
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
                    var h = '<div class="playerContainer" id="container' + id + '"><span class="player-name">' + name + '</span><span class="badge bigger"><i class="glyphicon-plus"></i></span>/<span class="badge smaller"><i class="glyphicon-minus"></i></span><ul width="' + this.sizeX + '" style="width: ' + ((this.sizeX * 5) + 1) + 'px;" class="board" id="board' + id + '">';
                    for(i = 0; i < this.sizeY; i++){
                        //h += '<tr>';
                        for(j = 0; j < this.sizeX; j++){
                            h += '<li class="' + j + '-' + i + '" x="' + j + '" y="' + i + '"><div class="empty"></div></li>';
                        }
                        //h += '</tr>';
                    }
                    h += '</ul><div class="log"><h3>Game log</h3><ul id="log' + id + '"></ul></div></div>';
                    return h;
                },

                drawBoards : function () {
                    var i = 0;
                    for(i = 0; i < this.data.boards.length; i++){
                        $('.body').append(this.drawBoard(this.data.boards[i].id, this.data.players[i].name));
                    }
                    $('.body').append('<div class="clear"></div>');
                    BS._fn.events.attachResizeEvents();
                },

                shot : function (id, data, num) {
                    var elem=$('#board' + id + ' li.' + data.x + '-' + data.y);
                    var shotStatus = data.result;
                    if ($(elem).find('div.empty').length === 0){
                        shotStatus = 'samespot';
                    }
                    $(elem).addClass(shotStatus); //html('<div class="ship_' + data.shipId + ' '  + shotStatus + '"></div>');
                    console.log(shotStatus);
                    if (shotStatus === 'sunk') {
                        console.log(shotStatus);
                        $('#board' + id +' .ship_' + data.shipId).removeClass('hit').addClass('hitsunk');
                    }
                    
                    //Ad log
//                    var html ='<li class="shotStatus ' + shotStatus + '">Shot ' + num + ' - x:' + data.x + ' y:' + data.y;
//                    switch(shotStatus){
//                        case 'miss' :
//                            html += ' - miss';
//                        break;
//                        case 'hit' :
//                            html += ' - hit ' + data.shipType + '!';
//                        break;
//                        case 'hitsunk' :
//                            html += ' - hit and sunk ' + data.shipType + '!!!';
//                        break;
//                        case 'samespot' :
//                            html += ' - hit spot that was hit before - BUUUUU!';
//                        break;
//                    } 
//                    html += '</li>';
//                    $('#log' + id).prepend(html);
                },

                displayGame : function (gameId) {
                    this.getData(gameId);
                }
            }
        },
                
        init : function () {
            this._fn.showInitBox();
        }
    };

    BS.init();
});

