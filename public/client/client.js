$(function () {
    console.log("Battleship Client")

    var CLIENT = {
        body: $(".body"),
        token: "-orsGMSc789m-Jk_97jivA",
        createGame: function () {
            var that = this;
            console.log("create game");
            $.getJSON("/" + that.token + "/game/new?callback=?", function (response) {
                console.log("success");
                console.log("response=" + response);
                if (typeof response.error !== 'undefined') {
                    console.error(response.error)
                } else {
                    console.log("New Game created ID=" + response.id);
                }
            });
        },
        joinGame: function () {
            console.log("join game");
        },
        playGame: function () {
            console.log("play game");
        },
        listGames: function () {
            var that = this;
            $.getJSON("/" + this.token + "/game/list?callback=?", function (response) {
                if (typeof response.error !== 'undefined') {
                    console.error(response.error)
                } else {
                    console.log("List of available games");
                    that.body.empty();
                    $.each(response, function () {
                        var player1 = this.players[0].name;
                        var player2 = typeof this.players[1] !== 'undefined' ? this.players[1].name : "Waiting ...";
                        that.body.append($("<div class='game'>").append($('<button>', {value: this.id, text: 'Join'}))
                            .append("<p>Players: " + player1 + " vs. " + player2 + "</p>"));
                    });
                }
            });
        },
        bindEvents: function () {
            var that = this;
            $("#menuCreateGame").click(function () {
                that.createGame();
            });
            $("#menuListGames").click(function () {
                that.listGames();
            });
        }
    }
    CLIENT.bindEvents();
});
