import { storiesOf } from '@storybook/html';
import { html, render } from 'lit-html';

storiesOf('Rating', module)
    .add('Basic change event', () => {

        const customComp = document.createElement('wf-rating');

        customComp.value = 3.2;
        customComp.max = 12;
        customComp.disabled = true;

        customComp.addEventListener('change', (ev) => customComp.value = ev.detail);

        return customComp;
    })
    .add('Managing events', () => {

        const rootElm = document.createDocumentFragment();

        const template = (data) => html`
            <wf-rating></wf-rating>`;

        render(template({ }), rootElm);

        return rootElm;
    });
