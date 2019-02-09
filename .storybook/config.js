// Import required dependencies
// No dependencies currently
// import '@polymer/iron-icon/iron-icon.js';
// import '@polymer/iron-icons/iron-icons.js';

// Import entire library
import '../dist/bundle.js';

import { configure } from '@storybook/html';


function loadStories() {
    require('../stories/counter.js');
    require('../stories/ratingStory.js');

    // You can require as many stories as you need.
}

configure(loadStories, module);