# SAP 1b

## Prettier/ESLint/VSCode

1. npm

   ```
   npm install @vue/eslint-config-prettier
   npm install eslint-plugin-prettier
   ```

2. .eslintrc.js

   ```js
   extends: [
     'plugin:vue/essential',
     // '@vue/prettier',
     'plugin:prettier/recommended'
   ],
   rules: {
     'prettier/prettier': ['error']
   }
   ```

3. .prettierrc

   ```js
   {
     "semi": false,
     "singleQuote": true,
     "bracketSpacing": true,
     "printWidth": 100
   }
   ```

4. .vscode/settings.json

   ```js
   {
     "editor.formatOnSave": true
     "eslint.autoFixOnSave": true,
     "eslint.validate": [
       {
         "language": "vue",
         "autoFix": true
       },
       {
         "language": "html",
         "autoFix": true
       },
       {
         "language": "javascript",
         "autoFix": true
       }
     ],
   }
   ```

## Dev Setup

1. Debugging

   a. Add to build section of quasar.conf.js

   `{ devtools: 'source-map' }`

   b. Add to launch.json

   `"sourceMaps": true, "sourceMapPathOverrides": { "webpack:///*": "${webRoot}/*"`
