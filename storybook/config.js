// Import entire library
import '../dist/bundle';

// Example CSS - Only for illustration. Not part of the framework
import './examples.css';

import { withNotes } from '@storybook/addon-notes';
import { addDecorator, configure } from '@storybook/html';

// withNotes
addDecorator(withNotes);


function loadStories() {
    require('../src/counter/counterStory');
    require('../src/popper/popperStory');
    require('../src/range/ratingStory');

    // You can require as many stories as you need.
}

configure(loadStories, module);