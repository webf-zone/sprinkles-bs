import { Subject } from 'rxjs';
import { filter, map } from 'rxjs/operators';

// Important factor to keep in mind
// https://stackoverflow.com/questions/43836886/failed-to-construct-customelement-error-when-javascript-file-is-placed-in-head
export function define(componentName, mainFn, props = [], style) {

    // Private field - keeps track of loop initialization
    const domInitialized = Symbol();
    const bus = Symbol();

    // Actual TEA instance
    const teaInstance = Symbol();

    // Create a symbol for each prop for data hiding
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

            // Bus of prop change events Observable<[propName, propValue]>
            this[bus] = new Subject();

            // Defined required getter and setters
            propsToObserve.forEach(([name, symbol]) =>
                Object.defineProperty(this, name, {
                    get() {
                        return this[symbol];
                    },
                    set(value) {
                        this[symbol] = value;

                        // Push the value
                        this[bus].next([name, value]);
                    }
                }));
        }

        connectedCallback() {
            if (!this[domInitialized]) {

                // Trust simple dumb JS Closures
                const jsContext = {

                    attr: (name, value) => {
                        this.setAttribute(name, value);
                    },

                    removeAttr: (name) => {
                        this.removeAttribute(name);
                    },

                    trigger: (eventName, eventValue) => {
                        const event = new CustomEvent(eventName, { detail: eventValue });
                        // this here refers to the Custom Element
                        this.dispatchEvent(event);
                    },

                    subscribe: (propName, callback) => {

                        const stream = this[bus];

                        return stream.pipe(
                            filter((x) => x[0] === propName),
                            map((x) => x[1])
                        ).subscribe(callback);
                    }
                };

                // Create an object that represents initial state of the component
                // Ideally this should be decoded by the component
                const flags = propsToObserve.reduce((acc, [name, symbol]) => {
                    acc[name] = this[symbol];
                    return acc;
                }, {});

                // Initiate TEA event loop
                this[teaInstance] = mainFn(this.shadowRoot, flags, jsContext);

                // Add stylesheet
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