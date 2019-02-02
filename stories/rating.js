import { storiesOf } from '@storybook/html';
import { html, render } from 'lit-html';

storiesOf('Rating', module)
    .add('Basic', () => {

        const customComp = document.createElement('wf-rating');

        return customComp;
    })
    .add('Managing events', () => {

        const rootElm = document.createDocumentFragment();

        const template = (data) => html`
            <wf-rating></wf-rating>`;

        render(template({ }), rootElm);

        return rootElm;
    });
