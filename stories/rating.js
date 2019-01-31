import { storiesOf } from '@storybook/html';
import { html, render } from 'lit-html';

storiesOf('Rating', module)
    .add('Basic', () => {

        const customComp = document.createElement('wf-rating');
        // customComp = 10;

        const customComp2 = document.createElement('div');

        customComp2.innerHTML = '';

        return customComp;
    });
