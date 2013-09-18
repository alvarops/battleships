$(function () {
    console.log("Battleship Client")

    var CLIENT = {
        token: "U4wnEEFMnP5Nfr4cIfM4oA",
        createGame: function () {
            var that = this;
            console.log("create game");
            that.issueRequest("/" + that.token + "/game/new");
        },
        joinGame: function () {
            console.log("join game");
        },
        playGame: function () {
            console.log("play game");
        },
        bindEvents: function () {
            var that = this;
            $("#menuCreateGame").click(function () {
                that.createGame();
            });
        },
        issueRequest: function (url) {
            var jqxhr = $.getJSON(url+ "?callback=?", function (response) {
                console.log("success");
                console.log("response=" + response);
            });

        }
    }
    CLIENT.bindEvents();
});
