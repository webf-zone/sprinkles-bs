import { define } from './core/lib.js';
import { main as counterMain, set } from './counter/Counter.bs.js';
import { main as ratingMain } from './range/Rating.bs.js';

import ratingStyle from './range/Rating.css';

// Define counter component
define('wf-counter', counterMain, ['count'], '', set);

// Define rating component
define('wf-rating', ratingMain, ['value'], ratingStyle);
