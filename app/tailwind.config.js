const defaultColors = require('tailwindcss/colors')

const colors = {
  ...defaultColors,
  blueGray: {
    ...defaultColors.blueGray,
    750: '#263346',
  },
}

module.exports = {
  important: true,
  purge: [],
  darkMode: 'class',
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',

      black: colors.black,
      white: colors.white,

      'blue-gray': colors.blueGray,
      'cool-gray': colors.coolGray,
      gray: colors.gray,
      'true-gray': colors.trueGray,
      'warm-gray': colors.warmGray,

      red: colors.red,
      orange: colors.orange,
      amber: colors.amber,
      yellow: colors.yellow,
      lime: colors.lime,
      green: colors.green,
      emerald: colors.emerald,
      teal: colors.teal,
      cyan: colors.cyan,
      'light-blue': colors.lightBlue,
      blue: colors.blue,
      indigo: colors.indigo,
      violet: colors.violet,
      purple: colors.purple,
      fuchsia: colors.fuchsia,
      pink: colors.pink,
      rose: colors.rose,

      // Backgrounds

      'background-one': {
        light: colors.blueGray[300],
        dark: colors.blueGray[900],
      },
      'background-two': {
        light: colors.blueGray[200],
        dark: colors.blueGray[800],
      },
      'background-three': {
        light: colors.blueGray[100],
        dark: colors.blueGray[700],
      },
      'background-four': {
        light: colors.blueGray[50],
        dark: colors.blueGray[600],
      },
      'background-five': {
        light: colors.white,
        dark: colors.blueGray[500],
      },

      // Borders

      'border-strong': {
        light: colors.blueGray[400],
        dark: colors.blueGray[400],
      },
      'border-normal': {
        light: colors.blueGray[300],
        dark: colors.blueGray[500],
      },
      'border-weak': {
        light: colors.blueGray[200],
        dark: colors.blueGray[600],
      },
      'border-accent': {
        light: colors.blue[600],
        dark: colors.blue[400],
      },
      'border-success': {
        light: colors.emerald[600],
        dark: colors.emerald[400],
      },
      'border-warning': {
        light: colors.amber[600],
        dark: colors.amber[500],
      },
      'border-danger': {
        light: colors.red[600],
        dark: colors.red[400],
      },

      // Buttons

      'button-primary': {
        light: colors.blue[600],
        dark: colors.blue[600],
      },
      'button-primary-hovered': {
        light: colors.blue[700],
        dark: colors.blue[700],
      },
      'button-primary-active': {
        light: colors.blue[800],
        dark: colors.blue[800],
      },
      'button-primary-disabled': {
        light: colors.blue[600],
        dark: colors.blue[600],
      },

      'button-secondary': {
        light: colors.blueGray[50],
        dark: colors.blueGray[50],
      },
      'button-secondary-hovered': {
        light: colors.blueGray[100],
        dark: colors.blueGray[100],
      },
      'button-secondary-active': {
        light: colors.blueGray[200],
        dark: colors.blueGray[200],
      },
      'button-secondary-disabled': {
        light: colors.blueGray[200],
        dark: colors.blueGray[200],
      },

      'button-success': {
        light: colors.emerald[700],
        dark: colors.emerald[700],
      },
      'button-success-hovered': {
        light: colors.emerald[800],
        dark: colors.emerald[800],
      },
      'button-success-active': {
        light: colors.emerald[900],
        dark: colors.emerald[900],
      },
      'button-success-disabled': {
        light: colors.emerald[700],
        dark: colors.emerald[700],
      },

      'button-warning': {
        light: colors.amber[700],
        dark: colors.amber[700],
      },
      'button-warning-hovered': {
        light: colors.amber[800],
        dark: colors.amber[800],
      },
      'button-warning-active': {
        light: colors.amber[900],
        dark: colors.amber[900],
      },
      'button-warning-disabled': {
        light: colors.amber[700],
        dark: colors.amber[700],
      },

      'button-danger': {
        light: colors.red[600],
        dark: colors.red[600],
      },
      'button-danger-hovered': {
        light: colors.red[700],
        dark: colors.red[700],
      },
      'button-danger-active': {
        light: colors.red[800],
        dark: colors.red[800],
      },
      'button-danger-disabled': {
        light: colors.red[600],
        dark: colors.red[600],
      },

      // Icons

      'icon-primary': {
        light: colors.blueGray[600],
        dark: colors.blueGray[600],
      },
      'icon-secondary': {
        light: colors.blueGray[400],
        dark: colors.blueGray[400],
      },
      'icon-tertiary': {
        light: colors.white,
        dark: colors.white,
      },
      'icon-accent': {
        light: colors.blue[500],
        dark: colors.blue[500],
      },
      'icon-success': {
        light: colors.emerald[600],
        dark: colors.emerald[600],
      },
      'icon-warning': {
        light: colors.amber[600],
        dark: colors.amber[600],
      },
      'icon-danger': {
        light: colors.red[600],
        dark: colors.red[600],
      },

      // Text

      'text-primary': {
        light: colors.blueGray[900],
        dark: colors.blueGray[100],
      },
      'text-secondary': {
        light: colors.blueGray[600],
        dark: colors.blueGray[400],
      },
      'text-tertiary': {
        light: colors.white[700],
      },
      'text-accent': {
        light: colors.blue[700],
        dark: colors.blue[300],
      },
      'text-disabled': {
        light: colors.blueGray[600],
        dark: colors.blueGray[400],
      },
      'text-success': {
        light: colors.emerald[700],
        dark: colors.emerald[400],
      },
      'text-warning': {
        light: colors.amber[700],
        dark: colors.amber[500],
      },
      'text-danger': {
        light: colors.red[700],
        dark: colors.red[400],
      },

      // Background color used by various Blueprint components including Dialog

      'background-blueprint-app': {
        light: colors.blueGray[100],
        dark: colors.blueGray[800],
      },

      // Border color used by Blueprint inputs

      'border-blueprint-input': {
        light: colors.blueGray[300],
        dark: colors.blueGray[900],
      },

      // Background color for floating elements (e.g. hover toolbars and canvas navigator)

      'background-floating': {
        light: colors.white,
        dark: colors.blueGray[700],
      },

      // Background color for auth, workspace and similar screens

      'background-app': {
        light: colors.blue[50],
        dark: colors.blueGray[900],
      },
    },
    fontSize: {
      xs: '0.75rem',
      sm: '0.875rem',
      base: '1rem',
      lg: '1.125rem',
      xl: '1.25rem',
      '2xl': '1.5rem',
      '3xl': '1.875rem',
      '4xl': '2.25rem',
      '5xl': '3rem',
      '6xl': '4rem',
    },
    extend: {
      opacity: {
        15: '0.15',
      },
      cursor: {
        copy: 'copy',
        crosshair: 'crosshair',
      },
      inset: {
        '-2': '-0.5rem',
        '-4': '-1rem',
        '-8': '-2rem',
        '-10': '-2.5rem',
        '-16': '-4rem',
        '-20': '-5rem',
      },
      spacing: {
        70: '17.5rem',
      },
      borderRadius: {
        xl: '1rem',
      },
    },
  },
  variants: {
    borderWidth: ['first', 'last'],
    extend: {
      backgroundOpacity: ['dark'],
      borderOpacity: ['dark'],
      boxShadow: ['dark'],
    },
  },
  plugins: [],
}
