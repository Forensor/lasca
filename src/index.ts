import { Elm } from "./Main.elm"
import "./index.css"

const app = Elm.Main.init({
    node: document.querySelector("#app")
})

app.ports.play.subscribe((soundFilename: string) => {
    const audio = new Audio(soundFilename)
    audio.play()
})
