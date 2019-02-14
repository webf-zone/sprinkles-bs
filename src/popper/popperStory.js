import { storiesOf } from '@storybook/html';
import { html, render } from 'lit-html';

// import notes from './Rating.md';

storiesOf('Popper', module)
    // .addParameters({
    //     notes: { markdown: notes }
    // })
    .add('Basic implementation', () => {

        const rootElm = document.createDocumentFragment();
        let popper;

        // Event handlers
        const open = (ev) => {

            popper = document.querySelector('[wf-popper-id="popper1"]');
            const button = ev.target;

            popper.anchorElm = button;
            popper.open = true;
        };

        const close = () => {
            if (popper) {
                popper.open = false;
            }
        };

        const template = () => html`
            <div class="popper-story">
                <button @click="${open}">Open popper</button>
                <button @click="${close}">Close popper</button>
            </div>
            <wf-popper wf-popper-id="popper1">
                <p>Some content that belong to the popup</p>
            </wf-popper>`;

        render(template({ }), rootElm);

        return rootElm;
    });
