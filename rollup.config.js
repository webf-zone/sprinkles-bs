import resolve from 'rollup-plugin-node-resolve';
import postcss from 'rollup-plugin-postcss';

export default {
    input: 'src/main.js',
    output: {
        file: 'dist/bundle.js',
        format: 'esm'
        // sourcemap: true
    },
    watch: {
        exclude: 'node_modules/**'
    },
    external: (id) => {

        const modules = [
            'bs-platform',
            'bucklescript-tea',
            '@polymer/iron-icon',
            '@polymer/iron-icons'
        ];

        return modules.some((x) => id.startsWith(x));
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
