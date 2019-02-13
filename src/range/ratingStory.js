import { storiesOf } from '@storybook/html';
import { html, render } from 'lit-html';

import notes from './Rating.md';

storiesOf('Rating', module)
    .addParameters({
        notes: { markdown: notes }
    })
    .add('Basic change event', () => {

        const customComp = document.createElement('wf-rating');

        customComp.value = 3.2;
        customComp.max = 12;
        customComp.disabled = false;

        customComp.addEventListener('change', (ev) => customComp.value = ev.detail);

        return customComp;
    })
    .add('Default - disabled', () => {

        const customComp = document.createElement('wf-rating');

        customComp.value = 1.2;

        customComp.addEventListener('change', (ev) => customComp.value = ev.detail);

        return customComp;
    })
    .add('Disabled ', () => {

        const rootElm = document.createDocumentFragment();

        const template = (data) => html`
            <wf-rating></wf-rating>`;

        render(template({ }), rootElm);

        return rootElm;
    });
