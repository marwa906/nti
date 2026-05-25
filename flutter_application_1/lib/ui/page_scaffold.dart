part of '../main.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    this.title,
    this.subtitle,
    this.showBack = false,
    this.onBack,
    this.actions = const <Widget>[],
    required this.child,
    this.floatingActionButton,
  });

  final String? title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = floatingActionButton == null ? 16 : 98;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, bottomPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (title != null || showBack || actions.isNotEmpty) ...[
                        Row(
                          children: <Widget>[
                            if (showBack)
                              BackCircleButton(
                                onTap: onBack ?? context.store.pop,
                              ),
                            if (showBack) const SizedBox(width: 12),
                            if (title != null)
                              Expanded(
                                child: Text(
                                  title!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ...actions,
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      Expanded(child: child),
                    ],
                  ),
                ),
                if (floatingActionButton != null)
                  PositionedDirectional(
                    end: 20,
                    bottom: 20,
                    child: floatingActionButton!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

