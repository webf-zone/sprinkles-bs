import { define } from './core/lib';

import { main as counterMain } from './counter/Counter.bs';

// Rating component
import { main as ratingMain , ratingProps } from './range/Rating.bs';
import ratingStyle from './range/Rating.css';

// Popper component
import { main as popperMain, popperProps } from './popper/Popper.bs';

// All component definitions

// Define counter component
define('wf-counter', counterMain, ['count'], '');

// Define rating component
define('wf-rating', ratingMain, ratingProps, ratingStyle);

define('wf-popper', popperMain, popperProps, '');
