
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

// Example: finding an element in a 2D array: find(find([x, ...xs], pos), pos)

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

// Example: replacing an element in a 2D array: 
// replace(
//   [x, ...xs], 
//   pos, 
//   replace(find([x, ...xs], pos), pos, rep)
// )
