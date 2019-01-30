// Import entire library
import '../dist/bundle.js';

import { configure } from '@storybook/html';


function loadStories() {
    require('../stories/counter.js');

    // You can require as many stories as you need.
}

configure(loadStories, module);