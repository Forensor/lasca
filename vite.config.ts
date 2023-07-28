import { defineConfig } from "vite"
import { plugin as elm } from "vite-plugin-elm"

export default defineConfig({
    plugins: [elm({})],
    root: "src/",
    publicDir: "../res/"
})
