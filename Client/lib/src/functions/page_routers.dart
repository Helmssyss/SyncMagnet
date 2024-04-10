import 'package:flutter/material.dart';
import 'package:sync_magnet/widgets/changelog_page.dart';
import 'package:sync_magnet/widgets/directory_view_page.dart';
import 'package:sync_magnet/widgets/home.dart';
import 'package:sync_magnet/widgets/image_view.dart';
import 'package:sync_magnet/widgets/music_view_page.dart';
import 'package:sync_magnet/widgets/pdf_viewer.dart';
import 'package:sync_magnet/widgets/text_view_page.dart';
import 'package:sync_magnet/widgets/video_viewer.dart';

class PageRouters {
  static Route<dynamic>? goRouters({required RouteSettings settings}) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const Home(),
        );

      case '/view_directory':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const DirectoryViewPage(),
        );

      case '/image':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const OpenImage(),
        );

      case '/text':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const TextFileViewPage(),
        );

      case '/pdf':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const PDFViewerPage(),
        );

      case '/video':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const VideoPage(),
        );

      case '/music':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const MusicViewPage(),
        );
      case '/changelog':
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const ChangelogPage(),
        );
      default:
        return null;
    }
  }
}
