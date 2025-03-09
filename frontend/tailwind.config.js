/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      animation: {
        'gradient-x': 'gradient-x 15s ease infinite',
        'gradient-y': 'gradient-y 15s ease infinite',
        'gradient-xy': 'gradient-xy 15s ease infinite',
        'float': 'float 6s ease-in-out infinite',
        'pulse-slow': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
      },
      keyframes: {
        'gradient-x': {
          '0%, 100%': {
            'background-position': '0% 50%',
          },
          '50%': {
            'background-position': '100% 50%',
          },
        },
        'gradient-y': {
          '0%, 100%': {
            'background-position': '50% 0%',
          },
          '50%': {
            'background-position': '50% 100%',
          },
        },
        'gradient-xy': {
          '0%, 100%': {
            'background-position': '0% 0%',
          },
          '50%': {
            'background-position': '100% 100%',
          },
        },
        'float': {
          '0%, 100%': {
            transform: 'translateY(0)',
          },
          '50%': {
            transform: 'translateY(-20px)',
          },
        },
      },
      backgroundSize: {
        'auto': 'auto',
        'cover': 'cover',
        'contain': 'contain',
        '200%': '200%',
        '300%': '300%',
      },
      textShadow: {
        DEFAULT: '0 2px 4px rgba(0,0,0,0.1)',
        'md': '0 4px 8px rgba(0,0,0,0.12)',
        'lg': '0 8px 16px rgba(0,0,0,0.15)',
        'glow': '0 0 5px rgba(255,255,255,0.5), 0 0 10px rgba(255,255,255,0.3)',
      },
    },
  },
  plugins: [
    function ({ addUtilities }) {
      const newUtilities = {
        '.text-shadow': {
          textShadow: '0 2px 4px rgba(0,0,0,0.1)',
        },
        '.text-shadow-md': {
          textShadow: '0 4px 8px rgba(0,0,0,0.12)',
        },
        '.text-shadow-lg': {
          textShadow: '0 8px 16px rgba(0,0,0,0.15)',
        },
        '.text-shadow-glow': {
          textShadow: '0 0 5px rgba(255,255,255,0.5), 0 0 10px rgba(255,255,255,0.3)',
        },
        '.text-shadow-none': {
          textShadow: 'none',
        },
      }
      addUtilities(newUtilities)
    }
  ],
};
