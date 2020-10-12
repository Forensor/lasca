/**
 * Returns an element from a list
 * 
 * @param {string}      x First element of the list
 * @param {string[]}   xs Rest of the list
 * @param {number} pos Position to return
 * 
 * @returns {string}
 */
const find = ([x, ...xs], pos) => 
    pos === 0 ? x
  : find(xs, pos - 1)
/**
 * Replaces an element from a list
 * 
 * @param {string}      x First element of the list
 * @param {string[]}   xs Rest of the list
 * @param {number} pos The position of the list that's going to be replaced
 * @param {string}    rep The replacement
 * 
 * @returns {string[]}
 */
const replace = ([x, ...xs], pos, rep) => 
    pos === 0 ? [rep].concat(xs)
  : [x].concat(replace(xs, pos - 1, rep))
/**
 * Returns the found element in a 2D list
 * 
 * @param {string[][]} arr 2D array filled with strings
 * @param {number}  row Desired row to work with
 * @param {number}  col Desired column
 * 
 * @returns {string}
 */
const find2D = (arr, row, col) => 
  find(find(arr, row), col)
/**
 * Replaces an element in a 2D list
 * 
 * @param {string[][]} arr 2D array to be replaced
 * @param {number}  row Row to replace
 * @param {number}  col Column to replace
 * @param {string}     rep Replacement
 * 
 * @returns {string[][]}
 */
const replace2D = (arr, row, col, rep) => 
  replace(arr, row, replace(find(arr, row), col, rep))
/**
 * Returns the specified string index inside a list
 * 
 * @param {string[][]} arr 2D array filled with strings
 * @param {number}       row Row
 * @param {number}       col Column
 * @param {number}       pos Index of the string
 * 
 * @returns {string}
 */
const find3D = (arr, row, col, pos) => 
  find(find2D(arr, row, col), pos)
/**
 * Returns a new list with a '' in its original place and the
 * old element being in the destination
 * 
 * @param {string[][]} arr 2D array to modify
 * @param {number}   oR Origin row
 * @param {number}   oC Origin column
 * @param {number}   dR Destination row
 * @param {number}   dC Destination column
 * 
 * @returns {string[][]}
 */
const move = (arr, oR, oC, dR, dC) => 
  replace2D(replace2D(arr, dR, dC, find2D(arr, oR, oC)), oR, oC, '')
/**
 * Adds the top piece on the specified place to the piece that captures
 * 
 * @param {string[][]} arr Board
 * @param {number} oR Row in which captured piece is located
 * @param {number} oC Col in which captured piece is located
 * @param {number} dR Row of capturing piece
 * @param {number} dC Col of capturing piece
 * 
 * @returns {string[][]}
 */
const addTopPieceToPile = (arr, oR, oC, dR, dC) => 
  replace2D(
    arr, 
    dR, 
    dC, 
    find2D(arr, dR, dC).concat(find3D(arr, oR, oC, 0))
  )
