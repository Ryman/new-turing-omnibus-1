"use strict";

var DescribedClass = require("../../lib/gameTrees/computerPlayer");
var Board = require("../../lib/gameTrees/board");

describe("ComputerPlayer", function () {
  var subject;

  describe("when the computer plays as X", function () {
    beforeEach(function () {
      subject = new DescribedClass("X");
    });

    it("plays winning moves correctly", function () {
      var result = subject.playTurn(new Board([
        ["X", "O", "X"],
        ["O", "O", "X"],
        ["_", "_", "_"]
      ]));

      expect(result.equal(new Board([
        ["X", "O", "X"],
        ["O", "O", "X"],
        ["_", "_", "X"]
      ]))).toEqual(true);
    });

    it("blocks opponent wins correctly", function () {
      var result = subject.playTurn(new Board([
        ["X", "O", "_"],
        ["_", "O", "_"],
        ["_", "_", "X"]
      ]));

      expect(result.equal(new Board([
        ["X", "O", "_"],
        ["_", "O", "_"],
        ["_", "X", "X"]
      ]))).toEqual(true);
    });
  });
});
