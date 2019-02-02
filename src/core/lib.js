
// Important factor to keep in mind
// https://stackoverflow.com/questions/43836886/failed-to-construct-customelement-error-when-javascript-file-is-placed-in-head
export function define(componentName, mainFn, props = [], style, send) {

    // Private fields
    const domInitialized = Symbol();
    const teaInstance = Symbol();
    const propsToObserve = props.map((name) => [name, Symbol()]);

    const componentClass = class extends HTMLElement {

        constructor() {

            // As web component says
            super();

            // Only for debugging purpose
            // console.log(componentName);

            this[domInitialized] = false;

            // Attach a shadow root to the element.
            this.attachShadow({ mode: 'open' });

            // Defined required getter and setters
            propsToObserve.forEach(([name, symbol]) =>
                Object.defineProperty(this, name, {
                    get() {
                        return this[symbol];
                    },
                    set(value) {
                        this[symbol] = value;

                        // Do some work here
                        this[teaInstance].pushMsg(send(value));
                    }
                }));
        }

        connectedCallback() {
            if (!this[domInitialized]) {

                // Trust simple dumb JS Closures
                const dispatcher = {
                    trigger: (name) => {
                        // this here refers to the Custom Element
                        this.dispatchEvent(new CustomEvent(name));
                    }
                };

                // Add stylesheet
                // this.shadowRoot.innerHTML = `<style>\n${style}\n</style>`;

                // Initiate TEA event loop
                this[teaInstance] = mainFn(this.shadowRoot, null, dispatcher);

                const styleElm = document.createElement('style');
                styleElm.innerHTML = style;

                // Append actual TEA component
                this.shadowRoot.append(styleElm);

                // DOM is now initialized
                this[domInitialized] = true;
            }
        }

        disconnectedCallback() {
            this[teaInstance].shutdown();
        }
    };

    customElements.define(componentName, componentClass);
}