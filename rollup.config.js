import resolve from 'rollup-plugin-node-resolve';
import postcss from 'rollup-plugin-postcss';
import { uglify } from "rollup-plugin-uglify";

const prod = process.env.hasOwnProperty('PROD');

const baseConfig = {
    input: 'src/main.js',
    output: {
        file: 'dist/bundle.js',
        format: 'esm'
        // sourcemap: true
    },

    plugins: [
        postcss({
            inject: false,
            config: {
                path: 'postcss.config.js'
            }
        })
    ]

};

const devConfig = {
    ...baseConfig,

    watch: {
        exclude: 'node_modules/**'
    },

    external: (id) => {

        const modules = [
            '@polymer/iron-icon',
            '@polymer/iron-icons',
            'bs-platform',
            'bucklescript-tea',
            'popper.js',
            'rxjs'
        ];

        return modules.some((x) => id.startsWith(x));
    }

};

const prodConfig = {
    ...baseConfig,

    plugins: [
        ...baseConfig.plugins,
        // resolve(),
        // uglify(),
    ]
};

const config = prod ? prodConfig : devConfig;

export default config;
