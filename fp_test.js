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
 * @param {number} row Desired row to work with
 * @param {number} col Desired column
 * 
 * @returns {any}
 */
const find2D = (arr, row, col) => 
  find(find(arr, row), col)
/**
 * Replaces an element in a 2D list
 * 
 * @param {any[][]} arr 2D array to be replaced
 * @param {number} row Row to replace
 * @param {number} col Column to replace
 * @param {any} rep Replacement
 */
const replace2D = (arr, row, col, rep) => 
  replace(arr, row, replace(find(arr, row), col, rep))
