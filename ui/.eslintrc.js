module.exports = {
  extends: ['@tloncorp/eslint-config', 'plugin:storybook/recommended'],
  overrides: [{
    files: ['**/*.ts', '**/*.tsx'],
    parserOptions: {
      project: 'tsconfig.json',
      tsconfigRootDir: __dirname
    }
  }],
  rules: {
    semi: [2, 'always'],
    'react/jsx-filename-extension': [1, {
      extensions: ['.jsx', '.tsx']
    }],
    'tailwindcss/no-custom-classname': [0, {
      config: 'tailwind.config.js'
    }],
    'no-param-reassign': ['error', { props: true, ignorePropertyModificationsFor: ['draft'] }],
  },
};