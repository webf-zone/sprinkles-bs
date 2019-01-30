import { storiesOf } from '@storybook/html';
import { html, render } from 'lit-html';

storiesOf('Counter', module)
    .add('Basic counter', () => {
        const customComp = document.createElement('wf-counter');

        return customComp;
    })
    .add('Increment and decrement event', () => {

        const rootElm = document.createDocumentFragment();

        // Event handlers
        const increment = () => render(template({ event: 'increment' }), rootElm);
        const decrement = () => render(template({ event: 'decrement' }), rootElm);

        const template = (data) => html`
            <div>
                <wf-counter @increment=${increment} @decrement=${decrement}></wf-counter>
                <p>Event: ${data.event}</p>
            </div>`;

        render(template({ event: 'N/A' }), rootElm);

        return rootElm;
    });
