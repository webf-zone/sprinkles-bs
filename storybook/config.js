// Import entire library
import '../dist/bundle';

import { withNotes } from '@storybook/addon-notes';
import { addDecorator, configure } from '@storybook/html';

// withNotes
addDecorator(withNotes);


function loadStories() {
    require('../src/counter/counterStory');
    require('../src/range/ratingStory');

    // You can require as many stories as you need.
}

configure(loadStories, module);