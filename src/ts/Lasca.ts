class Lasca {
    public static preferences = {
        board: 'classic',
        piece: 'classic'
    };
    /**
     * Returns the specified element
     * @param element The element identifier
     */
    public static $(element: string): HTMLElement {
        return document.getElementById(element);
    }
}