# Flutter Developer Portfolio Landing Page

A beautifully designed, responsive portfolio landing page built with Flutter web for a Flutter developer. This project follows the MVVM (Model-View-ViewModel) architecture with BLoC state management, making it maintainable and easy to customize.

## Features

- Responsive design with adaptive layouts for mobile and desktop
- Dynamic blog posts loading from Medium API/RSS feed
- Smooth navigation with animated transitions
- Interactive sidebar for easy section navigation
- Light/dark theme toggle with user preference persistence
- Professional design with consistent spacing and typography
- Timeline-based experience and education display
- Portfolio project showcase with image carousels
- Interactive tech stack visualization
- Contact form with validation
- Resume download functionality

## Architecture

The project follows MVVM architecture pattern:

- **Models**: Data structures that represent the domain entities
- **Views**: UI components and screens
- **ViewModels**: BLoC classes that handle business logic and state management

### Project Structure

```
lib/
├── core/
│   ├── navigation/
│   ├── theme/
├── features/
│   ├── portfolio/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   ├── services/
│   │   ├── presentation/
│   │   │   ├── bloc/
│   │   │   ├── pages/
│   │   │   ├── widgets/
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Update the Medium username in `lib/features/portfolio/data/services/medium_service.dart`
4. Update profile data in `lib/features/portfolio/data/repositories/portfolio_repository.dart`
5. Run `flutter run -d chrome --web-renderer canvaskit` for best web performance

## Customization

### Personal Information

Update your personal information in the `getProfileData` method of the `PortfolioRepository` class:

- Name, title, and introduction
- About text
- Work experiences
- Education history
- Portfolio projects
- Services offered
- Tech stack
- Contact information

### Blog Integration

The portfolio automatically fetches blog posts from Medium. To use your own Medium blog:

1. Open `lib/features/portfolio/data/services/medium_service.dart`
2. Replace `username` in the `_baseUrl` constant with your Medium username

### Styling

The application uses a customizable theme defined in `lib/core/theme/app_theme.dart`. You can modify:

- Color scheme
- Typography
- Spacing
- Border radius
- Button styles
- Input field styles

## Deployment

To deploy your portfolio to a web hosting service:

1. Run `flutter build web --web-renderer canvaskit --release`
2. Upload the contents of the `build/web` directory to your hosting provider

## License

This project is open source and available under the MIT License.