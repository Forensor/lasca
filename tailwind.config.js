/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./index.html", "./src/**/*.{js,ts,elm}"],
    theme: {
        extend: {
            colors: {
                jet: "#363636",
                gunmetal: "#242f40",
                "satin-sheen-gold": "#cca43b",
                platinum: "#e5e5e5",
                white: "#ffffff"
            },
            backgroundImage: {
                board: "url('./board.svg')"
            }
        }
    },
    plugins: []
}
