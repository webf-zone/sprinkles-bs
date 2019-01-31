// import resolve from 'rollup-plugin-node-resolve';

export default {
    input: 'src/main.js',
    output: {
        file: 'dist/bundle.js',
        format: 'esm',
        sourcemap: true
    }
    // plugins: [ resolve() ]
};
