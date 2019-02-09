import { define } from './core/lib.js';

import { main as counterMain, set } from './counter/Counter.bs.js';

// Rating component
import { main as ratingMain , ratingProps } from './range/Rating.bs.js';
import ratingStyle from './range/Rating.css';

// All component definitions

// Define counter component
define('wf-counter', counterMain, ['count'], '', set);

// Define rating component
define('wf-rating', ratingMain, ratingProps, ratingStyle);
