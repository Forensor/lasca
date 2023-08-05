import { Elm } from "./Main.elm"
import "./index.css"

const app = Elm.Main.init({
    node: document.querySelector("#app")
})

app.ports.play.subscribe((soundFilename: string) => {
    new Audio(soundFilename).play()
})
