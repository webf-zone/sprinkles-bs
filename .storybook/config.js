// Import entire library
import '@polymer/iron-icon/iron-icon.js';
import '@polymer/iron-icons/iron-icons.js';

import '../dist/bundle.js';

import { configure } from '@storybook/html';


function loadStories() {
    require('../stories/counter.js');
    require('../stories/rating.js');

    // You can require as many stories as you need.
}

configure(loadStories, module);