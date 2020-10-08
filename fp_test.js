/**
 * Returns an element from a list
 * 
 * @param {any}      x First element of the list
 * @param {any[]}   xs Rest of the list
 * @param {number} pos Position to return
 * 
 * @returns {any}
 */
const find = ([x, ...xs], pos) => 
    pos === 0 ? x
  : find(xs, pos - 1)
/**
 * Replaces an element from a list
 * 
 * @param {any}      x First element of the list
 * @param {any[]}   xs Rest of the list
 * @param {number} pos The position of the list that's going to be replaced
 * @param {any}    rep The replacement
 * 
 * @returns {any[]}
 */
const replace = ([x, ...xs], pos, rep) => 
    pos === 0 ? [rep].concat(xs)
  : [x].concat(replace(xs, pos - 1, rep))
/**
 * Returns the found element in a 2D list
 * 
 * @param {any[][]} arr 2D array filled with elements
 * @param {number}  row Desired row to work with
 * @param {number}  col Desired column
 * 
 * @returns {any}
 */
const find2D = (arr, row, col) => 
  find(find(arr, row), col)
/**
 * Replaces an element in a 2D list
 * 
 * @param {any[][]} arr 2D array to be replaced
 * @param {number}  row Row to replace
 * @param {number}  col Column to replace
 * @param {any}     rep Replacement
 * 
 * @returns {any[][]}
 */
const replace2D = (arr, row, col, rep) => 
  replace(arr, row, replace(find(arr, row), col, rep))
/**
 * Returns the specified string index inside a list
 * 
 * @param {string[][][]} arr 2D array filled with strings
 * @param {number}       row Row
 * @param {number}       col Column
 * @param {number}       pos Index of the string
 * 
 * @returns
 */
const find3D = (arr, row, col, pos) => 
  find(find2D(arr, row, col), pos)
/**
 * Returns a new list with a '' in its original place and the
 * old element being in the destination
 * 
 * @param {any[][]} arr 2D array to modify
 * @param {number}   oR Origin row
 * @param {number}   oC Origin column
 * @param {number}   dR Destination row
 * @param {number}   dC Destination column
 * 
 * @returns {any[][]}
 */
const move = (arr, oR, oC, dR, dC) => 
  replace2D(replace2D(arr, dR, dC, find2D(arr, oR, oC)), oR, oC, '')
