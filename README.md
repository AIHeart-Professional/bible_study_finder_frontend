# Bible Study Frontend Application

A modern, responsive Angular application for Bible study with TypeScript and SCSS.

## Features

- 🎨 Modern, responsive design with beautiful UI
- 📖 Interactive Bible study tools and resources
- 👥 Community features for group study
- 📊 Progress tracking for study plans
- 🎯 Multiple study plans and difficulty levels
- 📱 Mobile-friendly responsive design

## Tech Stack

- **Angular 17** - Modern web framework
- **TypeScript** - Type-safe JavaScript
- **SCSS** - Advanced CSS with variables and mixins
- **Standalone Components** - Modern Angular architecture
- **Lazy Loading** - Optimized performance

## Getting Started

### Prerequisites

- Node.js (version 18 or higher)
- npm or yarn package manager

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm start
   ```

4. Open your browser and navigate to `http://localhost:4200`

### Available Scripts

- `npm start` - Start development server
- `npm run build` - Build for production
- `npm run watch` - Build in watch mode
- `npm test` - Run unit tests
- `npm run lint` - Run linting

## Project Structure

```
src/
├── app/
│   ├── pages/
│   │   ├── home/          # Home page component
│   │   ├── study/         # Study page component
│   │   └── about/         # About page component
│   ├── app.component.*    # Root component
│   └── app.routes.ts      # Application routing
├── assets/                # Static assets
├── styles.scss           # Global styles
├── index.html            # Main HTML file
└── main.ts               # Application bootstrap

```

## Features Overview

### Home Page
- Hero section with call-to-action
- Feature highlights
- Modern gradient design

### Study Page
- Daily verse display
- Study plan management with progress tracking
- Quick study tools (Search, Notes, Journal)
- Interactive progress bars

### About Page
- Mission statement
- Team member profiles
- Core values and contact information

## Styling

The application uses a modern design system with:
- Custom SCSS variables and mixins
- Responsive grid layouts
- Beautiful gradients and shadows
- Smooth animations and transitions
- Mobile-first responsive design

## Development

This project uses Angular's standalone components architecture for better tree-shaking and performance. Each page is lazy-loaded for optimal loading times.

### Adding New Components

To add a new component:
1. Create the component files in the appropriate directory
2. Make it standalone by including `standalone: true`
3. Add necessary imports to the component
4. Update routing if needed

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.
