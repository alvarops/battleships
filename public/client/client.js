$(function () {
    console.log("Battleship Client")

    var CLIENT = {
        body: $(".body"),
        token: "U4wnEEFMnP5Nfr4cIfM4oA",
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
                        that.body.append($("<div class='game'>").append($('<input>', {value: this.id, type: 'button'})).append("<p>Players: " + this.players + "</p>"));
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
