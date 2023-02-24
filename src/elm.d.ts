declare module "*.elm" {
    const Elm: {
        [moduleName: string]: {
            init(options: { node: HTMLElement | null; flags?: object }): ElmApp
        }
    }
    interface ElmApp {
        ports: {
            [portName: string]: {
                subscribe(callback: (value: any) => void): void
                send(value: any): void
            }
        }
    }
}
