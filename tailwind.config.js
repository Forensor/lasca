/** @type {import('tailwindcss').Config} */
module.exports = {
    content: ["./index.html", "./src/**/*.{js,ts,elm}"],
    theme: {
        extend: {
            fontFamily: {
                raleway: ["Raleway", "sans-serif"]
            },
            colors: {
                "columbia-blue": "#cee5f2",
                "dark-electric-blue": "#637081",
                "cerulean-frost": "#7c98b3"
            }
        }
    },
    plugins: []
}
