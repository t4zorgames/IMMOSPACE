import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/furniture_provider.dart';
import 'providers/room_provider.dart';
import 'providers/ar_provider.dart';
import 'providers/vr_provider.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/vr_screen.dart';
import 'screens/ar_screen.dart';

// Utilities
import 'utils/theme.dart';
import 'utils/constants.dart';

void main() {
  // Ensure that Flutter widget binding is initialized before starting
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => FurnitureProvider()),
        ChangeNotifierProvider(create: (_) => ARProvider()),
        ChangeNotifierProvider(create: (_) => VRProvider()),
      ],
      child: const ImmoSpaceApp(),
    ),
  );
}

/// The root widget of the ImmoSpace Application.
/// Configures state providers, themes, named routes, and screen unit scaling.
class ImmoSpaceApp extends StatelessWidget {
  const ImmoSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme loaded from custom AppTheme utility
      theme: AppTheme.darkTheme,
      
      // Initial named route
      initialRoute: '/',
      
      // Named navigation routes configuration
      routes: {
        '/': (context) => const HomeScreen(),
        '/vr': (context) => const VRScreen(),
        '/ar': (context) => const ARScreen(),
      },
      
      // LogicalPixelUnit adaptation
      // Adapts screen dimensions and text scale factors dynamically to prevent
      // layout breakage on high-DPI screens or custom accessibility setups.
      builder: (context, child) {
        final MediaQueryData mediaQueryData = MediaQuery.of(context);
        
        // Clamp text scale factor between 0.85 and 1.2 to preserve typography proportions
        final double adaptedTextScale = mediaQueryData.textScaleFactor.clamp(0.85, 1.2);
        
        // Apply adapted constraints to the entire application widget tree
        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaleFactor: adaptedTextScale,
          ),
          child: child!,
        );
      },
    );
  }
}
