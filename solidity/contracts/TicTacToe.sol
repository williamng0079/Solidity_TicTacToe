//SPDX-License-Identifier: Unlicense
pragma solidity ^0.4.24;

/**
 * @title TicTacToe contract
 **/
contract TicTacToe {
    address[2] public players;

    /**
     turn
     1 - players[0]'s turn
     2 - players[1]'s turn
     */
    uint public turn = 1;

    /**
     status
     0 - ongoing
     1 - players[0] won
     2 - players[1] won
     3 - draw
     */
    uint public status;

    /**
    board status
     0    1    2
     3    4    5
     6    7    8
     */
    uint[9] private board;

    /** 
      * @dev Deploy the contract to create a new game
      * @param opponent The address of player2
      **/
    constructor(address opponent) public {
        require(msg.sender != opponent, "No self play");
        players = [msg.sender, opponent];
    }

    /**
      * @dev Check a, b, c in a line are the same
      * _threeInALine doesn't check if a, b, c are in a line
      * @param a position a
      * @param b position b
      * @param c position c
      **/    
    function _threeInALine(uint a, uint b, uint c) private view returns (bool){
        /*Eliminate the possibilities of equals due to 0s so the actual match in a line can be picked out.*/
        if (a != 0 && a == b && a == c){
            return true;
        }
        else{
            return false;
        }
    }

    /**
     * @dev get the status of the game
     * @param pos the position the player places at
     * @return the status of the game
     */
    function _getStatus(uint pos) private view returns (uint) {
        
        /*Matches all possible win combinations first, then iterate through the board to check any 0s exists to determine if the game is finished or not.*/
        if (_threeInALine(board[0], board[1], board[2]) == true){
            if (board[0] == 1){
              return status = 1;
            }
            else if (board[0] == 2){
              return status = 2;
            }
        }
        else if (_threeInALine(board[3], board[4], board[5]) == true){
            if (board[3] == 1){
              return status = 1;
            }
            else if (board[3] == 2){
              return status = 2;
            }
        }
        else if (_threeInALine(board[6], board[7], board[8]) == true){
            if (board[6] == 1){
              return status = 1;
            }
            else if (board[6] == 2){
              return status = 2;
            }
        }
        else if (_threeInALine(board[0], board[3], board[6]) == true){
            if (board[0] == 1){
              return status = 1;
            }
            else if (board[0] == 2){
              return status = 2;
            }
        }
        else if (_threeInALine(board[1], board[4], board[7]) == true){
            if (board[1] == 1){
              return status = 1;
            }
            else if (board[1] == 2){
              return status = 2;
            }
        }
        else if (_threeInALine(board[2], board[5], board[8]) == true){
            if (board[2] == 1){
              return status = 1;
            }
            else if (board[2] == 2){
              return status = 2;
            }
        }
        else if (_threeInALine(board[0], board[4], board[8]) == true){
            if (board[0] == 1){
              return status = 1;
            }
            else if (board[0] == 2){
              return status = 2;
            }
        }
        else if (_threeInALine(board[2], board[4], board[6]) == true){
            if (board[2] == 1){
              return status = 1;
            }
            else if (board[2] == 2){
              return status = 2;
            }
        }
        else{
            for (uint i = 0; i < 9; i++){
              if (board[i] == 0){
                return status = 0;
              }
            }
            return status = 3;
        }
    }

    /**
     * @dev ensure the game is still ongoing before a player moving
     * update the status of the game after a player moving
     * @param pos the position the player places at
     */
    modifier _checkStatus(uint pos) {
        /*Use the wildcard _; to execute the second half of the modifier to update the game status.*/
        require(_getStatus(pos) == 0);
        _;
        _getStatus(pos);
    }

    /**
     * @dev check if it's msg.sender's turn
     * @return true if it's msg.sender's turn otherwise false
     */
    function myTurn() public view returns (bool) {
       /*Simple check with the turn id to match with the msg.sender.*/
       if (players[turn - 1] == msg.sender){
        return true;
       }
       else{
        return false;
       }

    }

    /**
     * @dev ensure it's a msg.sender's turn
     * update the turn after a move
     */
    modifier _myTurn() {
      /*First check for myTurn prerequisite then updates the turn id after the function executes.*/
      require(myTurn() == true);
      _;
      if (turn == 1){
        turn = 2;
      }
      else if (turn == 2){
        turn = 1;
      }
    }

    /**
     * @dev check a move is valid
     * @param pos the position the player places at
     * @return true if valid otherwise false
     */
    function validMove(uint pos) public view returns (bool) {
      /*Valid moves are represented by the player choice being inside the 0-8 array and board being empty (0) before the player can put their value in.*/
      if (pos < 9 && board[pos] == 0){
          return true;
      }
      else{
          return false;
      }
    }

    /**
     * @dev ensure a move is valid
     * @param pos the position the player places at
     */
    modifier _validMove(uint pos) {
      /*Checks for the valieMove prerequisite before executing the move function.*/
      require(validMove(pos) == true);
      _;
    }

    /**
     * @dev a player makes a move
     * @param pos the position the player places at
     */
    function move(uint pos) public _validMove(pos) _checkStatus(pos) _myTurn {
        board[pos] = turn;
    }

    /**
     * @dev show the current board
     * @return board
     */
    function showBoard() public view returns (uint[9]) {
      return board;
    }
}